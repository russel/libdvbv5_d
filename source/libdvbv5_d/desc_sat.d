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

/**
 * @file desc_sat.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the satellite delivery system descriptor
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

module libdvbv5_d.desc_sat;

extern (C):

/**
 * @struct dvb_desc_sat
 * @ingroup descriptors
 * @brief Structure containing the satellite delivery system descriptor
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param frequency		frequency in kHz
 * @param orbit			orbital position in degrees (multiplied by 10)
 * @param west_east		west east flag. 0 = west, 1 = east
 * @param polarization		polarization. 0 = horizontal, 1 = vertical,
 *				2 = left, 3 = right.
 * @param roll_off		roll off alpha factor. 0 = 0.35, 1 = 0.25,
 * 				2 = 0.20, 3 = reserved.
 * @param modulation_system	modulation system. 0 = DVB-S, 1 = DVB-S2.
 * @param modulation_type	modulation type. 0 = auto, 1 = QPSK, 2 = 8PSK,
 *				3 = 16-QAM (only for DVB-S2).
 * @param symbol_rate		symbol rate in Kbauds.
 * @param fec			inner FEC (convolutional code)
 */
struct dvb_desc_sat
{
    import std.bitmanip : bitfields;
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    uint frequency;
    ushort orbit;

    mixin(bitfields!(
        ubyte, "modulation_type", 2,
        ubyte, "modulation_system", 1,
        ubyte, "roll_off", 2,
        ubyte, "polarization", 2,
        ubyte, "west_east", 1));

    union
    {
        align (1):

        uint bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "fec", 4,
                uint, "symbol_rate", 28));
        }
    }
}

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the satellite delivery system descriptor
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
int dvb_desc_sat_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the satellite delivery system descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_sat_print (dvb_v5_fe_parms* parms, const(dvb_desc)* desc);

/**
 * @brief converts from the descriptor's FEC into enum fe_code_rate,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbs_dvbc_dvbs_freq_inner;

/**
 * @brief converts from the descriptor's polarization into
 *	  enum dvb_sat_polarization, as defined at dvb-v5-std.h.
 */
extern __gshared const(uint)[] dvbs_polarization;

/**
 * @brief converts from the descriptor's rolloff into  enum fe_rolloff,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbs_rolloff;

/**
 * @brief converts from the descriptor's modulation into enum fe_modulation,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbs_modulation;

