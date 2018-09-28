/*
 * dmx.h
 *
 * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
 *                  & Ralph  Metzler <ralph@convergence.de>
 *                    for convergence integrated media GmbH
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

module libdvbv5_d.linux_dmx;


import core.sys.posix.sys.ioctl: _IO, _IOR, _IOW;

extern (C):

enum DMX_FILTER_SIZE = 16;

enum dmx_output
{
    DMX_OUT_DECODER = 0, /* Streaming directly to decoder. */
    DMX_OUT_TAP = 1, /* Output going to a memory buffer */
    /* (to be retrieved via the read command).*/
    DMX_OUT_TS_TAP = 2, /* Output multiplexed into a new TS  */
    /* (to be retrieved by reading from the */
    /* logical DVR device).                 */
    DMX_OUT_TSDEMUX_TAP = 3 /* Like TS_TAP but retrieved from the DMX device */
}

alias dmx_output_t = dmx_output;

enum dmx_input
{
    DMX_IN_FRONTEND = 0, /* Input from a front-end device.  */
    DMX_IN_DVR = 1 /* Input from the logical DVR device.  */
}

alias dmx_input_t = dmx_input;

enum dmx_ts_pes
{
    DMX_PES_AUDIO0 = 0,
    DMX_PES_VIDEO0 = 1,
    DMX_PES_TELETEXT0 = 2,
    DMX_PES_SUBTITLE0 = 3,
    DMX_PES_PCR0 = 4,

    DMX_PES_AUDIO1 = 5,
    DMX_PES_VIDEO1 = 6,
    DMX_PES_TELETEXT1 = 7,
    DMX_PES_SUBTITLE1 = 8,
    DMX_PES_PCR1 = 9,

    DMX_PES_AUDIO2 = 10,
    DMX_PES_VIDEO2 = 11,
    DMX_PES_TELETEXT2 = 12,
    DMX_PES_SUBTITLE2 = 13,
    DMX_PES_PCR2 = 14,

    DMX_PES_AUDIO3 = 15,
    DMX_PES_VIDEO3 = 16,
    DMX_PES_TELETEXT3 = 17,
    DMX_PES_SUBTITLE3 = 18,
    DMX_PES_PCR3 = 19,

    DMX_PES_OTHER = 20
}

alias dmx_pes_type_t = dmx_ts_pes;

enum DMX_PES_AUDIO = dmx_ts_pes.DMX_PES_AUDIO0;
enum DMX_PES_VIDEO = dmx_ts_pes.DMX_PES_VIDEO0;
enum DMX_PES_TELETEXT = dmx_ts_pes.DMX_PES_TELETEXT0;
enum DMX_PES_SUBTITLE = dmx_ts_pes.DMX_PES_SUBTITLE0;
enum DMX_PES_PCR = dmx_ts_pes.DMX_PES_PCR0;

struct dmx_filter
{
    ubyte[DMX_FILTER_SIZE] filter;
    ubyte[DMX_FILTER_SIZE] mask;
    ubyte[DMX_FILTER_SIZE] mode;
}

alias dmx_filter_t = dmx_filter;

struct dmx_sct_filter_params
{
    ushort pid;
    dmx_filter_t filter;
    uint timeout;
    uint flags;
}

enum DMX_CHECK_CRC = 1;
enum DMX_ONESHOT = 2;
enum DMX_IMMEDIATE_START = 4;
enum DMX_KERNEL_CLIENT = 0x8000;

struct dmx_pes_filter_params
{
    ushort pid;
    dmx_input_t input;
    dmx_output_t output;
    dmx_pes_type_t pes_type;
    uint flags;
}

struct dmx_caps
{
    uint caps;
    int num_decoders;
}

alias dmx_caps_t = dmx_caps;

enum dmx_source
{
    DMX_SOURCE_FRONT0 = 0,
    DMX_SOURCE_FRONT1 = 1,
    DMX_SOURCE_FRONT2 = 2,
    DMX_SOURCE_FRONT3 = 3,
    DMX_SOURCE_DVR0 = 16,
    DMX_SOURCE_DVR1 = 17,
    DMX_SOURCE_DVR2 = 18,
    DMX_SOURCE_DVR3 = 19
}

alias dmx_source_t = dmx_source;

struct dmx_stc
{
    uint num; /* input : which STC? 0..N */
    uint base; /* output: divisor for stc to get 90 kHz clock */
    ulong stc; /* output: stc in 'base'*90 kHz units */
}

enum DMX_START = _IO('o', 41);
enum DMX_STOP = _IO('o', 42);
enum DMX_SET_BUFFER_SIZE = _IO('o', 45);
enum DMX_GET_PES_PIDS = _IOR!(ushort[5])('o', 47);
enum DMX_GET_CAPS = _IOR!dmx_caps_t('o', 48);
enum DMX_SET_SOURCE = _IOW!dmx_source_t('o', 49);
enum DMX_ADD_PID = _IOW!ushort('o', 51);
enum DMX_REMOVE_PID = _IOW!ushort('o', 52);

/* _DVBDMX_H_ */
