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
 * Based on ETSI EN 300 468 V1.11.1 (2010-04)
 *
 */

/**
 * @file desc_terrestrial_delivery.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the DVB-T terrestrial delivery system descriptor
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

module libdvbv5_d.desc_terrestrial_delivery;

import libdvbv5_d.descriptors: dvb_desc;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @struct dvb_desc_terrestrial_delivery
 * @ingroup descriptors
 * @brief Structure containing the DVB-T terrestrial delivery system descriptor
 *
 * @param type			descriptor tag
 * @param length		descriptor length
 * @param next			pointer to struct dvb_desc
 * @param centre_frequency	centre frequency, multiplied by 10 Hz
 * @param bandwidth		bandwidth
 * @param priority		priority (0 = LP, 1 = HP)
 * @param time_slice_indicator	time slicing indicator
 * @param mpe_fec_indicator	mpe fec indicator. If 1, MPE-FEC is not used.
 * @param constellation		constellation
 * @param hierarchy_information	hierarchy information
 * @param code_rate_hp_stream	code rate hp stream
 * @param code_rate_lp_stream	code rate lp stream
 * @param guard_interval	guard interval
 * @param transmission_mode	transmission mode
 * @param other_frequency_flag	other frequency flag
 */
struct dvb_desc_terrestrial_delivery
{
    import std.bitmanip : bitfields;
    align (1):

    ubyte type;
    ubyte length;
    dvb_desc* next;

    uint centre_frequency;

    mixin(bitfields!(
        ubyte, "reserved_future_use1", 2,
        ubyte, "mpe_fec_indicator", 1,
        ubyte, "time_slice_indicator", 1,
        ubyte, "priority", 1,
        ubyte, "bandwidth", 3,
        ubyte, "code_rate_hp_stream", 3,
        ubyte, "hierarchy_information", 3,
        ubyte, "constellation", 2,
        ubyte, "other_frequency_flag", 1,
        ubyte, "transmission_mode", 2,
        ubyte, "guard_interval", 2,
        ubyte, "code_rate_lp_stream", 3,
        uint, "", 8));

    uint reserved_future_use2;
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the DVB-T terrestrial delivery system descriptor
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
int dvb_desc_terrestrial_delivery_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_desc* desc);

/**
 * @brief Prints the content of the DVB-T terrestrial delivery system descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_terrestrial_delivery_print (
    dvb_v5_fe_parms* parms,
    const(dvb_desc)* desc);

/**
 * @brief converts from internal representation into bandwidth in Hz
 */
extern __gshared const(uint)[] dvbt_bw;

/**
 * @brief converts from the descriptor's modulation into enum fe_modulation,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbt_modulation;

/**
 * @brief converts from the descriptor's hierarchy into enum fe_hierarchy,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbt_hierarchy;

/**
 * @brief converts from the descriptor's FEC into enum fe_code_rate,
 *	  as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbt_code_rate;

/**
 * @brief converts from internal representation into enum fe_guard_interval,
 * as defined at DVBv5 API.
 */
extern __gshared const(uint)[] dvbt_interval;

/**
 * @brief converts from the descriptor's transmission mode into
 *	  enum fe_transmit_mode, as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbt_transmission_mode;
