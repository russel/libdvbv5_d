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

module libdvbv5_d.mpeg_es;

import core.sys.posix.unistd;

extern (C):

/**
 * @file mpeg_es.h
 * @ingroup dvb_table
 * @brief Provides the table parser for the MPEG-TS Elementary Stream
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Andre Roth
 *
 * @par Relevant specs
 * The table described herein is defined in ISO 13818-2
 *
 * @see
 * http://dvd.sourceforge.net/dvdinfo/mpeghdrs.html
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/* ssize_t */

/**
 * @def DVB_MPEG_ES_PIC_START
 *	@brief Picture Start
 *	@ingroup dvb_table
 * @def DVB_MPEG_ES_USER_DATA
 *	@brief User Data
 *	@ingroup dvb_table
 * @def DVB_MPEG_ES_SEQ_START
 *	@brief Sequence Start
 *	@ingroup dvb_table
 * @def DVB_MPEG_ES_SEQ_EXT
 *	@brief Extension
 *	@ingroup dvb_table
 * @def DVB_MPEG_ES_GOP
 *	@brief Group Of Pictures
 *	@ingroup dvb_table
 * @def DVB_MPEG_ES_SLICES
 *	@brief Slices
 *	@ingroup dvb_table
 */
enum DVB_MPEG_ES_PIC_START = 0x00;
enum DVB_MPEG_ES_USER_DATA = 0xb2;
enum DVB_MPEG_ES_SEQ_START = 0xb3;
enum DVB_MPEG_ES_SEQ_EXT = 0xb5;
enum DVB_MPEG_ES_GOP = 0xb8;

/**
 * @struct dvb_mpeg_es_seq_start
 * @brief MPEG ES Sequence header
 * @ingroup dvb_table
 *
 * @param type		DVB_MPEG_ES_SEQ_START
 * @param sync		Sync bytes
 * @param framerate	Framerate
 * @param aspect	Aspect ratio
 * @param height	Height
 * @param width		Width
 * @param qm_nonintra	Load non-intra quantizer matrix
 * @param qm_intra	Load intra quantizer matrix
 * @param constrained	Constrained parameters flag
 * @param vbv		VBV buffer size
 * @param one		Should be 1
 * @param bitrate	Bitrate
 */
struct dvb_mpeg_es_seq_start
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
                uint, "type", 8,
                uint, "sync", 24));
        }
    }

    union
    {
        align (1):

        uint bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "framerate", 4,
                uint, "aspect", 4,
                uint, "height", 12,
                uint, "width", 12));
        }
    }

    union
    {
        align (1):

        uint bitfield3;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "qm_nonintra", 1,
                uint, "qm_intra", 1,
                uint, "constrained", 1,
                uint, "vbv", 10,
                uint, "one", 1,
                uint, "bitrate", 18));

            // Size of video buffer verifier = 16*1024*vbv buf size
        }
    }
}

/**
 * @struct dvb_mpeg_es_pic_start
 * @brief MPEG ES Picture start header
 * @ingroup dvb_table
 *
 * @param type		DVB_MPEG_ES_PIC_START
 * @param sync		Sync bytes
 * @param dummy		Unused
 * @param vbv_delay	VBV delay
 * @param coding_type	Frame type (enum dvb_mpeg_es_frame_t)
 * @param temporal_ref	Temporal sequence number
 */
struct dvb_mpeg_es_pic_start
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
                uint, "type", 8,
                uint, "sync", 24));
        }
    }

    union
    {
        align (1):

        uint bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "dummy", 3,
                uint, "vbv_delay", 16,
                uint, "coding_type", 3,
                uint, "temporal_ref", 10));
        }
    }
}

/**
 * @enum dvb_mpeg_es_frame_t
 * @brief MPEG frame types
 * @ingroup dvb_table
 *
 * @var DVB_MPEG_ES_FRAME_UNKNOWN
 *	@brief	Unknown frame
 * @var DVB_MPEG_ES_FRAME_I
 *	@brief	I frame
 * @var DVB_MPEG_ES_FRAME_P
 *	@brief	P frame
 * @var DVB_MPEG_ES_FRAME_B
 *	@brief	B frame
 * @var DVB_MPEG_ES_FRAME_D
 *	@brief	D frame
 */
enum dvb_mpeg_es_frame_t
{
    DVB_MPEG_ES_FRAME_UNKNOWN = 0,
    DVB_MPEG_ES_FRAME_I = 1,
    DVB_MPEG_ES_FRAME_P = 2,
    DVB_MPEG_ES_FRAME_B = 3,
    DVB_MPEG_ES_FRAME_D = 4
}

/**
 * @brief Vector that translates from enum dvb_mpeg_es_frame_t to string.
 * @ingroup dvb_table
 */
extern __gshared const(char)*[5] dvb_mpeg_es_frame_names;

struct dvb_v5_fe_parms;

/**
 * @brief Initialize a struct dvb_mpeg_es_seq_start from buffer
 * @ingroup dvb_table
 *
 * @param buf		Buffer
 * @param buflen	Length of buffer
 * @param seq_start	Pointer to allocated struct dvb_mpeg_es_seq_start
 *
 * @return		If buflen too small, return -1, 0 otherwise.
 *
 * This function copies the length of struct dvb_mpeg_es_seq_start
 * to seq_start and fixes endianness. seq_start has to be allocated
 * with malloc.
 */
int dvb_mpeg_es_seq_start_init (
    const(ubyte)* buf,
    ssize_t buflen,
    dvb_mpeg_es_seq_start* seq_start);

/**
 * @brief Print details of struct dvb_mpeg_es_seq_start
 * @ingroup dvb_table
 *
 * @param parms		struct dvb_v5_fe_parms for log functions
 * @param seq_start	Pointer to struct dvb_mpeg_es_seq_start to print
 *
 * This function prints the fields of struct dvb_mpeg_es_seq_start
 */
void dvb_mpeg_es_seq_start_print (
    dvb_v5_fe_parms* parms,
    dvb_mpeg_es_seq_start* seq_start);

/**
 * @brief Initialize a struct dvb_mpeg_es_pic_start from buffer
 * @ingroup dvb_table
 *
 * @param buf		Buffer
 * @param buflen	Length of buffer
 * @param pic_start	Pointer to allocated structdvb_mpeg_es_pic_start
 *
 * @return		If buflen too small, return -1, 0 otherwise.
 *
 * This function copies the length of struct dvb_mpeg_es_pic_start
 * to pic_start	and fixes endianness. seq_start has to be allocated
 * with malloc.
 */
int dvb_mpeg_es_pic_start_init (
    const(ubyte)* buf,
    ssize_t buflen,
    dvb_mpeg_es_pic_start* pic_start);

/**
 * @brief Print details of struct dvb_mpeg_es_pic_start
 * @ingroup dvb_table
 *
 * @param parms		struct dvb_v5_fe_parms for log functions
 * @param pic_start	Pointer to struct dvb_mpeg_es_pic_start to print
 *
 * This function prints the fields of struct dvb_mpeg_es_pic_start
 */
void dvb_mpeg_es_pic_start_print (
    dvb_v5_fe_parms* parms,
    dvb_mpeg_es_pic_start* pic_start);

