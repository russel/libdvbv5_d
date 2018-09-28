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
 * Described on ARIB STD-B10 as TS information descriptor
 */

/**
 * @file desc_ts_info.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the ISDB TS information descriptor.
 * The TS information descriptor specifies the remote control key
 * identifier assigned to the applicable TS and indicates the relationship
 * between the service identifier and the transmission layer during
 * hierarchical transmission.
 *
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ARIB STD-B10
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_ts_info;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct dvb_desc_ts_info_transmission_type
 * @ingroup descriptors
 * @brief ISDB TS information transmission type
 *
 * @param transmission_type_info	transmission type info
 * @param num_of_service	num of service
 */
struct dvb_desc_ts_info_transmission_type
{
    align (1):

    ubyte transmission_type_info;
    ubyte num_of_service;
}

/**
 * @struct dvb_desc_ts_info
 * @ingroup descriptors
 * @brief Structure describing the ISDB TS information descriptor.
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param remote_control_key_id	remote control key id
 * @param length_of_ts_name	length of ts name
 * @param transmission_type_count	transmission type count
 *
 * @param ts_name		ts name string
 * @param ts_name_emph		ts name emphasis string
 * @param transmission_type	struct dvb_desc_ts_info_transmission_type content
 * @param service_id		service id vector
 */
struct dvb_desc_ts_info
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    char* ts_name;
    char* ts_name_emph;
    dvb_desc_ts_info_transmission_type transmission_type;
    ushort* service_id;

    union
    {
        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ubyte, "transmission_type_count", 2,
                ubyte, "length_of_ts_name", 6,
                ubyte, "remote_control_key_id", 8));
        }
    }
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the ISDB TS information descriptor.
 * 	  descriptor
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
int dvb_desc_ts_info_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the ISDB TS information descriptor.
 *	  descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_ts_info_print (dvb_v5_fe_parms* parms, const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the ISDB TS information descriptor.
 *	  descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void dvb_desc_ts_info_free (dvb_desc* desc);