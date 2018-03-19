/*
 * frontend.h
 *
 * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
 *		    Ralph  Metzler <ralph@convergence.de>
 *		    Holger Waechtler <holger@convergence.de>
 *		    Andre Draszik <ad@convergence.de>
 *		    for convergence integrated media GmbH
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

module libdvbv5_d.dvb_frontend;

import core.sys.posix.sys.ioctl;

extern (C):

enum fe_type
{
    FE_QPSK = 0,
    FE_QAM = 1,
    FE_OFDM = 2,
    FE_ATSC = 3
}

alias fe_type_t = fe_type;

enum fe_caps
{
    FE_IS_STUPID = 0,
    FE_CAN_INVERSION_AUTO = 0x1,
    FE_CAN_FEC_1_2 = 0x2,
    FE_CAN_FEC_2_3 = 0x4,
    FE_CAN_FEC_3_4 = 0x8,
    FE_CAN_FEC_4_5 = 0x10,
    FE_CAN_FEC_5_6 = 0x20,
    FE_CAN_FEC_6_7 = 0x40,
    FE_CAN_FEC_7_8 = 0x80,
    FE_CAN_FEC_8_9 = 0x100,
    FE_CAN_FEC_AUTO = 0x200,
    FE_CAN_QPSK = 0x400,
    FE_CAN_QAM_16 = 0x800,
    FE_CAN_QAM_32 = 0x1000,
    FE_CAN_QAM_64 = 0x2000,
    FE_CAN_QAM_128 = 0x4000,
    FE_CAN_QAM_256 = 0x8000,
    FE_CAN_QAM_AUTO = 0x10000,
    FE_CAN_TRANSMISSION_MODE_AUTO = 0x20000,
    FE_CAN_BANDWIDTH_AUTO = 0x40000,
    FE_CAN_GUARD_INTERVAL_AUTO = 0x80000,
    FE_CAN_HIERARCHY_AUTO = 0x100000,
    FE_CAN_8VSB = 0x200000,
    FE_CAN_16VSB = 0x400000,
    FE_HAS_EXTENDED_CAPS = 0x800000, /* We need more bitspace for newer APIs, indicate this. */
    FE_CAN_MULTISTREAM = 0x4000000, /* frontend supports multistream filtering */
    FE_CAN_TURBO_FEC = 0x8000000, /* frontend supports "turbo fec modulation" */
    FE_CAN_2G_MODULATION = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
    FE_NEEDS_BENDING = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
    FE_CAN_RECOVER = 0x40000000, /* frontend can recover from a cable unplug automatically */
    FE_CAN_MUTE_TS = 0x80000000 /* frontend can stop spurious TS data output */
}

alias fe_caps_t = fe_caps;

struct dvb_frontend_info
{
    char[128] name;
    fe_type_t type; /* DEPRECATED. Use DTV_ENUM_DELSYS instead */
    uint frequency_min;
    uint frequency_max;
    uint frequency_stepsize;
    uint frequency_tolerance;
    uint symbol_rate_min;
    uint symbol_rate_max;
    uint symbol_rate_tolerance; /* ppm */
    uint notifier_delay; /* DEPRECATED */
    fe_caps_t caps;
}

/**
 *  Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
 *  the meaning of this struct...
 */
struct dvb_diseqc_master_cmd
{
    ubyte[6] msg; /*  { framing, address, command, data [3] } */
    ubyte msg_len; /*  valid values are 3...6  */
}

struct dvb_diseqc_slave_reply
{
    ubyte[4] msg; /*  { framing, data [3] } */
    ubyte msg_len; /*  valid values are 0...4, 0 means no msg  */
    int timeout; /*  return from ioctl after timeout ms with */
} /*  errorcode when no message was received  */

enum fe_sec_voltage
{
    SEC_VOLTAGE_13 = 0,
    SEC_VOLTAGE_18 = 1,
    SEC_VOLTAGE_OFF = 2
}

alias fe_sec_voltage_t = fe_sec_voltage;

enum fe_sec_tone_mode
{
    SEC_TONE_ON = 0,
    SEC_TONE_OFF = 1
}

alias fe_sec_tone_mode_t = fe_sec_tone_mode;

enum fe_sec_mini_cmd
{
    SEC_MINI_A = 0,
    SEC_MINI_B = 1
}

alias fe_sec_mini_cmd_t = fe_sec_mini_cmd;

/**
 * enum fe_status - enumerates the possible frontend status
 * @FE_HAS_SIGNAL:	found something above the noise level
 * @FE_HAS_CARRIER:	found a DVB signal
 * @FE_HAS_VITERBI:	FEC is stable
 * @FE_HAS_SYNC:	found sync bytes
 * @FE_HAS_LOCK:	everything's working
 * @FE_TIMEDOUT:	no lock within the last ~2 seconds
 * @FE_REINIT:		frontend was reinitialized, application is recommended
 *			to reset DiSEqC, tone and parameters
 */

enum fe_status
{
    FE_NONE = 0x00,
    FE_HAS_SIGNAL = 0x01,
    FE_HAS_CARRIER = 0x02,
    FE_HAS_VITERBI = 0x04,
    FE_HAS_SYNC = 0x08,
    FE_HAS_LOCK = 0x10,
    FE_TIMEDOUT = 0x20,
    FE_REINIT = 0x40
}

alias fe_status_t = fe_status;

enum fe_spectral_inversion
{
    INVERSION_OFF = 0,
    INVERSION_ON = 1,
    INVERSION_AUTO = 2
}

alias fe_spectral_inversion_t = fe_spectral_inversion;

enum fe_code_rate
{
    FEC_NONE = 0,
    FEC_1_2 = 1,
    FEC_2_3 = 2,
    FEC_3_4 = 3,
    FEC_4_5 = 4,
    FEC_5_6 = 5,
    FEC_6_7 = 6,
    FEC_7_8 = 7,
    FEC_8_9 = 8,
    FEC_AUTO = 9,
    FEC_3_5 = 10,
    FEC_9_10 = 11,
    FEC_2_5 = 12
}

alias fe_code_rate_t = fe_code_rate;

enum fe_modulation
{
    QPSK = 0,
    QAM_16 = 1,
    QAM_32 = 2,
    QAM_64 = 3,
    QAM_128 = 4,
    QAM_256 = 5,
    QAM_AUTO = 6,
    VSB_8 = 7,
    VSB_16 = 8,
    PSK_8 = 9,
    APSK_16 = 10,
    APSK_32 = 11,
    DQPSK = 12,
    QAM_4_NR = 13
}

alias fe_modulation_t = fe_modulation;

enum fe_transmit_mode
{
    TRANSMISSION_MODE_2K = 0,
    TRANSMISSION_MODE_8K = 1,
    TRANSMISSION_MODE_AUTO = 2,
    TRANSMISSION_MODE_4K = 3,
    TRANSMISSION_MODE_1K = 4,
    TRANSMISSION_MODE_16K = 5,
    TRANSMISSION_MODE_32K = 6,
    TRANSMISSION_MODE_C1 = 7,
    TRANSMISSION_MODE_C3780 = 8
}

alias fe_transmit_mode_t = fe_transmit_mode;

enum fe_bandwidth
{
    BANDWIDTH_8_MHZ = 0,
    BANDWIDTH_7_MHZ = 1,
    BANDWIDTH_6_MHZ = 2,
    BANDWIDTH_AUTO = 3,
    BANDWIDTH_5_MHZ = 4,
    BANDWIDTH_10_MHZ = 5,
    BANDWIDTH_1_712_MHZ = 6
}

alias fe_bandwidth_t = fe_bandwidth;

enum fe_guard_interval
{
    GUARD_INTERVAL_1_32 = 0,
    GUARD_INTERVAL_1_16 = 1,
    GUARD_INTERVAL_1_8 = 2,
    GUARD_INTERVAL_1_4 = 3,
    GUARD_INTERVAL_AUTO = 4,
    GUARD_INTERVAL_1_128 = 5,
    GUARD_INTERVAL_19_128 = 6,
    GUARD_INTERVAL_19_256 = 7,
    GUARD_INTERVAL_PN420 = 8,
    GUARD_INTERVAL_PN595 = 9,
    GUARD_INTERVAL_PN945 = 10
}

alias fe_guard_interval_t = fe_guard_interval;

enum fe_hierarchy
{
    HIERARCHY_NONE = 0,
    HIERARCHY_1 = 1,
    HIERARCHY_2 = 2,
    HIERARCHY_4 = 3,
    HIERARCHY_AUTO = 4
}

alias fe_hierarchy_t = fe_hierarchy;

enum fe_interleaving
{
    INTERLEAVING_NONE = 0,
    INTERLEAVING_AUTO = 1,
    INTERLEAVING_240 = 2,
    INTERLEAVING_720 = 3
}

struct dvb_qpsk_parameters
{
    uint symbol_rate; /* symbol rate in Symbols per second */
    fe_code_rate_t fec_inner; /* forward error correction (see above) */
}

struct dvb_qam_parameters
{
    uint symbol_rate; /* symbol rate in Symbols per second */
    fe_code_rate_t fec_inner; /* forward error correction (see above) */
    fe_modulation_t modulation; /* modulation type (see above) */
}

struct dvb_vsb_parameters
{
    fe_modulation_t modulation; /* modulation type (see above) */
}

struct dvb_ofdm_parameters
{
    fe_bandwidth_t bandwidth;
    fe_code_rate_t code_rate_HP; /* high priority stream code rate */
    fe_code_rate_t code_rate_LP; /* low priority stream code rate */
    fe_modulation_t constellation; /* modulation type (see above) */
    fe_transmit_mode_t transmission_mode;
    fe_guard_interval_t guard_interval;
    fe_hierarchy_t hierarchy_information;
}

struct dvb_frontend_parameters
{
    uint frequency; /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
    /* intermediate frequency in kHz for QPSK */
    fe_spectral_inversion_t inversion;

    union _Anonymous_0
    {
        dvb_qpsk_parameters qpsk;
        dvb_qam_parameters qam;
        dvb_ofdm_parameters ofdm;
        dvb_vsb_parameters vsb;
    }

    _Anonymous_0 u;
}

struct dvb_frontend_event
{
    fe_status_t status;
    dvb_frontend_parameters parameters;
}

/* S2API Commands */
enum DTV_UNDEFINED = 0;
enum DTV_TUNE = 1;
enum DTV_CLEAR = 2;
enum DTV_FREQUENCY = 3;
enum DTV_MODULATION = 4;
enum DTV_BANDWIDTH_HZ = 5;
enum DTV_INVERSION = 6;
enum DTV_DISEQC_MASTER = 7;
enum DTV_SYMBOL_RATE = 8;
enum DTV_INNER_FEC = 9;
enum DTV_VOLTAGE = 10;
enum DTV_TONE = 11;
enum DTV_PILOT = 12;
enum DTV_ROLLOFF = 13;
enum DTV_DISEQC_SLAVE_REPLY = 14;

/* Basic enumeration set for querying unlimited capabilities */
enum DTV_FE_CAPABILITY_COUNT = 15;
enum DTV_FE_CAPABILITY = 16;
enum DTV_DELIVERY_SYSTEM = 17;

/* ISDB-T and ISDB-Tsb */
enum DTV_ISDBT_PARTIAL_RECEPTION = 18;
enum DTV_ISDBT_SOUND_BROADCASTING = 19;

enum DTV_ISDBT_SB_SUBCHANNEL_ID = 20;
enum DTV_ISDBT_SB_SEGMENT_IDX = 21;
enum DTV_ISDBT_SB_SEGMENT_COUNT = 22;

enum DTV_ISDBT_LAYERA_FEC = 23;
enum DTV_ISDBT_LAYERA_MODULATION = 24;
enum DTV_ISDBT_LAYERA_SEGMENT_COUNT = 25;
enum DTV_ISDBT_LAYERA_TIME_INTERLEAVING = 26;

enum DTV_ISDBT_LAYERB_FEC = 27;
enum DTV_ISDBT_LAYERB_MODULATION = 28;
enum DTV_ISDBT_LAYERB_SEGMENT_COUNT = 29;
enum DTV_ISDBT_LAYERB_TIME_INTERLEAVING = 30;

enum DTV_ISDBT_LAYERC_FEC = 31;
enum DTV_ISDBT_LAYERC_MODULATION = 32;
enum DTV_ISDBT_LAYERC_SEGMENT_COUNT = 33;
enum DTV_ISDBT_LAYERC_TIME_INTERLEAVING = 34;

enum DTV_API_VERSION = 35;

enum DTV_CODE_RATE_HP = 36;
enum DTV_CODE_RATE_LP = 37;
enum DTV_GUARD_INTERVAL = 38;
enum DTV_TRANSMISSION_MODE = 39;
enum DTV_HIERARCHY = 40;

enum DTV_ISDBT_LAYER_ENABLED = 41;

enum DTV_STREAM_ID = 42;
enum DTV_ISDBS_TS_ID_LEGACY = DTV_STREAM_ID;
enum DTV_DVBT2_PLP_ID_LEGACY = 43;

enum DTV_ENUM_DELSYS = 44;

/* ATSC-MH */
enum DTV_ATSCMH_FIC_VER = 45;
enum DTV_ATSCMH_PARADE_ID = 46;
enum DTV_ATSCMH_NOG = 47;
enum DTV_ATSCMH_TNOG = 48;
enum DTV_ATSCMH_SGN = 49;
enum DTV_ATSCMH_PRC = 50;
enum DTV_ATSCMH_RS_FRAME_MODE = 51;
enum DTV_ATSCMH_RS_FRAME_ENSEMBLE = 52;
enum DTV_ATSCMH_RS_CODE_MODE_PRI = 53;
enum DTV_ATSCMH_RS_CODE_MODE_SEC = 54;
enum DTV_ATSCMH_SCCC_BLOCK_MODE = 55;
enum DTV_ATSCMH_SCCC_CODE_MODE_A = 56;
enum DTV_ATSCMH_SCCC_CODE_MODE_B = 57;
enum DTV_ATSCMH_SCCC_CODE_MODE_C = 58;
enum DTV_ATSCMH_SCCC_CODE_MODE_D = 59;

enum DTV_INTERLEAVING = 60;
enum DTV_LNA = 61;

/* Quality parameters */
enum DTV_STAT_SIGNAL_STRENGTH = 62;
enum DTV_STAT_CNR = 63;
enum DTV_STAT_PRE_ERROR_BIT_COUNT = 64;
enum DTV_STAT_PRE_TOTAL_BIT_COUNT = 65;
enum DTV_STAT_POST_ERROR_BIT_COUNT = 66;
enum DTV_STAT_POST_TOTAL_BIT_COUNT = 67;
enum DTV_STAT_ERROR_BLOCK_COUNT = 68;
enum DTV_STAT_TOTAL_BLOCK_COUNT = 69;

enum DTV_MAX_COMMAND = DTV_STAT_TOTAL_BLOCK_COUNT;

enum fe_pilot
{
    PILOT_ON = 0,
    PILOT_OFF = 1,
    PILOT_AUTO = 2
}

alias fe_pilot_t = fe_pilot;

enum fe_rolloff
{
    ROLLOFF_35 = 0, /* Implied value in DVB-S, default for DVB-S2 */
    ROLLOFF_20 = 1,
    ROLLOFF_25 = 2,
    ROLLOFF_AUTO = 3
}

alias fe_rolloff_t = fe_rolloff;

enum fe_delivery_system
{
    SYS_UNDEFINED = 0,
    SYS_DVBC_ANNEX_A = 1,
    SYS_DVBC_ANNEX_B = 2,
    SYS_DVBT = 3,
    SYS_DSS = 4,
    SYS_DVBS = 5,
    SYS_DVBS2 = 6,
    SYS_DVBH = 7,
    SYS_ISDBT = 8,
    SYS_ISDBS = 9,
    SYS_ISDBC = 10,
    SYS_ATSC = 11,
    SYS_ATSCMH = 12,
    SYS_DTMB = 13,
    SYS_CMMB = 14,
    SYS_DAB = 15,
    SYS_DVBT2 = 16,
    SYS_TURBO = 17,
    SYS_DVBC_ANNEX_C = 18
}

alias fe_delivery_system_t = fe_delivery_system;

/* backward compatibility */
enum SYS_DVBC_ANNEX_AC = fe_delivery_system_t.SYS_DVBC_ANNEX_A;
enum SYS_DMBTH = fe_delivery_system_t.SYS_DTMB; /* DMB-TH is legacy name, use DTMB instead */

/* ATSC-MH */

enum atscmh_sccc_block_mode
{
    ATSCMH_SCCC_BLK_SEP = 0,
    ATSCMH_SCCC_BLK_COMB = 1,
    ATSCMH_SCCC_BLK_RES = 2
}

enum atscmh_sccc_code_mode
{
    ATSCMH_SCCC_CODE_HLF = 0,
    ATSCMH_SCCC_CODE_QTR = 1,
    ATSCMH_SCCC_CODE_RES = 2
}

enum atscmh_rs_frame_ensemble
{
    ATSCMH_RSFRAME_ENS_PRI = 0,
    ATSCMH_RSFRAME_ENS_SEC = 1
}

enum atscmh_rs_frame_mode
{
    ATSCMH_RSFRAME_PRI_ONLY = 0,
    ATSCMH_RSFRAME_PRI_SEC = 1,
    ATSCMH_RSFRAME_RES = 2
}

enum atscmh_rs_code_mode
{
    ATSCMH_RSCODE_211_187 = 0,
    ATSCMH_RSCODE_223_187 = 1,
    ATSCMH_RSCODE_235_187 = 2,
    ATSCMH_RSCODE_RES = 3
}

enum NO_STREAM_ID_FILTER = ~0U;
enum LNA_AUTO = ~0U;

struct dtv_cmds_h
{
    import std.bitmanip : bitfields;

    char* name; /* A display name for debugging purposes */

    uint cmd;

    mixin(bitfields!(
        uint, "set", 1,
        uint, "buffer", 1,
        uint, "reserved", 30)); /* A unique ID */

    /* Flags */
    /* Either a set or get property */
    /* Does this property use the buffer? */
    /* Align */
}

/**
 * Scale types for the quality parameters.
 * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
 *			    could indicate a temporary or a permanent
 *			    condition.
 * @FE_SCALE_DECIBEL: The scale is measured in 0.0001 dB steps, typically
 *		  used on signal measures.
 * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
 *			ranging from 0 (0%) to 0xffff (100%).
 * @FE_SCALE_COUNTER: The scale counts the occurrence of an event, like
 *			bit error, block error, lapsed time.
 */
enum fecap_scale_params
{
    FE_SCALE_NOT_AVAILABLE = 0,
    FE_SCALE_DECIBEL = 1,
    FE_SCALE_RELATIVE = 2,
    FE_SCALE_COUNTER = 3
}

/**
 * struct dtv_stats - Used for reading a DTV status property
 *
 * @value:	value of the measure. Should range from 0 to 0xffff;
 * @scale:	Filled with enum fecap_scale_params - the scale
 *		in usage for that parameter
 *
 * For most delivery systems, this will return a single value for each
 * parameter.
 * It should be noticed, however, that new OFDM delivery systems like
 * ISDB can use different modulation types for each group of carriers.
 * On such standards, up to 8 groups of statistics can be provided, one
 * for each carrier group (called "layer" on ISDB).
 * In order to be consistent with other delivery systems, the first
 * value refers to the entire set of carriers ("global").
 * dtv_status:scale should use the value FE_SCALE_NOT_AVAILABLE when
 * the value for the entire group of carriers or from one specific layer
 * is not provided by the hardware.
 * st.len should be filled with the latest filled status + 1.
 *
 * In other words, for ISDB, those values should be filled like:
 *	u.st.stat.svalue[0] = global statistics;
 *	u.st.stat.scale[0] = FE_SCALE_DECIBELS;
 *	u.st.stat.value[1] = layer A statistics;
 *	u.st.stat.scale[1] = FE_SCALE_NOT_AVAILABLE (if not available);
 *	u.st.stat.svalue[2] = layer B statistics;
 *	u.st.stat.scale[2] = FE_SCALE_DECIBELS;
 *	u.st.stat.svalue[3] = layer C statistics;
 *	u.st.stat.scale[3] = FE_SCALE_DECIBELS;
 *	u.st.len = 4;
 */
struct dtv_stats
{
    align (1):

    ubyte scale; /* enum fecap_scale_params type */
    union
    {
        ulong uvalue; /* for counters and relative scales */
        long svalue; /* for 0.0001 dB measures */
    }
}

enum MAX_DTV_STATS = 4;

struct dtv_fe_stats
{
    align (1):

    ubyte len;
    dtv_stats[MAX_DTV_STATS] stat;
}

struct dtv_property
{
    align (1):

    uint cmd;
    uint[3] reserved;

    union _Anonymous_1
    {
        uint data;
        dtv_fe_stats st;

        struct _Anonymous_2
        {
            ubyte[32] data;
            uint len;
            uint[3] reserved1;
            void* reserved2;
        }

        _Anonymous_2 buffer;
    }

    _Anonymous_1 u;
    int result;
}

/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
enum DTV_IOCTL_MAX_MSGS = 64;

struct dtv_properties
{
    uint num;
    dtv_property* props;
}

enum FE_SET_PROPERTY = _IOW!dtv_properties('o', 82);
enum FE_GET_PROPERTY = _IOR!dtv_properties('o', 83);

/**
 * When set, this flag will disable any zigzagging or other "normal" tuning
 * behaviour. Additionally, there will be no automatic monitoring of the lock
 * status, and hence no frontend events will be generated. If a frontend device
 * is closed, this flag will be automatically turned off when the device is
 * reopened read-write.
 */
enum FE_TUNE_MODE_ONESHOT = 0x01;

enum FE_GET_INFO = _IOR!dvb_frontend_info('o', 61);

enum FE_DISEQC_RESET_OVERLOAD = _IO('o', 62);
enum FE_DISEQC_SEND_MASTER_CMD = _IOW!dvb_diseqc_master_cmd('o', 63);
enum FE_DISEQC_RECV_SLAVE_REPLY = _IOR!dvb_diseqc_slave_reply('o', 64);
enum FE_DISEQC_SEND_BURST = _IO('o', 65); /* fe_sec_mini_cmd_t */

enum FE_SET_TONE = _IO('o', 66); /* fe_sec_tone_mode_t */
enum FE_SET_VOLTAGE = _IO('o', 67); /* fe_sec_voltage_t */
enum FE_ENABLE_HIGH_LNB_VOLTAGE = _IO('o', 68); /* int */

enum FE_READ_STATUS = _IOR!fe_status_t('o', 69);
enum FE_READ_BER = _IOR!uint('o', 70);
enum FE_READ_SIGNAL_STRENGTH = _IOR!ushort('o', 71);
enum FE_READ_SNR = _IOR!ushort('o', 72);
enum FE_READ_UNCORRECTED_BLOCKS = _IOR!uint('o', 73);

enum FE_SET_FRONTEND = _IOW!dvb_frontend_parameters('o', 76);
enum FE_GET_FRONTEND = _IOR!dvb_frontend_parameters('o', 77);
enum FE_SET_FRONTEND_TUNE_MODE = _IO('o', 81); /* unsigned int */
enum FE_GET_EVENT = _IOR!dvb_frontend_event('o', 78);

enum FE_DISHNETWORK_SEND_LEGACY_CMD = _IO('o', 80); /* unsigned int */

/*_DVBFRONTEND_H_*/
