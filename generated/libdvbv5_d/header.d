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
 * Described at ISO/IEC 13818-1
 */

module libdvbv5_d.header;

import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/* ssize_t */

/**
 * @file header.h
 * @ingroup dvb_table
 * @brief Provides the MPEG TS table headers
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/**
 * @struct dvb_ts_packet_header
 * @brief Header of a MPEG-TS transport packet
 * @ingroup dvb_table
 *
 * @param sync_byte			sync byte
 * @param pid				Program ID
 * @param transport_priority		transport priority
 * @param payload_unit_start_indicator	payload unit start indicator
 * @param transport_error_indicator	transport error indicator
 * @param continuity_counter		continuity counter
 * @param adaptation_field_control	adaptation field control
 * @param transport_scrambling_control	transport scrambling control
 * @param adaptation_field_length	adaptation field length
 *
 * @see http://www.etherguidesystems.com/Help/SDOs/MPEG/Semantics/MPEG-2/transport_packet.aspx
 */
struct dvb_ts_packet_header
{
    import std.bitmanip : bitfields;
    align (1):

    ubyte sync_byte;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "pid", 13,
                ushort, "transport_priority", 1,
                ushort, "payload_unit_start_indicator", 1,
                ushort, "transport_error_indicator", 1));
        }
    }

    mixin(bitfields!(
        ubyte, "continuity_counter", 4,
        ubyte, "adaptation_field_control", 2,
        ubyte, "transport_scrambling_control", 2));

    /* Only if adaptation_field_control > 1 */
    ubyte adaptation_field_length;
    /* Only if adaptation_field_length >= 1 */
    struct
    {
        import std.bitmanip : bitfields;
        align (1):

        mixin(bitfields!(
            ubyte, "extension", 1,
            ubyte, "private_data", 1,
            ubyte, "splicing_point", 1,
            ubyte, "OPCR", 1,
            ubyte, "PCR", 1,
            ubyte, "priority", 1,
            ubyte, "random_access", 1,
            ubyte, "discontinued", 1));
    }
}

/**
 * @struct dvb_table_header
 * @brief Header of a MPEG-TS table
 * @ingroup dvb_table
 *
 * @param table_id		table id
 * @param section_length	section length
 * @param syntax		syntax
 * @param id			Table ID extension
 * @param current_next		current next
 * @param version		version
 * @param section_id		section number
 * @param last_section		last section number
 *
 * All MPEG-TS tables start with this header.
 */
struct dvb_table_header
{
    import std.bitmanip : bitfields;
    align (1):

    ubyte table_id;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "section_length", 12,
                ubyte, "one", 2,
                ubyte, "zero", 1,
                ubyte, "syntax", 1));
        }
    }

    ushort id;

    mixin(bitfields!(
        ubyte, "current_next", 1,
        ubyte, "version_", 5,
        ubyte, "one2", 2)); /* TS ID */

    ubyte section_id; /* section_number */
    ubyte last_section; /* last_section_number */
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses MPEG-TS table header
 * @ingroup dvb_table
 *
 * @param header pointer to struct dvb_table_header to be parsed
 */
void dvb_table_header_init (dvb_table_header* header);
/**
 * @brief Prints the content of the MPEG-TS table header
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param header pointer to struct dvb_table_header to be printed
 */
void dvb_table_header_print (
    dvb_v5_fe_parms* parms,
    const(dvb_table_header)* header);

