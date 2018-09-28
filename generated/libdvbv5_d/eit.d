/*
 * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
 * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation version 2.1 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 *
 */

/**
 * @file eit.h
 * @ingroup dvb_table
 * @brief Provides the table parser for the DVB EIT (Event Information Table)
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Relevant specs
 * The table described herein is defined at:
 * - ETSI EN 300 468
 *
 * @see
 * http://www.etherguidesystems.com/Help/SDOs/dvb/syntax/tablesections/EIT.aspx
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.eit;

import core.stdc.time: tm;
import core.sys.posix.unistd;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;
import libdvbv5_d.header: dvb_table_header;

extern (C):

/* ssize_t */

/**
 * @def DVB_TABLE_EIT
 *	@brief DVB EIT table ID for the actual TS
 *	@ingroup dvb_table
 * @def DVB_TABLE_EIT_OTHER
 *	@brief DVB EIT table ID for other TS
 *	@ingroup dvb_table
 * @def DVB_TABLE_EIT_PID
 *	@brief DVB EIT Program ID
 *	@ingroup dvb_table
 * @def DVB_TABLE_EIT_SCHEDULE
 *	@brief Start table ID for the DVB EIT schedule data on the actual TS
 *		The range has 0x0f elements (0x50 to 0x5F).
 *	@ingroup dvb_table
 * @def DVB_TABLE_EIT_SCHEDULE_OTHER
 *	@brief Start table ID for the DVB EIT schedule data on other TS
 *		The range has 0x0f elements (0x60 to 0x6F).
 *	@ingroup dvb_table
 */
enum DVB_TABLE_EIT = 0x4E;
enum DVB_TABLE_EIT_OTHER = 0x4F;
enum DVB_TABLE_EIT_PID = 0x12;

enum DVB_TABLE_EIT_SCHEDULE = 0x50;
enum DVB_TABLE_EIT_SCHEDULE_OTHER = 0x60;

/**
 * @struct dvb_table_eit_event
 * @brief DVB EIT event table
 * @ingroup dvb_table
 *
 * @param event_id		an uniquelly (inside a service ID) event ID
 * @param desc_length		descriptor's length
 * @param free_CA_mode		free CA mode. 0 indicates that the event
 *				is not scrambled
 * @param running_status	running status of the event. The status can
 *				be translated to string via
 *				dvb_eit_running_status_name string table.
 * @param descriptor		pointer to struct dvb_desc
 * @param next			pointer to struct dvb_table_eit_event
 * @param tm_start		event start (in struct tm format)
 * @param duration		duration in seconds
 * @param service_id		service ID
 *
 * This structure is used to store the original EIT event table,
 * converting the integer fields to the CPU endianness, and converting the
 * timestamps to a way that it is better handled on Linux.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after dvb_table_eit_event::descriptor (including it) won't
 * be bit-mapped to the data parsed from the MPEG TS. So, metadata are added
 * there.
 */
struct dvb_table_eit_event
{
    align (1):

    ushort event_id;

    union
    {
        align (1):

        ushort bitfield1; /* first 2 bytes are MJD, they need to be bswapped */
        ubyte[5] dvbstart;
    }

    ubyte[3] dvbduration;

    union
    {
        align (1):

        ushort bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "desc_length", 12,
                ushort, "free_CA_mode", 1,
                ushort, "running_status", 3));
        }
    }

    // struct dvb_desc;
    dvb_desc* descriptor;
    dvb_table_eit_event* next;
    tm start;
    uint duration;
    ushort service_id;
}

/**
 * @struct dvb_table_eit
 * @brief DVB EIT table
 * @ingroup dvb_table
 *
 * @param header	struct dvb_table_header content
 * @param transport_id	transport id
 * @param network_id	network id
 * @param last_segment	last segment
 * @param last_table_id	last table id
 * @param event		pointer to struct dvb_table_eit_event
 *
 * This structure is used to store the original EIT table,
 * converting the integer fields to the CPU endianness.
 *
 * Everything after dvb_table_eit::event (including it) won't
 * be bit-mapped to the data parsed from the MPEG TS. So, metadata are added
 * there.
 */
struct dvb_table_eit
{
    align (1):

    dvb_table_header header;
    ushort transport_id;
    ushort network_id;
    ubyte last_segment;
    ubyte last_table_id;
    dvb_table_eit_event* event;
}

/**
 * @brief Macro used to find event on a DVB EIT table
 * @ingroup dvb_table
 *
 * @param _event	event to seek
 * @param _eit		pointer to struct dvb_table_eit_event
 */

// struct dvb_v5_fe_parms;

/** @brief Converts a running_status field into string */
extern __gshared const(char)*[8] dvb_eit_running_status_name;

/**
 * @brief Initializes and parses EIT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf buffer containing the EIT raw data
 * @param buflen length of the buffer
 * @param table pointer to struct dvb_table_eit to be allocated and filled
 *
 * This function allocates an EIT table and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
ssize_t dvb_table_eit_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    ssize_t buflen,
    dvb_table_eit** table);

/**
 * @brief Frees all data allocated by the DVB EIT table parser
 * @ingroup dvb_table
 *
 * @param table pointer to struct dvb_table_eit to be freed
 */
void dvb_table_eit_free (dvb_table_eit* table);

/**
 * @brief Prints the content of the DVB EIT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param table pointer to struct dvb_table_eit
 */
void dvb_table_eit_print (dvb_v5_fe_parms* parms, dvb_table_eit* table);

/**
 * @brief Converts a DVB EIT formatted timestamp into struct tm
 * @ingroup dvb_table
 *
 * @param data		event on DVB EIT time format
 * @param tm		pointer to struct tm where the converted timestamp will
 *			be stored.
 */
void dvb_time (ref const(ubyte)[5] data, tm* tm);
