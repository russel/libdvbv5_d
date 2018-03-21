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
 * @file desc_ca_identifier.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the Conditional Access identifier
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Andre Roth
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ETSI EN 300 468 V1.11.1 (2010-04)
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_ca_identifier;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct dvb_desc_ca_identifier
 * @ingroup descriptors
 * @brief Indicates if a particular bouquet, service or event is associated
 *	  with a CA system
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param caid_count		Number of CA IDs
 * @param caids			CA Identifier IDs
 */
struct dvb_desc_ca_identifier
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    ubyte caid_count;
    ushort* caids;
}

// struct dvb_v5_fe_parms;

/** @brief initial descriptor field at dvb_desc_ca_identifier struct */
// enum dvb_desc_ca_identifier_field_first = ca_id;
/** @brief last descriptor field at dvb_desc_ca_identifier struct */
// enum dvb_desc_ca_identifier_field_last = privdata;

/**
 * @brief Initializes and parses the CA identifier descriptor
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
int dvb_desc_ca_identifier_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the CA identifier descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_ca_identifier_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the CA identifier descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void dvb_desc_ca_identifier_free (dvb_desc* desc);
