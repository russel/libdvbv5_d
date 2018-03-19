/*
 * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
 * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
 * @file vct.h
 * @ingroup dvb_table
 * @brief Provides the descriptors for TVCT and CVCT tables
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 * @author Andre Roth
 *
 * @par Relevant specs
 * The table described herein is defined at:
 * - ATSC A/65:2009
 *
 * @see http://www.etherguidesystems.com/help/sdos/atsc/syntax/tablesections/TVCT.aspx
 * @see http://www.etherguidesystems.com/help/sdos/atsc/syntax/tablesections/CVCT.aspx
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

module libdvbv5_d.vct;

import core.sys.posix.unistd;

extern (C):

/* ssize_t */

/**
 * @def ATSC_TABLE_TVCT
 *	@brief TVCT table ID
 *	@ingroup dvb_table
 * @def ATSC_TABLE_CVCT
 *	@brief CVCT table ID
 *	@ingroup dvb_table
 * @def ATSC_TABLE_VCT_PID
 *	@brief Program ID with the VCT tables on it
 *	@ingroup dvb_table
 */
enum ATSC_TABLE_TVCT = 0xc8;
enum ATSC_TABLE_CVCT = 0xc9;
enum ATSC_TABLE_VCT_PID = 0x1ffb;

/**
 * @struct atsc_table_vct_channel
 * @brief ATSC VCT channel table (covers both CVCT and TVCT)
 * @ingroup dvb_table
 *
 * @param modulation_mode	modulation mode
 * @param minor_channel_number	minor channel number
 * @param major_channel_number	major channel number
 * @param carrier_frequency	carrier frequency
 * @param channel_tsid		channel tsid
 * @param program_number	program number
 * @param service_type		service type
 * @param hide_guide		hide guide
 * @param out_of_band		out of band (CVCT only)
 * @param path_select		path select (CVCT only)
 * @param hidden		hidden
 * @param access_controlled	access controlled
 * @param ETM_location		ETM location
 * @param source_id		source ID
 * @param descriptors_length	length of the descriptors
 *
 * @param descriptor		pointer to struct dvb_desc
 * @param next pointer to another struct atsc_table_vct_channel
 * @param descriptors_length	length of the descriptors
 * @param short_name		short name. The __short_name is converted
 *				from UTF-16 to locale charset when parsed
 *
 * This structure is used to store the original VCT channel table,
 * converting the integer fields to the CPU endianness.
 *
 * The undocumented parameters are used only internally by the API and/or
 * are fields that are reserved. They shouldn't be used, as they may change
 * on future API releases.
 *
 * Everything after atsc_table_vct_channel::descriptor (including it) won't
 * be bit-mapped * to the data parsed from the MPEG TS. So, metadata are
 * added there.
 */
struct atsc_table_vct_channel
{
    align (1):

    ushort[7] __short_name;

    union
    {
        align (1):

        uint bitfield1;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                uint, "modulation_mode", 8,
                uint, "minor_channel_number", 10,
                uint, "major_channel_number", 10,
                uint, "reserved1", 4));
        }
    }

    uint carrier_frequency;
    ushort channel_tsid;
    ushort program_number;

    union
    {
        align (1):

        ushort bitfield2;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "service_type", 6,
                ushort, "reserved2", 3,
                ushort, "hide_guide", 1,
                ushort, "out_of_band", 1,
                ushort, "path_select", 1,
                ushort, "hidden", 1,
                ushort, "access_controlled", 1,
                ushort, "ETM_location", 2));

            /* CVCT only */
            /* CVCT only */
        }
    }

    ushort source_id;

    union
    {
        align (1):

        ushort bitfield3;

        struct
        {
            import std.bitmanip : bitfields;
            align (1):

            mixin(bitfields!(
                ushort, "descriptors_length", 10,
                ushort, "reserved3", 6));
        }
    }

    /*
    	 * Everything after atsc_table_vct_channel::descriptor (including it)
    	 * won't be bit-mapped to the data parsed from the MPEG TS. So,
    	 * metadata are added there
    	 */
    struct dvb_desc;
    dvb_desc* descriptor;
    atsc_table_vct_channel* next;

    /* The channel_short_name is converted to locale charset by vct.c */

    char[32] short_name;
}

/**
 * @struct atsc_table_vct
 * @brief ATSC VCT table (covers both CVCT and TVCT)
 * @ingroup dvb_table
 *
 * @param header			struct dvb_table_header content
 * @param protocol_version		protocol version
 * @param num_channels_in_section	num channels in section
 * @param channel			pointer to struct channel
 * @param descriptor			pointer to struct descriptor
 *
 * Everything after atsc_table_vct::channel (including it) won't be bit-mapped
 * to the data parsed from the MPEG TS. So, metadata are added there
 */
struct atsc_table_vct
{
    align (1):

    dvb_table_header header;
    ubyte protocol_version;

    ubyte num_channels_in_section;

    atsc_table_vct_channel* channel;
    dvb_desc* descriptor;
}

/**
 * @union atsc_table_vct_descriptor_length
 * @brief ATSC VCT descriptor length
 * @ingroup dvb_table
 *
 * @param descriptor_length	descriptor length
 *
 * Used internally by the library to parse the descriptor length endianness.
 */
union atsc_table_vct_descriptor_length
{
    align (1):

    ushort bitfield;

    struct
    {
        import std.bitmanip : bitfields;
        align (1):

        mixin(bitfields!(
            ushort, "descriptor_length", 10,
            ushort, "reserved", 6));
    }
}

/**
 * @brief Macro used to find channels on a VCT table
 * @ingroup dvb_table
 *
 * @param _channel	channel to seek
 * @param _vct		pointer to struct atsc_table_vct_channel
 */

struct dvb_v5_fe_parms;

/**
 * @brief Initializes and parses VCT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param buf buffer containing the VCT raw data
 * @param buflen length of the buffer
 * @param table pointer to struct atsc_table_vct to be allocated and filled
 *
 * This function allocates an ATSC VCT table and fills the fields inside
 * the struct. It also makes sure that all fields will follow the CPU
 * endianness. Due to that, the content of the buffer may change.
 *
 * @return On success, it returns the size of the allocated struct.
 *	   A negative value indicates an error.
 */
ssize_t atsc_table_vct_init (
    dvb_v5_fe_parms* parms,
    const(ubyte)* buf,
    ssize_t buflen,
    atsc_table_vct** table);
/**
 * @brief Frees all data allocated by the VCT table parser
 * @ingroup dvb_table
 *
 * @param table pointer to struct atsc_table_vct to be freed
 */
void atsc_table_vct_free (atsc_table_vct* table);
/**
 * @brief Prints the content of the VCT table
 * @ingroup dvb_table
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param table pointer to struct atsc_table_vct
 */
void atsc_table_vct_print (dvb_v5_fe_parms* parms, atsc_table_vct* table);

