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
 * @file pat.h
 * @ingroup dvb_table
 * @brief Provides the descriptors for PAT MPEG-TS table
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Relevant specs
 * The table described herein is defined at:
 * - ISO/IEC 13818-1
 *
 * @see http://www.etherguidesystems.com/help/sdos/mpeg/syntax/tablesections/pat.aspx
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.pat;

import core.sys.posix.unistd;

extern (C):

/* ssize_t */

/**
 * @def DVB_TABLE_PAT
 *	@brief PAT table ID
 *	@ingroup dvb_table
 * @def DVB_TABLE_PAT_PID
 *	@brief PAT Program ID
 *	@ingroup dvb_table
 */
enum DVB_TABLE_PAT = 0x00;
enum DVB_TABLE_PAT_PID = 0x0000;

/**
 * @struct dvb_table_pat_program
 * @brief MPEG-TS PAT program table
 * @ingroup dvb_table
 *
 * @param service_id	service id
 * @param pid		pid
 * @param next		pointer to struct dvb_table_pat_program
 *
 * This structure is used to store the original PAT program table,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after dvb_table_pat_program::next (including it) won't be bit-mapped
 * to the data parsed from the MPEG TS. So, metadata are added there.
 */
struct dvb_table_pat_program
{
    align (1):

    ushort service_id;

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
                ubyte, "reserved", 3));
        }
    }

    dvb_table_pat_program* next;
}

/**
 * @struct dvb_table_pat
 * @brief MPEG-TS PAT table
 * @ingroup dvb_table
 *
 * @param header	struct dvb_table_header content
 * @param programs	number of programs
 * @param program	pointer to struct dvb_table_pat_program

 * This structure is used to store the original PAT table,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after dvb_table_pat_program::program (including it) won't be bit-mapped
 * to the data parsed from the MPEG TS. So, metadata are added there.
 */
struct dvb_table_pat
{
    align (1):

    dvb_table_header header;
    ushort programs;
    dvb_table_pat_program* program;
}

/**
 * @brief Macro used to find programs on a PAT table
 * @ingroup dvb_table
 *
 * @param _pgm		program to seek
 * @param _pat		pointer to struct dvb_table_pat_program
 */

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses PAT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf buffer containing the PAT raw data
 * @param buflen length of the buffer
 * @param table pointer to struct dvb_table_pat to be allocated and filled
 *
 * This function allocates a PAT table and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
ssize_t dvb_table_pat_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    ssize_t buflen,
    dvb_table_pat** table);

/**
 * @brief Frees all data allocated by the PAT table parser
 * @ingroup dvb_table
 *
 * @param table pointer to struct dvb_table_pat to be freed
 */
void dvb_table_pat_free (dvb_table_pat* table);

/**
 * @brief Prints the content of the PAT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param table pointer to struct dvb_table_pat
 */
void dvb_table_pat_print (dvb_v5_fe_parms* parms, dvb_table_pat* table);

