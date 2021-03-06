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
 * Described on ARIB STD-B10 as Terrestrial delivery system descriptor
 */

/**
 * @file desc_isdbt_delivery.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the ISDB-T terrestrial delivery system
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

module libdvbv5_d.desc_isdbt_delivery;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct isdbt_desc_terrestrial_delivery_system
 * @ingroup descriptors
 * @brief Struct containing the ISDB-T terrestrial delivery system
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param area_code		area code. The area code definition varies from
 *				Country to Country.
 * @param guard_interval	guard interval
 * @param transmission_mode	transmission mode
 * @param frequency		vector with center frequencies
 * @param num_freqs		number of frequencies at the
 * 				isdbt_desc_terrestrial_delivery_system::frequency vector
 */
struct isdbt_desc_terrestrial_delivery_system
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    uint* frequency;
    uint num_freqs;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "transmission_mode", 2,
                ushort, "guard_interval", 2,
                ushort, "area_code", 12));
        }
    }
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the ISDB-T terrestrial delivery system
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
int isdbt_desc_delivery_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the ISDB-T terrestrial delivery system
 *	  descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void isdbt_desc_delivery_print (dvb_v5_fe_parms* parms, const(dvb_desc)* desc);

/**
 * @brief Frees all data allocated by the ISDB-T terrestrial delivery system
 *	  descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void isdbt_desc_delivery_free (dvb_desc* desc);

/**
 * Converts an ISDB-T Interval code into a string
 */
extern __gshared const(uint)[] isdbt_interval;

/**
 * Converts an ISDB-T mode into a string
 */
extern __gshared const(uint)[] isdbt_mode;
