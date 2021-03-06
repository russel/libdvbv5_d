/*
 * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
 * Described at ETSI EN 300 468 V1.11.1 (2010-04)
 */

/**
 * @file desc_ca.h
 * @ingroup descriptors
 * @brief Provides the descriptors for Conditional Access
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Andre Roth
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ETSI EN 300 468 V1.11.1 (2010-04)
 *
 * @see http://www.etherguidesystems.com/help/sdos/mpeg/semantics/mpeg-2/descriptors/CA_descriptor.aspx
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_ca;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct dvb_desc_ca
 * @ingroup descriptors
 * @brief Contains the private data for Conditional Access
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param ca_id			Conditional Access ID
 * @param ca_pid		Conditional Access ID
 * @param privdata		pointer to private data buffer
 * @param privdata_len		length of the private data
 */
struct dvb_desc_ca
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    ushort ca_id;

    union
    {
        align (1):

        ushort bitfield1;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "ca_pid", 13,
                ushort, "reserved", 3));
        }
    }

    ubyte* privdata;
    ubyte privdata_len;
}

// struct dvb_v5_fe_parms;

/** @brief initial descriptor field at dvb_desc_ca struct */
// enum dvb_desc_ca_field_first = ca_id;
/** @brief last descriptor field at dvb_desc_ca struct */
// enum dvb_desc_ca_field_last = privdata;

/**
 * @brief Initializes and parses the CA descriptor
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
int dvb_desc_ca_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the CA descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_ca_print (dvb_v5_fe_parms* parms, const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the CA descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void dvb_desc_ca_free (dvb_desc* desc);
