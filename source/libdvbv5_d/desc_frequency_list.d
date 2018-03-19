/*
 * Copyright (c) 2011-2014 - Mauro Carvalho Chehab
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

module libdvbv5_d.desc_frequency_list;

extern (C):

/**
 * @file desc_frequency_list.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the frequency list descriptor.
 *	  This descriptor lists the additional frequencies used in transmission
 *	  of a multiplex on other frequencies.
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ETSI EN 300 468 V1.11.1
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/**
 * @struct dvb_desc_frequency_list
 * @ingroup descriptors
 * @brief Struct containing the frequency list descriptor
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param frequencies		number of frequencies in the frequency vector
 * @param frequency		vector with the centre frequency
 * @param freq_type		freq type, being: 0 = undefined,
 * 				1 = satelite, 2 = cable or 3 = terrestrial.
 */
struct dvb_desc_frequency_list
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    ubyte frequencies;
    uint* frequency;

    union
    {
        align (1):

        ubyte bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ubyte, "freq_type", 2,
                ubyte, "reserved", 6));
        }
    }
}

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the frequency list descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf	buffer containing the descriptor's raw data
 * @param desc	pointer to struct dvb_desc to be allocated and filled
 *
 * This function initializes and makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * Currently, no memory is allocated internally.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
int dvb_desc_frequency_list_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the frequency list descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_frequency_list_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

