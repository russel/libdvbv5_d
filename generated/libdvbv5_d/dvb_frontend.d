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

/**
 * enum fe_caps - Frontend capabilities
 *
 * @FE_IS_STUPID:			There's something wrong at the
 *					frontend, and it can't report its
 *					capabilities.
 * @FE_CAN_INVERSION_AUTO:		Can auto-detect frequency spectral
 *					band inversion
 * @FE_CAN_FEC_1_2:			Supports FEC 1/2
 * @FE_CAN_FEC_2_3:			Supports FEC 2/3
 * @FE_CAN_FEC_3_4:			Supports FEC 3/4
 * @FE_CAN_FEC_4_5:			Supports FEC 4/5
 * @FE_CAN_FEC_5_6:			Supports FEC 5/6
 * @FE_CAN_FEC_6_7:			Supports FEC 6/7
 * @FE_CAN_FEC_7_8:			Supports FEC 7/8
 * @FE_CAN_FEC_8_9:			Supports FEC 8/9
 * @FE_CAN_FEC_AUTO:			Can auto-detect FEC
 * @FE_CAN_QPSK:			Supports QPSK modulation
 * @FE_CAN_QAM_16:			Supports 16-QAM modulation
 * @FE_CAN_QAM_32:			Supports 32-QAM modulation
 * @FE_CAN_QAM_64:			Supports 64-QAM modulation
 * @FE_CAN_QAM_128:			Supports 128-QAM modulation
 * @FE_CAN_QAM_256:			Supports 256-QAM modulation
 * @FE_CAN_QAM_AUTO:			Can auto-detect QAM modulation
 * @FE_CAN_TRANSMISSION_MODE_AUTO:	Can auto-detect transmission mode
 * @FE_CAN_BANDWIDTH_AUTO:		Can auto-detect bandwidth
 * @FE_CAN_GUARD_INTERVAL_AUTO:		Can auto-detect guard interval
 * @FE_CAN_HIERARCHY_AUTO:		Can auto-detect hierarchy
 * @FE_CAN_8VSB:			Supports 8-VSB modulation
 * @FE_CAN_16VSB:			Supporta 16-VSB modulation
 * @FE_HAS_EXTENDED_CAPS:		Unused
 * @FE_CAN_MULTISTREAM:			Supports multistream filtering
 * @FE_CAN_TURBO_FEC:			Supports "turbo FEC" modulation
 * @FE_CAN_2G_MODULATION:		Supports "2nd generation" modulation,
 *					e. g. DVB-S2, DVB-T2, DVB-C2
 * @FE_NEEDS_BENDING:			Unused
 * @FE_CAN_RECOVER:			Can recover from a cable unplug
 *					automatically
 * @FE_CAN_MUTE_TS:			Can stop spurious TS data output
 */
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
    FE_HAS_EXTENDED_CAPS = 0x800000,
    FE_CAN_MULTISTREAM = 0x4000000,
    FE_CAN_TURBO_FEC = 0x8000000,
    FE_CAN_2G_MODULATION = 0x10000000,
    FE_NEEDS_BENDING = 0x20000000,
    FE_CAN_RECOVER = 0x40000000,
    FE_CAN_MUTE_TS = 0x80000000
}

/*
 * DEPRECATED: Should be kept just due to backward compatibility.
 */
enum fe_type
{
    FE_QPSK = 0,
    FE_QAM = 1,
    FE_OFDM = 2,
    FE_ATSC = 3
}

/**
 * struct dvb_frontend_info - Frontend properties and capabilities
 *
 * @name:			Name of the frontend
 * @type:			**DEPRECATED**.
 *				Should not be used on modern programs,
 *				as a frontend may have more than one type.
 *				In order to get the support types of a given
 *				frontend, use :c:type:`DTV_ENUM_DELSYS`
 *				instead.
 * @frequency_min:		Minimal frequency supported by the frontend.
 * @frequency_max:		Minimal frequency supported by the frontend.
 * @frequency_stepsize:		All frequencies are multiple of this value.
 * @frequency_tolerance:	Frequency tolerance.
 * @symbol_rate_min:		Minimal symbol rate, in bauds
 *				(for Cable/Satellite systems).
 * @symbol_rate_max:		Maximal symbol rate, in bauds
 *				(for Cable/Satellite systems).
 * @symbol_rate_tolerance:	Maximal symbol rate tolerance, in ppm
 *				(for Cable/Satellite systems).
 * @notifier_delay:		**DEPRECATED**. Not used by any driver.
 * @caps:			Capabilities supported by the frontend,
 *				as specified in &enum fe_caps.
 *
 * .. note:
 *
 *    #. The frequencies are specified in Hz for Terrestrial and Cable
 *       systems.
 *    #. The frequencies are specified in kHz for Satellite systems.
 */
struct dvb_frontend_info
{
    char[128] name;
    fe_type type; /* DEPRECATED. Use DTV_ENUM_DELSYS instead */
    uint frequency_min;
    uint frequency_max;
    uint frequency_stepsize;
    uint frequency_tolerance;
    uint symbol_rate_min;
    uint symbol_rate_max;
    uint symbol_rate_tolerance;
    uint notifier_delay; /* DEPRECATED */
    fe_caps caps;
}

/**
 * struct dvb_diseqc_master_cmd - DiSEqC master command
 *
 * @msg:
 *	DiSEqC message to be sent. It contains a 3 bytes header with:
 *	framing + address + command, and an optional argument
 *	of up to 3 bytes of data.
 * @msg_len:
 *	Length of the DiSEqC message. Valid values are 3 to 6.
 *
 * Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
 * the possible messages that can be used.
 */
struct dvb_diseqc_master_cmd
{
    ubyte[6] msg;
    ubyte msg_len;
}

/**
 * struct dvb_diseqc_slave_reply - DiSEqC received data
 *
 * @msg:
 *	DiSEqC message buffer to store a message received via DiSEqC.
 *	It contains one byte header with: framing and
 *	an optional argument of up to 3 bytes of data.
 * @msg_len:
 *	Length of the DiSEqC message. Valid values are 0 to 4,
 *	where 0 means no message.
 * @timeout:
 *	Return from ioctl after timeout ms with errorcode when
 *	no message was received.
 *
 * Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
 * the possible messages that can be used.
 */
struct dvb_diseqc_slave_reply
{
    ubyte[4] msg;
    ubyte msg_len;
    int timeout;
}

/**
 * enum fe_sec_voltage - DC Voltage used to feed the LNBf
 *
 * @SEC_VOLTAGE_13:	Output 13V to the LNBf
 * @SEC_VOLTAGE_18:	Output 18V to the LNBf
 * @SEC_VOLTAGE_OFF:	Don't feed the LNBf with a DC voltage
 */
enum fe_sec_voltage
{
    SEC_VOLTAGE_13 = 0,
    SEC_VOLTAGE_18 = 1,
    SEC_VOLTAGE_OFF = 2
}

/**
 * enum fe_sec_tone_mode - Type of tone to be send to the LNBf.
 * @SEC_TONE_ON:	Sends a 22kHz tone burst to the antenna.
 * @SEC_TONE_OFF:	Don't send a 22kHz tone to the antenna (except
 *			if the ``FE_DISEQC_*`` ioctls are called).
 */
enum fe_sec_tone_mode
{
    SEC_TONE_ON = 0,
    SEC_TONE_OFF = 1
}

/**
 * enum fe_sec_mini_cmd - Type of mini burst to be sent
 *
 * @SEC_MINI_A:		Sends a mini-DiSEqC 22kHz '0' Tone Burst to select
 *			satellite-A
 * @SEC_MINI_B:		Sends a mini-DiSEqC 22kHz '1' Data Burst to select
 *			satellite-B
 */
enum fe_sec_mini_cmd
{
    SEC_MINI_A = 0,
    SEC_MINI_B = 1
}

/**
 * enum fe_status - Enumerates the possible frontend status.
 * @FE_NONE:		The frontend doesn't have any kind of lock.
 *			That's the initial frontend status
 * @FE_HAS_SIGNAL:	Has found something above the noise level.
 * @FE_HAS_CARRIER:	Has found a signal.
 * @FE_HAS_VITERBI:	FEC inner coding (Viterbi, LDPC or other inner code).
 *			is stable.
 * @FE_HAS_SYNC:	Synchronization bytes was found.
 * @FE_HAS_LOCK:	Digital TV were locked and everything is working.
 * @FE_TIMEDOUT:	Fo lock within the last about 2 seconds.
 * @FE_REINIT:		Frontend was reinitialized, application is recommended
 *			to reset DiSEqC, tone and parameters.
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

/**
 * enum fe_spectral_inversion - Type of inversion band
 *
 * @INVERSION_OFF:	Don't do spectral band inversion.
 * @INVERSION_ON:	Do spectral band inversion.
 * @INVERSION_AUTO:	Autodetect spectral band inversion.
 *
 * This parameter indicates if spectral inversion should be presumed or
 * not. In the automatic setting (``INVERSION_AUTO``) the hardware will try
 * to figure out the correct setting by itself. If the hardware doesn't
 * support, the %dvb_frontend will try to lock at the carrier first with
 * inversion off. If it fails, it will try to enable inversion.
 */
enum fe_spectral_inversion
{
    INVERSION_OFF = 0,
    INVERSION_ON = 1,
    INVERSION_AUTO = 2
}

/**
 * enum fe_code_rate - Type of Forward Error Correction (FEC)
 *
 *
 * @FEC_NONE: No Forward Error Correction Code
 * @FEC_1_2:  Forward Error Correction Code 1/2
 * @FEC_2_3:  Forward Error Correction Code 2/3
 * @FEC_3_4:  Forward Error Correction Code 3/4
 * @FEC_4_5:  Forward Error Correction Code 4/5
 * @FEC_5_6:  Forward Error Correction Code 5/6
 * @FEC_6_7:  Forward Error Correction Code 6/7
 * @FEC_7_8:  Forward Error Correction Code 7/8
 * @FEC_8_9:  Forward Error Correction Code 8/9
 * @FEC_AUTO: Autodetect Error Correction Code
 * @FEC_3_5:  Forward Error Correction Code 3/5
 * @FEC_9_10: Forward Error Correction Code 9/10
 * @FEC_2_5:  Forward Error Correction Code 2/5
 *
 * Please note that not all FEC types are supported by a given standard.
 */
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

/**
 * enum fe_modulation - Type of modulation/constellation
 * @QPSK:	QPSK modulation
 * @QAM_16:	16-QAM modulation
 * @QAM_32:	32-QAM modulation
 * @QAM_64:	64-QAM modulation
 * @QAM_128:	128-QAM modulation
 * @QAM_256:	256-QAM modulation
 * @QAM_AUTO:	Autodetect QAM modulation
 * @VSB_8:	8-VSB modulation
 * @VSB_16:	16-VSB modulation
 * @PSK_8:	8-PSK modulation
 * @APSK_16:	16-APSK modulation
 * @APSK_32:	32-APSK modulation
 * @DQPSK:	DQPSK modulation
 * @QAM_4_NR:	4-QAM-NR modulation
 *
 * Please note that not all modulations are supported by a given standard.
 *
 */
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

/**
 * enum fe_transmit_mode - Transmission mode
 *
 * @TRANSMISSION_MODE_AUTO:
 *	Autodetect transmission mode. The hardware will try to find the
 *	correct FFT-size (if capable) to fill in the missing parameters.
 * @TRANSMISSION_MODE_1K:
 *	Transmission mode 1K
 * @TRANSMISSION_MODE_2K:
 *	Transmission mode 2K
 * @TRANSMISSION_MODE_8K:
 *	Transmission mode 8K
 * @TRANSMISSION_MODE_4K:
 *	Transmission mode 4K
 * @TRANSMISSION_MODE_16K:
 *	Transmission mode 16K
 * @TRANSMISSION_MODE_32K:
 *	Transmission mode 32K
 * @TRANSMISSION_MODE_C1:
 *	Single Carrier (C=1) transmission mode (DTMB only)
 * @TRANSMISSION_MODE_C3780:
 *	Multi Carrier (C=3780) transmission mode (DTMB only)
 *
 * Please note that not all transmission modes are supported by a given
 * standard.
 */
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

/**
 * enum fe_guard_interval - Guard interval
 *
 * @GUARD_INTERVAL_AUTO:	Autodetect the guard interval
 * @GUARD_INTERVAL_1_128:	Guard interval 1/128
 * @GUARD_INTERVAL_1_32:	Guard interval 1/32
 * @GUARD_INTERVAL_1_16:	Guard interval 1/16
 * @GUARD_INTERVAL_1_8:		Guard interval 1/8
 * @GUARD_INTERVAL_1_4:		Guard interval 1/4
 * @GUARD_INTERVAL_19_128:	Guard interval 19/128
 * @GUARD_INTERVAL_19_256:	Guard interval 19/256
 * @GUARD_INTERVAL_PN420:	PN length 420 (1/4)
 * @GUARD_INTERVAL_PN595:	PN length 595 (1/6)
 * @GUARD_INTERVAL_PN945:	PN length 945 (1/9)
 *
 * Please note that not all guard intervals are supported by a given standard.
 */
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

/**
 * enum fe_hierarchy - Hierarchy
 * @HIERARCHY_NONE:	No hierarchy
 * @HIERARCHY_AUTO:	Autodetect hierarchy (if supported)
 * @HIERARCHY_1:	Hierarchy 1
 * @HIERARCHY_2:	Hierarchy 2
 * @HIERARCHY_4:	Hierarchy 4
 *
 * Please note that not all hierarchy types are supported by a given standard.
 */
enum fe_hierarchy
{
    HIERARCHY_NONE = 0,
    HIERARCHY_1 = 1,
    HIERARCHY_2 = 2,
    HIERARCHY_4 = 3,
    HIERARCHY_AUTO = 4
}

/**
 * enum fe_interleaving - Interleaving
 * @INTERLEAVING_NONE:	No interleaving.
 * @INTERLEAVING_AUTO:	Auto-detect interleaving.
 * @INTERLEAVING_240:	Interleaving of 240 symbols.
 * @INTERLEAVING_720:	Interleaving of 720 symbols.
 *
 * Please note that, currently, only DTMB uses it.
 */
enum fe_interleaving
{
    INTERLEAVING_NONE = 0,
    INTERLEAVING_AUTO = 1,
    INTERLEAVING_240 = 2,
    INTERLEAVING_720 = 3
}

/* DVBv5 property Commands */

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

/* Physical layer scrambling */
enum DTV_SCRAMBLING_SEQUENCE_INDEX = 70;

enum DTV_MAX_COMMAND = DTV_SCRAMBLING_SEQUENCE_INDEX;

/**
 * enum fe_pilot - Type of pilot tone
 *
 * @PILOT_ON:	Pilot tones enabled
 * @PILOT_OFF:	Pilot tones disabled
 * @PILOT_AUTO:	Autodetect pilot tones
 */
enum fe_pilot
{
    PILOT_ON = 0,
    PILOT_OFF = 1,
    PILOT_AUTO = 2
}

/**
 * enum fe_rolloff - Rolloff factor
 * @ROLLOFF_35:		Roloff factor: α=35%
 * @ROLLOFF_20:		Roloff factor: α=20%
 * @ROLLOFF_25:		Roloff factor: α=25%
 * @ROLLOFF_AUTO:	Auto-detect the roloff factor.
 *
 * .. note:
 *
 *    Roloff factor of 35% is implied on DVB-S. On DVB-S2, it is default.
 */
enum fe_rolloff
{
    ROLLOFF_35 = 0,
    ROLLOFF_20 = 1,
    ROLLOFF_25 = 2,
    ROLLOFF_AUTO = 3
}

/**
 * enum fe_delivery_system - Type of the delivery system
 *
 * @SYS_UNDEFINED:
 *	Undefined standard. Generally, indicates an error
 * @SYS_DVBC_ANNEX_A:
 *	Cable TV: DVB-C following ITU-T J.83 Annex A spec
 * @SYS_DVBC_ANNEX_B:
 *	Cable TV: DVB-C following ITU-T J.83 Annex B spec (ClearQAM)
 * @SYS_DVBC_ANNEX_C:
 *	Cable TV: DVB-C following ITU-T J.83 Annex C spec
 * @SYS_ISDBC:
 *	Cable TV: ISDB-C (no drivers yet)
 * @SYS_DVBT:
 *	Terrestrial TV: DVB-T
 * @SYS_DVBT2:
 *	Terrestrial TV: DVB-T2
 * @SYS_ISDBT:
 *	Terrestrial TV: ISDB-T
 * @SYS_ATSC:
 *	Terrestrial TV: ATSC
 * @SYS_ATSCMH:
 *	Terrestrial TV (mobile): ATSC-M/H
 * @SYS_DTMB:
 *	Terrestrial TV: DTMB
 * @SYS_DVBS:
 *	Satellite TV: DVB-S
 * @SYS_DVBS2:
 *	Satellite TV: DVB-S2
 * @SYS_TURBO:
 *	Satellite TV: DVB-S Turbo
 * @SYS_ISDBS:
 *	Satellite TV: ISDB-S
 * @SYS_DAB:
 *	Digital audio: DAB (not fully supported)
 * @SYS_DSS:
 *	Satellite TV: DSS (not fully supported)
 * @SYS_CMMB:
 *	Terrestrial TV (mobile): CMMB (not fully supported)
 * @SYS_DVBH:
 *	Terrestrial TV (mobile): DVB-H (standard deprecated)
 */
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

/* backward compatibility definitions for delivery systems */
enum SYS_DVBC_ANNEX_AC = fe_delivery_system_t.SYS_DVBC_ANNEX_A;
enum SYS_DMBTH = fe_delivery_system_t.SYS_DTMB; /* DMB-TH is legacy name, use DTMB */

/* ATSC-MH specific parameters */

/**
 * enum atscmh_sccc_block_mode - Type of Series Concatenated Convolutional
 *				 Code Block Mode.
 *
 * @ATSCMH_SCCC_BLK_SEP:
 *	Separate SCCC: the SCCC outer code mode shall be set independently
 *	for each Group Region (A, B, C, D)
 * @ATSCMH_SCCC_BLK_COMB:
 *	Combined SCCC: all four Regions shall have the same SCCC outer
 *	code mode.
 * @ATSCMH_SCCC_BLK_RES:
 *	Reserved. Shouldn't be used.
 */
enum atscmh_sccc_block_mode
{
    ATSCMH_SCCC_BLK_SEP = 0,
    ATSCMH_SCCC_BLK_COMB = 1,
    ATSCMH_SCCC_BLK_RES = 2
}

/**
 * enum atscmh_sccc_code_mode - Type of Series Concatenated Convolutional
 *				Code Rate.
 *
 * @ATSCMH_SCCC_CODE_HLF:
 *	The outer code rate of a SCCC Block is 1/2 rate.
 * @ATSCMH_SCCC_CODE_QTR:
 *	The outer code rate of a SCCC Block is 1/4 rate.
 * @ATSCMH_SCCC_CODE_RES:
 *	Reserved. Should not be used.
 */
enum atscmh_sccc_code_mode
{
    ATSCMH_SCCC_CODE_HLF = 0,
    ATSCMH_SCCC_CODE_QTR = 1,
    ATSCMH_SCCC_CODE_RES = 2
}

/**
 * enum atscmh_rs_frame_ensemble - Reed Solomon(RS) frame ensemble.
 *
 * @ATSCMH_RSFRAME_ENS_PRI:	Primary Ensemble.
 * @ATSCMH_RSFRAME_ENS_SEC:	Secondary Ensemble.
 */
enum atscmh_rs_frame_ensemble
{
    ATSCMH_RSFRAME_ENS_PRI = 0,
    ATSCMH_RSFRAME_ENS_SEC = 1
}

/**
 * enum atscmh_rs_frame_mode - Reed Solomon (RS) frame mode.
 *
 * @ATSCMH_RSFRAME_PRI_ONLY:
 *	Single Frame: There is only a primary RS Frame for all Group
 *	Regions.
 * @ATSCMH_RSFRAME_PRI_SEC:
 *	Dual Frame: There are two separate RS Frames: Primary RS Frame for
 *	Group Region A and B and Secondary RS Frame for Group Region C and
 *	D.
 * @ATSCMH_RSFRAME_RES:
 *	Reserved. Shouldn't be used.
 */
enum atscmh_rs_frame_mode
{
    ATSCMH_RSFRAME_PRI_ONLY = 0,
    ATSCMH_RSFRAME_PRI_SEC = 1,
    ATSCMH_RSFRAME_RES = 2
}

/**
 * enum atscmh_rs_code_mode
 * @ATSCMH_RSCODE_211_187:	Reed Solomon code (211,187).
 * @ATSCMH_RSCODE_223_187:	Reed Solomon code (223,187).
 * @ATSCMH_RSCODE_235_187:	Reed Solomon code (235,187).
 * @ATSCMH_RSCODE_RES:		Reserved. Shouldn't be used.
 */
enum atscmh_rs_code_mode
{
    ATSCMH_RSCODE_211_187 = 0,
    ATSCMH_RSCODE_223_187 = 1,
    ATSCMH_RSCODE_235_187 = 2,
    ATSCMH_RSCODE_RES = 3
}

enum NO_STREAM_ID_FILTER = ~0U;
enum LNA_AUTO = ~0U;

/**
 * enum fecap_scale_params - scale types for the quality parameters.
 *
 * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
 *			    could indicate a temporary or a permanent
 *			    condition.
 * @FE_SCALE_DECIBEL: The scale is measured in 0.001 dB steps, typically
 *		      used on signal measures.
 * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
 *		       ranging from 0 (0%) to 0xffff (100%).
 * @FE_SCALE_COUNTER: The scale counts the occurrence of an event, like
 *		      bit error, block error, lapsed time.
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
 * @scale:
 *	Filled with enum fecap_scale_params - the scale in usage
 *	for that parameter
 *
 * @svalue:
 *	integer value of the measure, for %FE_SCALE_DECIBEL,
 *	used for dB measures. The unit is 0.001 dB.
 *
 * @uvalue:
 *	unsigned integer value of the measure, used when @scale is
 *	either %FE_SCALE_RELATIVE or %FE_SCALE_COUNTER.
 *
 * For most delivery systems, this will return a single value for each
 * parameter.
 *
 * It should be noticed, however, that new OFDM delivery systems like
 * ISDB can use different modulation types for each group of carriers.
 * On such standards, up to 8 groups of statistics can be provided, one
 * for each carrier group (called "layer" on ISDB).
 *
 * In order to be consistent with other delivery systems, the first
 * value refers to the entire set of carriers ("global").
 *
 * @scale should use the value %FE_SCALE_NOT_AVAILABLE when
 * the value for the entire group of carriers or from one specific layer
 * is not provided by the hardware.
 *
 * @len should be filled with the latest filled status + 1.
 *
 * In other words, for ISDB, those values should be filled like::
 *
 *	u.st.stat.svalue[0] = global statistics;
 *	u.st.stat.scale[0] = FE_SCALE_DECIBEL;
 *	u.st.stat.value[1] = layer A statistics;
 *	u.st.stat.scale[1] = FE_SCALE_NOT_AVAILABLE (if not available);
 *	u.st.stat.svalue[2] = layer B statistics;
 *	u.st.stat.scale[2] = FE_SCALE_DECIBEL;
 *	u.st.stat.svalue[3] = layer C statistics;
 *	u.st.stat.scale[3] = FE_SCALE_DECIBEL;
 *	u.st.len = 4;
 */
struct dtv_stats
{
    align (1):

    ubyte scale; /* enum fecap_scale_params type */
    union
    {
        ulong uvalue; /* for counters and relative scales */
        long svalue; /* for 0.001 dB measures */
    }
}

enum MAX_DTV_STATS = 4;

/**
 * struct dtv_fe_stats - store Digital TV frontend statistics
 *
 * @len:	length of the statistics - if zero, stats is disabled.
 * @stat:	array with digital TV statistics.
 *
 * On most standards, @len can either be 0 or 1. However, for ISDB, each
 * layer is modulated in separate. So, each layer may have its own set
 * of statistics. If so, stat[0] carries on a global value for the property.
 * Indexes 1 to 3 means layer A to B.
 */
struct dtv_fe_stats
{
    align (1):

    ubyte len;
    dtv_stats[MAX_DTV_STATS] stat;
}

/**
 * struct dtv_property - store one of frontend command and its value
 *
 * @cmd:		Digital TV command.
 * @reserved:		Not used.
 * @u:			Union with the values for the command.
 * @u.data:		A unsigned 32 bits integer with command value.
 * @u.buffer:		Struct to store bigger properties.
 *			Currently unused.
 * @u.buffer.data:	an unsigned 32-bits array.
 * @u.buffer.len:	number of elements of the buffer.
 * @u.buffer.reserved1:	Reserved.
 * @u.buffer.reserved2:	Reserved.
 * @u.st:		a &struct dtv_fe_stats array of statistics.
 * @result:		Currently unused.
 *
 */
struct dtv_property
{
    align (1):

    uint cmd;
    uint[3] reserved;

    union _Anonymous_0
    {
        uint data;
        dtv_fe_stats st;

        struct _Anonymous_1
        {
            ubyte[32] data;
            uint len;
            uint[3] reserved1;
            void* reserved2;
        }

        _Anonymous_1 buffer;
    }

    _Anonymous_0 u;
    int result;
}

/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
enum DTV_IOCTL_MAX_MSGS = 64;

/**
 * struct dtv_properties - a set of command/value pairs.
 *
 * @num:	amount of commands stored at the struct.
 * @props:	a pointer to &struct dtv_property.
 */
struct dtv_properties
{
    uint num;
    dtv_property* props;
}

/*
 * When set, this flag will disable any zigzagging or other "normal" tuning
 * behavior. Additionally, there will be no automatic monitoring of the lock
 * status, and hence no frontend events will be generated. If a frontend device
 * is closed, this flag will be automatically turned off when the device is
 * reopened read-write.
 */
enum FE_TUNE_MODE_ONESHOT = 0x01;

/* Digital TV Frontend API calls */

enum FE_GET_INFO = _IOR!dvb_frontend_info('o', 61);

enum FE_DISEQC_RESET_OVERLOAD = _IO('o', 62);
enum FE_DISEQC_SEND_MASTER_CMD = _IOW!dvb_diseqc_master_cmd('o', 63);
enum FE_DISEQC_RECV_SLAVE_REPLY = _IOR!dvb_diseqc_slave_reply('o', 64);
enum FE_DISEQC_SEND_BURST = _IO('o', 65); /* fe_sec_mini_cmd_t */

enum FE_SET_TONE = _IO('o', 66); /* fe_sec_tone_mode_t */
enum FE_SET_VOLTAGE = _IO('o', 67); /* fe_sec_voltage_t */
enum FE_ENABLE_HIGH_LNB_VOLTAGE = _IO('o', 68); /* int */

enum FE_READ_STATUS = _IOR!fe_status('o', 69);
enum FE_READ_BER = _IOR!uint('o', 70);
enum FE_READ_SIGNAL_STRENGTH = _IOR!ushort('o', 71);
enum FE_READ_SNR = _IOR!ushort('o', 72);
enum FE_READ_UNCORRECTED_BLOCKS = _IOR!uint('o', 73);

enum FE_SET_FRONTEND_TUNE_MODE = _IO('o', 81); /* unsigned int */
enum FE_GET_EVENT = _IOR!dvb_frontend_event('o', 78);

enum FE_DISHNETWORK_SEND_LEGACY_CMD = _IO('o', 80); /* unsigned int */

enum FE_SET_PROPERTY = _IOW!dtv_properties('o', 82);
enum FE_GET_PROPERTY = _IOR!dtv_properties('o', 83);

/*
 * DEPRECATED: Everything below is deprecated in favor of DVBv5 API
 *
 * The DVBv3 only ioctls, structs and enums should not be used on
 * newer programs, as it doesn't support the second generation of
 * digital TV standards, nor supports newer delivery systems.
 * They also don't support modern frontends with usually support multiple
 * delivery systems.
 *
 * Drivers shouldn't use them.
 *
 * New applications should use DVBv5 delivery system instead
 */

/*
 */

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

/* This is kept for legacy userspace support */
alias fe_sec_voltage_t = fe_sec_voltage;
alias fe_caps_t = fe_caps;
alias fe_type_t = fe_type;
alias fe_sec_tone_mode_t = fe_sec_tone_mode;
alias fe_sec_mini_cmd_t = fe_sec_mini_cmd;
alias fe_status_t = fe_status;
alias fe_spectral_inversion_t = fe_spectral_inversion;
alias fe_code_rate_t = fe_code_rate;
alias fe_modulation_t = fe_modulation;
alias fe_transmit_mode_t = fe_transmit_mode;
alias fe_bandwidth_t = fe_bandwidth;
alias fe_guard_interval_t = fe_guard_interval;
alias fe_hierarchy_t = fe_hierarchy;
alias fe_pilot_t = fe_pilot;
alias fe_rolloff_t = fe_rolloff;
alias fe_delivery_system_t = fe_delivery_system;

/* DVBv3 structs */

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
    uint frequency; /* (absolute) frequency in Hz for DVB-C/DVB-T/ATSC */
    /* intermediate frequency in kHz for DVB-S */
    fe_spectral_inversion_t inversion;

    /* DVB-S */
    /* DVB-C */
    /* DVB-T */
    /* ATSC */
    union _Anonymous_2
    {
        dvb_qpsk_parameters qpsk;
        dvb_qam_parameters qam;
        dvb_ofdm_parameters ofdm;
        dvb_vsb_parameters vsb;
    }

    _Anonymous_2 u;
}

struct dvb_frontend_event
{
    fe_status_t status;
    dvb_frontend_parameters parameters;
}

/* DVBv3 API calls */

enum FE_SET_FRONTEND = _IOW!dvb_frontend_parameters('o', 76);
enum FE_GET_FRONTEND = _IOR!dvb_frontend_parameters('o', 77);

/*_DVBFRONTEND_H_*/
