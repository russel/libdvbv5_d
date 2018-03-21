/*
 * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
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

module libdvbv5_d.mpeg_pes;

import core.sys.posix.unistd;

import libdvbv5_d.dvb_fe: dvb_v5_fe_parms;

extern (C):

/**
 * @file mpeg_pes.h
 * @ingroup dvb_table
 * @brief Provides the table parser for the MPEG-PES Elementary Stream
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Andre Roth
 *
 * @par Relevant specs
 * The table described herein is defined in ISO 13818-1
 *
 * @see
 * http://dvd.sourceforge.net/dvdinfo/pes-hdr.html
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/* ssize_t */

/**
 * @def DVB_MPEG_PES
 *	@brief MPEG Packetized Elementary Stream magic
 *	@ingroup dvb_table
 * @def DVB_MPEG_PES_AUDIO
 *	@brief PES Audio
 *	@ingroup dvb_table
 * @def DVB_MPEG_PES_VIDEO
 *	@brief PES Video
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_MAP
 *	@brief PES Stream map
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_PADDING
 *	@brief PES padding
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_PRIVATE_2
 *	@brief PES private
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_ECM
 *	@brief PES ECM Stream
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_EMM
 *	@brief PES EMM Stream
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_DIRECTORY
 *	@brief PES Stream directory
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_DSMCC
 *	@brief PES DSMCC
 *	@ingroup dvb_table
 * @def DVB_MPEG_STREAM_H222E
 *	@brief PES H.222.1 type E
 *	@ingroup dvb_table
 */

enum DVB_MPEG_PES = 0x00001;

enum DVB_MPEG_STREAM_MAP = 0xBC;
enum DVB_MPEG_STREAM_PADDING = 0xBE;
enum DVB_MPEG_STREAM_PRIVATE_2 = 0x5F;
enum DVB_MPEG_STREAM_ECM = 0x70;
enum DVB_MPEG_STREAM_EMM = 0x71;
enum DVB_MPEG_STREAM_DIRECTORY = 0xFF;
enum DVB_MPEG_STREAM_DSMCC = 0x7A;
enum DVB_MPEG_STREAM_H222E = 0xF8;

/**
 * @struct ts_t
 * @brief MPEG PES timestamp structure, used for dts and pts
 * @ingroup dvb_table
 *
 * @param tag		4 bits  Should be 0010 for PTS and 0011 for DTS
 * @param bits30	3 bits	Timestamp bits 30-32
 * @param one		1 bit	Sould be 1
 * @param bits15	15 bits	Timestamp bits 15-29
 * @param one1		1 bit	Should be 1
 * @param bits00	15 Bits	Timestamp bits 0-14
 * @param one2		1 bit	Should be 1
 */

struct ts_t
{
    import std.bitmanip : bitfields;
    align (1):

    mixin(bitfields!(
        ubyte, "one", 1,
        ubyte, "bits30", 3,
        ubyte, "tag", 4));

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "one1", 1,
                ushort, "bits15", 15));
        }
    }

    union
    {
        align (1):

        ushort bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "one2", 1,
                ushort, "bits00", 15));
        }
    }
}

/**
 * @struct dvb_mpeg_pes_optional
 * @brief MPEG PES optional header
 * @ingroup dvb_table
 *
 * @param two				2 bits	Should be 10
 * @param PES_scrambling_control	2 bits	PES Scrambling Control (Not Scrambled=00, otherwise scrambled)
 * @param PES_priority			1 bit	PES Priority
 * @param data_alignment_indicator	1 bit	PES data alignment
 * @param copyright			1 bit	PES content protected by copyright
 * @param original_or_copy		1 bit	PES content is original (=1) or copied (=0)
 * @param PTS_DTS			2 bit	PES header contains PTS (=10, =11) and/or DTS (=01, =11)
 * @param ESCR				1 bit	PES header contains ESCR fields
 * @param ES_rate			1 bit	PES header contains ES_rate field
 * @param DSM_trick_mode		1 bit	PES header contains DSM_trick_mode field
 * @param additional_copy_info		1 bit	PES header contains additional_copy_info field
 * @param PES_CRC			1 bit	PES header contains CRC field
 * @param PES_extension			1 bit	PES header contains extension field
 * @param length			8 bit	PES header data length
 * @param pts				64 bit	PES PTS timestamp
 * @param dts				64 bit	PES DTS timestamp
 */
struct dvb_mpeg_pes_optional
{
    align (1):

    union
    {
        align (1):

        ushort bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "PES_extension", 1,
                ushort, "PES_CRC", 1,
                ushort, "additional_copy_info", 1,
                ushort, "DSM_trick_mode", 1,
                ushort, "ES_rate", 1,
                ushort, "ESCR", 1,
                ushort, "PTS_DTS", 2,
                ushort, "original_or_copy", 1,
                ushort, "copyright", 1,
                ushort, "data_alignment_indicator", 1,
                ushort, "PES_priority", 1,
                ushort, "PES_scrambling_control", 2,
                ushort, "two", 2));
        }
    }

    ubyte length;
    ulong pts;
    ulong dts;
}

/**
 * @struct dvb_mpeg_pes
 * @brief MPEG PES data structure
 * @ingroup dvb_table
 *
 * @param sync		24 bits	DVB_MPEG_PES
 * @param stream_id	8 bits	PES Stream ID
 * @param length	16 bits	PES packet length
 * @param optional	Pointer to optional PES header
 */
struct dvb_mpeg_pes
{
    align (1):

    union
    {
        align (1):

        uint bitfield;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "stream_id", 8,
                uint, "sync", 24));
        }
    }

    ushort length;
    dvb_mpeg_pes_optional[] optional;
}

// struct dvb_v5_fe_parms;

/**
 * @brief Initialize a struct dvb_mpeg_pes from buffer
 * @ingroup dvb_table
 *
 * @param parms		struct dvb_v5_fe_parms for log functions
 * @param buf		Buffer
 * @param buflen	Length of buffer
 * @param table		Pointer to allocated struct dvb_mpeg_pes
 *
 * @return		Length of data in table
 *
 * This function copies the length of struct dvb_mpeg_pes
 * to table and fixes endianness. The pointer table has to be
 * allocated on stack or dynamically.
 */
ssize_t dvb_mpeg_pes_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    ssize_t buflen,
    ubyte* table);

/**
 * @brief Deallocate memory associated with a struct dvb_mpeg_pes
 * @ingroup dvb_table
 *
 * @param pes	struct dvb_mpeg_pes to be deallocated
 *
 * If the pointer pes was allocated dynamically, this function
 * can be used to free the memory.
 */
void dvb_mpeg_pes_free (dvb_mpeg_pes* pes);

/**
 * @brief Print details of struct dvb_mpeg_pes
 * @ingroup dvb_table
 *
 * @param parms		struct dvb_v5_fe_parms for log functions
 * @param pes    	Pointer to struct dvb_mpeg_pes to print
 *
 * This function prints the fields of struct dvb_mpeg_pes
 */
void dvb_mpeg_pes_print (dvb_v5_fe_parms* parms, dvb_mpeg_pes* pes);
