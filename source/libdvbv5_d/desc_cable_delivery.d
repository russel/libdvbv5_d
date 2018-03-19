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
 * Described at ETSI EN 300 468 V1.11.1 (2010-04)
 */

/**
 * @file desc_cable_delivery.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the cable delivery system descriptor
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ETSI EN 300 468 V1.11.1 (2010-04)
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_cable_delivery;

extern (C):

/**
 * @struct dvb_desc_cable_delivery
 * @ingroup descriptors
 * @brief Structure containing the cable delivery system descriptor
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param frequency		frequency, converted to Hz.
 * @param fec_outer		FEC outer (typically, Viterbi)
 * @param modulation		modulation
 * @param fec_inner		FEC inner (convolutional code)
 * @param symbol_rate		symbol rate, converted to symbols/sec (bauds)
 */
struct dvb_desc_cable_delivery
{
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    uint frequency;

    union
    {
        align (1):

        ushort bitfield1;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "fec_outer", 4,
                ushort, "reserved_future_use", 12));
        }
    }

    ubyte modulation;

    union
    {
        align (1):

        uint bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "fec_inner", 4,
                uint, "symbol_rate", 28));
        }
    }
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
 * This function initializes and makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * Currently, no memory is allocated internally.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
int dvb_desc_cable_delivery_init (
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
void dvb_desc_cable_delivery_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

/**
 * @brief converts from the descriptor's modulation into enum fe_modulation,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbc_modulation_table;

/**
 * @brief converts from the descriptor's FEC into enum fe_code_rate,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbc_fec_table;

