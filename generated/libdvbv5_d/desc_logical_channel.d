/*
 * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
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
 * Described on IEC/CENELEC DS/EN 62216-1:2011
 *
 * I couldn't find the original version, so I used what's there at:
 *	http://tdt.telecom.pt/recursos/apresentacoes/Signalling Specifications for DTT deployment in Portugal.pdf
 */

/**
 * @file desc_logical_channel.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the LCN - Logican Channel Number
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - IEC/CENELEC DS/EN 62216-1:2011
 *
 * @see http://tdt.telecom.pt/recursos/apresentacoes/Signalling Specifications for DTT deployment in Portugal.pdf
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_logical_channel;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct dvb_desc_logical_channel_number
 * @ingroup descriptors
 * @brief Structure containing the logical channel number entires
 *
 * @param service_id			service id
 * @param visible_service_flag		visible service flag
 * @param logical_channel_number	logical channel number
 */

struct dvb_desc_logical_channel_number
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
                ushort, "logical_channel_number", 10,
                ushort, "reserved", 5,
                ushort, "visible_service_flag", 1));
        }
    }
}

/**
 * @struct dvb_desc_logical_channel
 * @ingroup descriptors
 * @brief Structure containing the logical channel number descriptor
 *
 * @param type		descriptor tag
 * @param length	descriptor length
 * @param next		pointer to struct dvb_desc
 * @param lcn		pointer to struct dvb_desc_logical_channel_number
 */
struct dvb_desc_logical_channel
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    dvb_desc_logical_channel_number* lcn;
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the logical channel number descriptor
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
int dvb_desc_logical_channel_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the logical channel number descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_logical_channel_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the logical channel number descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void dvb_desc_logical_channel_free (dvb_desc* desc);
