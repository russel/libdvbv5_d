/*
 * Copyright (c) 2013-2014 - Mauro Carvalho Chehab <m.chehab@samsung.com>
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

module libdvbv5_d.desc_atsc_service_location;

import libdvbv5_d.descriptors: dvb_desc;

extern (C):

/**
 * @file desc_atsc_service_location.h
 * @ingroup descriptors
 * @brief Provides the descriptors for ATSC service location
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * -  ATSC A/53
 *
 * @see http://www.etherguidesystems.com/help/sdos/atsc/semantics/descriptors/ServiceLocation.aspx
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/**
 * @struct atsc_desc_service_location_elementary
 * @ingroup descriptors
 * @brief service location elementary descriptors
 *
 * @param stream_type		stream type
 * @param elementary_pid	elementary pid
 * @param ISO_639_language_code	ISO 639 language code
 */
struct atsc_desc_service_location_elementary
{
    align (1):

    ubyte stream_type;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "elementary_pid", 13,
                ushort, "reserved", 3));
        }
    }

    char[3] ISO_639_language_code;
}

/**
 * @struct atsc_desc_service_location
 * @ingroup descriptors
 * @brief Describes the elementary streams inside a PAT table for ATSC
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param elementary		pointer to struct atsc_desc_service_location_elementary
 * @param pcr_pid		PCR pid
 * @param number_elements	number elements
 */
struct atsc_desc_service_location
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    atsc_desc_service_location_elementary* elementary;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "pcr_pid", 13,
                ushort, "reserved", 3));
        }
    }

    ubyte number_elements;
}

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the service location descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf	buffer containing the descriptor's raw data
 * @param desc	pointer to struct dvb_desc to be allocated and filled
 *
 * This function allocates a the descriptor and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
int atsc_desc_service_location_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the service location descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void atsc_desc_service_location_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the service location descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void atsc_desc_service_location_free (dvb_desc* desc);
