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

module libdvbv5_d.nit;

import core.sys.posix.unistd;

extern (C):

/* ssize_t */

/**
 * @file nit.h
 * @ingroup dvb_table
 * @brief Provides the descriptors for NIT MPEG-TS table
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Bug Report
 * Please submit bug report and patches to linux-media@vger.kernel.org
 *
 * @par Relevant specs
 * The table described herein is defined at:
 * - ISO/IEC 13818-1
 * - ETSI EN 300 468
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/**
 * @def DVB_TABLE_NIT
 *	@brief NIT table ID
 *	@ingroup dvb_table
 * @def DVB_TABLE_NIT2
 *	@brief NIT table ID (alternative table ID)
 *	@ingroup dvb_table
 * @def DVB_TABLE_NIT_PID
 *	@brief NIT Program ID
 *	@ingroup dvb_table
 */
enum DVB_TABLE_NIT = 0x40;
enum DVB_TABLE_NIT2 = 0x41;
enum DVB_TABLE_NIT_PID = 0x10;

/**
 * @union dvb_table_nit_transport_header
 * @brief MPEG-TS NIT transport header
 * @ingroup dvb_table
 *
 * @param transport_length	transport length
 *
 * This structure is used to store the original NIT transport header,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 */
union dvb_table_nit_transport_header
{
    align (1):

    ushort bitfield;

    struct
    {
        import std.bitmanip : bitfields;
        align (1):

        mixin(bitfields!(
            ushort, "transport_length", 12,
            ushort, "reserved", 4));
    }
}

/**
 * @struct dvb_table_nit_transport
 * @brief MPEG-TS NIT transport table
 * @ingroup dvb_table
 *
 * @param transport_id	transport id
 * @param network_id	network id
 * @param desc_length	desc length
 * @param descriptor	pointer to struct dvb_desc
 * @param next		pointer to struct dvb_table_nit_transport
 *
 * This structure is used to store the original NIT transport table,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after dvb_table_nit_transport::descriptor (including it) won't
 * be bit-mapped to the data parsed from the MPEG TS. So, metadata are added
 * there.
 */
struct dvb_table_nit_transport
{
    align (1):

    ushort transport_id;
    ushort network_id;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "desc_length", 12,
                ushort, "reserved", 4));
        }
    }

    dvb_desc* descriptor;
    dvb_table_nit_transport* next;
}

/**
 * @struct dvb_table_nit
 * @brief MPEG-TS NIT table
 * @ingroup dvb_table
 *
 * @param header	struct dvb_table_header content
 * @param desc_length	descriptor length
 * @param descriptor	pointer to struct dvb_desc
 * @param transport	pointer to struct dvb_table_nit_transport
 *
 * This structure is used to store the original NIT table,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after dvb_table_nit::descriptor (including it) won't be bit-mapped
 * to the data parsed from the MPEG TS. So, metadata are added there.
 */
struct dvb_table_nit
{
    align (1):

    dvb_table_header header;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "desc_length", 12,
                ushort, "reserved", 4));
        }
    }

    dvb_desc* descriptor;
    dvb_table_nit_transport* transport;
}

/**
 * @brief typedef for a callback used when a NIT table entry is found
 * @ingroup dvb_table
 *
 * @param nit	a struct dvb_table_nit pointer
 * @param desc	a struct dvb_desc pointer
 * @param priv	an opaque optional pointer
 */
alias nit_handler_callback_t = void function (
    dvb_table_nit* nit,
    dvb_desc* desc,
    void* priv);

/**
 * @brief typedef for a callback used when a NIT transport table entry is found
 * @ingroup dvb_table
 *
 * @param nit	a struct dvb_table_nit pointer
 * @param tran	a struct dvb_table_nit_transport pointer
 * @param desc	a struct dvb_desc pointer
 * @param priv	an opaque optional pointer
 */
alias nit_tran_handler_callback_t = void function (
    dvb_table_nit* nit,
    dvb_table_nit_transport* tran,
    dvb_desc* desc,
    void* priv);

/**
 * @brief Macro used to find a transport inside a NIT table
 * @ingroup dvb_table
 *
 * @param _tran		transport to seek
 * @param _nit		pointer to struct dvb_table_nit_transport
 */

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses NIT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf buffer containing the NIT raw data
 * @param buflen length of the buffer
 * @param table pointer to struct dvb_table_nit to be allocated and filled
 *
 * This function allocates a NIT table and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
ssize_t dvb_table_nit_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    ssize_t buflen,
    dvb_table_nit** table);

/**
 * @brief Frees all data allocated by the NIT table parser
 * @ingroup dvb_table
 *
 * @param table pointer to struct dvb_table_nit to be freed
 */
void dvb_table_nit_free (dvb_table_nit* table);

/**
 * @brief Prints the content of the NIT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param table	pointer to struct dvb_table_nit
 */
void dvb_table_nit_print (dvb_v5_fe_parms* parms, dvb_table_nit* table);

/**
 * @brief For each entry at NIT and NIT transport tables, call a callback
 * @ingroup dvb_table
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param table		pointer to struct dvb_table_nit
 * @param descriptor	indicates the NIT table descriptor to seek
 * @param call_nit	a nit_handler_callback_t function to be called when a
 *			new entry at the NIT table is found (or NULL).
 * @param call_tran	a nit_tran_handler_callback_t function to be called
 *			when a new entry at the NIT transport table is found
 *			(or NULL).
 * @param priv		an opaque pointer to be optionally used by the
 *			callbacks. The function won't touch on it, just use
 *			as an argument for the callback functions.
 *
 * When parsing a NIT entry, we need to call some code to properly handle
 * when a given descriptor in the table is found. This is used, for example,
 * to create newer transponders to seek during scan.
 *
 * For example, to seek for the CATV delivery system descriptor and call a
 * function that would add a new transponder to a scan procedure:
 * @code
 * 	dvb_table_nit_descriptor_handler(
 *				&parms->p, dvb_scan_handler->nit,
 *				cable_delivery_system_descriptor,
 *				NULL, add_update_nit_dvbc, &tr);
 * @endcode
 */
void dvb_table_nit_descriptor_handler (
    dvb_v5_fe_parms* parms,
    dvb_table_nit* table,
    descriptors descriptor,
    void function () call_nit,
    void function () call_tran,
    void* priv);

