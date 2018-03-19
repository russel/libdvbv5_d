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
 * Based on ETSI EN 300 468 V1.11.1 (2010-04)
 */

/**
 * @file desc_t2_delivery.h
 * @ingroup descriptors
 * @brief Provides the descriptors for the DVB-T2 delivery system descriptor
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 *
 * @par Relevant specs
 * The descriptor described herein is defined at:
 * - ETSI EN 300 468 V1.11.1
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.desc_t2_delivery;

extern (C):

/**
 * @struct dvb_desc_t2_delivery_subcell_old
 * @ingroup descriptors
 * @brief Structure to describe transponder subcell extension and frequencies
 *
 * @param cell_id_extension	cell id extension
 * @param transposer_frequency	transposer frequency
 *
 * NOTE: This struct is deprecated and will never be filled.
 *       It is kept here just to avoid breaking ABI.
 *
 * All subcell transposer frequencies will be added to
 * dvb_desc_t2_delivery::centre_frequency array.
 */
struct dvb_desc_t2_delivery_subcell_old
{
    align (1):

    ubyte cell_id_extension;
    ushort transposer_frequency; // Should be 32 bits, instead
}

/**
 * @struct dvb_desc_t2_delivery_subcell
 * @ingroup descriptors
 * @brief Structure to describe transponder subcell extension and frequencies
 *
 * @param cell_id_extension	cell id extension
 * @param transposer_frequency	pointer to transposer frequency
 */
struct dvb_desc_t2_delivery_subcell
{
    align (1):

    ubyte cell_id_extension;
    uint transposer_frequency;
}

/**
 * @struct dvb_desc_t2_delivery_cell
 * @ingroup descriptors
 * @brief Structure to describe transponder cells
 *
 * @param cell_id		cell id extension
 * @param num_freqs		number of cell frequencies
 * @param centre_frequency	pointer to centre frequencies
 * @param subcel_length		number of subcells. May be zero
 * @param subcell		pointer to subcell array. May be NULL
 */
struct dvb_desc_t2_delivery_cell
{
    align (1):

    ushort cell_id;
    int num_freqs;
    uint* centre_frequency;
    ubyte subcel_length;
    dvb_desc_t2_delivery_subcell* subcel;
}

/**
 * @struct dvb_desc_t2_delivery
 * @ingroup descriptors
 * @brief Structure containing the T2 delivery system descriptor
 *
 * @param plp_id		data PLP id
 * @param system_id		T2 system id
 * @param SISO_MISO		SISO MISO
 * @param bandwidth		bandwidth
 * @param guard_interval	guard interval
 * @param transmission_mode	transmission mode
 * @param other_frequency_flag	other frequency flag
 * @param tfs_flag		tfs flag
 *
 * @param centre_frequency	centre frequency vector. It contains the full
 *				frequencies for all cells and subcells.
 * @param frequency_loop_length	size of the dvb_desc_t2_delivery::centre_frequency
 *				vector
 *
 * @param subcel_info_loop_length unused. Always 0
 * @param subcell		unused. Always NULL
 * @param num_cell		number of cells
 * @param cell			cell array. Contains per-cell and per-subcell
 *				pointers to the frequencies parsed.
 */
struct dvb_desc_t2_delivery
{
    align (1):

    /* extended descriptor */

    ubyte plp_id;
    ushort system_id;

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "tfs_flag", 1,
                ushort, "other_frequency_flag", 1,
                ushort, "transmission_mode", 3,
                ushort, "guard_interval", 3,
                ushort, "reserved", 2,
                ushort, "bandwidth", 4,
                ushort, "SISO_MISO", 2));
        }
    }

    uint* centre_frequency;
    ubyte frequency_loop_length;

    /* Unused, as the definitions here are incomplete. */
    ubyte subcel_info_loop_length;
    dvb_desc_t2_delivery_subcell_old* subcell;

    /* Since version 1.13 */
    uint num_cell;
    dvb_desc_t2_delivery_cell* cell;
}

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses the T2 delivery system descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf	buffer containing the descriptor's raw data
 * @param ext	struct dvb_extension_descriptor pointer
 * @param desc	pointer to struct dvb_desc to be allocated and filled
 *
 * This function allocates a the descriptor and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
int dvb_desc_t2_delivery_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    dvb_extension_descriptor* ext,
    void* desc);

/**
 * @brief Prints the content of the T2 delivery system descriptor
 * @ingroup descriptors
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param ext	struct dvb_extension_descriptor pointer
 * @param desc	pointer to struct dvb_desc
 */
void dvb_desc_t2_delivery_print (
    dvb_v5_fe_parms* parms,
    const(dvb_extension_descriptor)* ext,
    const(void)* desc);

/**
 * @brief Frees all data allocated by the T2 delivery system descriptor
 * @ingroup descriptors
 *
 * @param desc pointer to struct dvb_desc to be freed
 */
void dvb_desc_t2_delivery_free (const(void)* desc);

/**
 * @brief converts from internal representation into bandwidth in Hz
 */
extern __gshared const(uint)[] dvbt2_bw;

/**
 * @brief converts from internal representation into enum fe_guard_interval,
 * as defined at DVBv5 API.
 */
extern __gshared const(uint)[] dvbt2_interval;

/**
 * @brief converts from the descriptor's transmission mode into
 *	  enum fe_transmit_mode, as defined by DVBv5 API.
 */
extern __gshared const(uint)[] dvbt2_transmission_mode;

/**
 * @brief converts from internal representation to string the SISO_MISO
 *	  field of dvb_desc_t2_delivery:SISO_MISO field.
 */
extern __gshared const(char)*[4] siso_miso;

