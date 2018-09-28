/*
 * Copyright (c) 2011-2014 - Mauro Carvalho Chehab
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

module libdvbv5_d.dvb_fe;

import libdvbv5_d.dvb_v5_std: DTV_NUM_STATS_PROPS,
	dvb_quality;
import libdvbv5_d.dvb_frontend: DTV_STAT_SIGNAL_STRENGTH, DTV_STAT_CNR, DTV_STAT_ERROR_BLOCK_COUNT,
	dvb_frontend_info, fe_delivery_system_t, dtv_stats, fecap_scale_params, fe_sec_tone_mode_t;
import libdvbv5_d.dvb_log: dvb_logfunc;
import libdvbv5_d.dvb_sat: dvb_sat_lnb;

extern (C):

/**
 * @file dvb-fe.h
 * @ingroup frontend
 * @brief Provides interfaces to deal with DVB frontend.
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Mauro Carvalho Chehab
 *
 * The libdvbv5 API works with a set of key/value properties.
 * There are two types of properties:
 *
 * - The ones defined at the Kernel's frontent API, that are found at
 *  /usr/include/linux/dvb/frontend.h (actually, it uses a local copy
 *  of that file, stored at ./include/linux/dvb/frontend.h)
 *
 * - Some extra properties used by libdvbv5. Those can be found at
 *   lib/include/libdvbv5/dvb-v5-std.h and start at DTV_USER_COMMAND_START.
 *
 * Just like the DTV properties, the stats are cached. That warrants that
 * all stats are got at the same time, when dvb_fe_get_stats() is called.
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/**
 * @def ARRAY_SIZE(array)
 *	@brief Calculates the number of elements of an array
 * @ingroup ancillary
 */
extern (D) size_t ARRAY_SIZE(T)(auto ref T x)
{
    return x.sizeof / (x[0]).sizeof;
}

/**
 * @def MAX_DELIVERY_SYSTEMS
 *	@brief Max number of delivery systems for a given frontend.
 * @ingroup frontend
 */
enum MAX_DELIVERY_SYSTEMS = 20;

/*
 * There are a few aliases for other properties. Those are needed just
 * to avoid breaking apps that depend on the library but shoudn't be used
 * anymore on newer apps.
 */
enum DTV_MAX_STATS = DTV_NUM_STATS_PROPS;
enum DTV_SIGNAL_STRENGTH = DTV_STAT_SIGNAL_STRENGTH;
enum DTV_SNR = DTV_STAT_CNR;
enum DTV_UNCORRECTED_BLOCKS = DTV_STAT_ERROR_BLOCK_COUNT;

/**
 * @struct dvb_v5_fe_parms
 * @ingroup frontend
 * @brief Keeps data needed to handle the DVB frontend
 *
 * @param info			Contains the DVB info properties (RO)
 * @param version		Version of the Linux DVB API (RO)
 * @param has_v5_stats		A value different than 0 indicates that the
 *				frontend supports DVBv5 stats (RO)
 * @param current_sys		Currently selected delivery system (RO)
 * @param num_systems		Number of delivery systems  (RO)
 * @param systems		Delivery systems supported by the hardware (RO)
 * @param legacy_fe		A value different than 0 indicates a legacy
 *				Kernel driver using DVBv3 API only, or that
 *				DVBv3 only mode was forced by the client (RO)
 * @param abort			Client should set it to abort a pending
 *				operation like DTV scan (RW)
 * @param lna:			Sets the LNA mode 0 disables; 1 enables, -1 uses
 *				auto mode (RW)
 * @param lnb			LNBf description (RW)
 * @param sat_number		Number of the satellite (used by DISEqC setup) (RW)
 * @param freq_bpf		SCR/Unicable band-pass filter frequency to use, in kHz
 * @param verbose		Verbosity level of the library (RW)
 * @param dvb_logfunc		Function used to write log messages (RO)
 * @param default_charset	Name of the charset used by the DVB standard (RW)
 * @param output_charset	Name of the charset to output (system specific) (RW)
 *
 * @details The fields marked as RO should not be changed by the client, as otherwise
 * undesired effects may happen. The ones marked as RW are ok to either read
 * or write by the client.
 */
struct dvb_v5_fe_parms
{
    /* Information visible to the client - don't override those values */
    dvb_frontend_info info;
    uint version_;
    int has_v5_stats;
    fe_delivery_system_t current_sys;
    int num_systems;
    fe_delivery_system_t[MAX_DELIVERY_SYSTEMS] systems;
    int legacy_fe;

    /* The values below are specified by the library client */

    /* Flags from the client to the library */
    int abort;

    /* Linear Amplifier settings */
    int lna;

    /* Satellite settings */
    const(dvb_sat_lnb)* lnb;
    int sat_number;
    uint freq_bpf;
    uint diseqc_wait;

    /* Function to write DVB logs */
    uint verbose;
    dvb_logfunc logfunc;

    /* Charsets to be used by the conversion utilities */
    char* default_charset;
    char* output_charset;
}

/**
 * @brief Allocates a dummy frontend structure
 * @ingroup frontend
 *
 * @details This is useful for some applications that may want to just use the
 * frontend structure internally, without associating it with a real hardware
 *
 * @return Returns a pointer to a dummy struct, or NULL if no memory.
 */
dvb_v5_fe_parms* dvb_fe_dummy ();

/**
 * @brief Opens a frontend and allocates a structure to work with
 * @ingroup frontend
 *
 * @param adapter		Number of the adapter to open
 * @param frontend		Number of the frontend to open
 * @param verbose		Verbosity level of the messages that will be
 *				printed
 * @param use_legacy_call	Force to use the DVBv3 calls, instead of using
 *				the DVBv5 API
 * @param logfunc		Callback function to be called when a log event
 *				happens. Can either store the event into a file
 *				or to print it at the TUI/GUI. If NULL, the
 *				library will use its internal handler.
 * @param flags			Flags to be passed to open. Currently only two
 *				flags are supported: O_RDONLY or O_RDWR.
 *				Using O_NONBLOCK may hit unexpected issues.
 *
 * @todo Add/check support for O_NONBLOCK at the scan routines.
 *
 * @details This function should be called before using any other function at
 * the frontend library (or the other alternatives: dvb_fe_open() or
 * dvb_fe_dummy().
 *
 * In general, this is called using O_RDWR, except if all that it is wanted
 * is to check the DVB frontend statistics.
 *
 * @return Returns a pointer to an allocated data pointer or NULL on error.
 */
dvb_v5_fe_parms* dvb_fe_open_flags (
    int adapter,
    int frontend,
    uint verbose,
    uint use_legacy_call,
    dvb_logfunc logfunc,
    int flags);

/**
 * @brief Opens a frontend and allocates a structure to work with
 * @ingroup frontend
 *
 * @param adapter		Number of the adapter to open
 * @param frontend		Number of the frontend to open
 * @param verbose		Verbosity level of the messages that will be
 * 				printed
 * @param use_legacy_call	Force to use the DVBv3 calls, instead of using
 *				the DVBv5 API
 *
 * @details This function should be called before using any other function at
 * the frontend library (or the other alternatives: dvb_fe_open2() or
 * dvb_fe_dummy().
 *
 * @return Returns a pointer to an allocated data pointer or NULL on error.
 */
dvb_v5_fe_parms* dvb_fe_open (
    int adapter,
    int frontend,
    uint verbose,
    uint use_legacy_call);

/**
 * @brief Opens a frontend and allocates a structure to work with
 * @ingroup frontend
 *
 * @param adapter		Number of the adapter to open
 * @param frontend		Number of the frontend to open
 * @param verbose		Verbosity level of the messages that will be
 *				printed
 * @param use_legacy_call	Force to use the DVBv3 calls, instead of using
 *				the DVBv5 API
 * @param logfunc		Callback function to be called when a log event
 *				happens. Can either store the event into a file
 *				or to print it at the TUI/GUI.
 *
 * @details This function should be called before using any other function at
 * the frontend library (or the other alternatives: dvb_fe_open() or
 * dvb_fe_dummy().
 *
 * @return Returns a pointer to an allocated data pointer or NULL on error.
 */
dvb_v5_fe_parms* dvb_fe_open2 (
    int adapter,
    int frontend,
    uint verbose,
    uint use_legacy_call,
    dvb_logfunc logfunc);

/**
 * @brief Closes the frontend and frees allocated resources
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 */
void dvb_fe_close (dvb_v5_fe_parms* parms);

/**
 * @brief Returns the string name associated with a DVBv5 command
 * @ingroup frontend
 *
 * @param cmd	DVBv5 or libdvbv5 property
 *
 * @details This function gets an integer argument (cmd) and returns a string
 * that corresponds to the name of that property.
 *
 * @return it returns a string that corresponds to the property name.
 * For example:
 * 	dvb_cmd_name(DTV_GUARD_INTERVAL) would return "GUARD_INTERVAL"
 * It also returns names for the properties used internally by libdvbv5.
 */
const(char)* dvb_cmd_name (int cmd);

/**
 * @brief Returns an string array with the valid string values associated with a DVBv5 command
 * @ingroup frontend
 *
 * @param cmd	DVBv5 or libdvbv5 property
 *
 * @return it returns a string array that corresponds to the names associated
 * with the possible values for that property, when available.
 * For example:
 * 	dvb_cmd_name(DTV_CODE_RATE_HP) would return an array with the
 * possible values for the code rates:
 *	{ "1/2", "2/3", ... NULL }
 * @note The array always ends with NULL.
 */
const(char*)* dvb_attr_names (int cmd);

/* Get/set delivery system parameters */

/**
 * @brief Retrieves the value of a DVBv5/libdvbv5 property
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param cmd	DVBv5 or libdvbv5 property
 * @param value	Pointer to an uint32_t where the value will be stored.
 *
 * This reads the value of a property stored at the cache. Before using it,
 * a dvb_fe_get_parms() is likely required.
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_fe_retrieve_parm (const(dvb_v5_fe_parms)* parms, uint cmd, uint* value);

/**
 * @brief Stores the value of a DVBv5/libdvbv5 property
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param cmd	DVBv5 or libdvbv5 property
 * @param value	Pointer to an uint32_t where the value will be stored.
 *
 * This stores the value of a property at the cache. The value will only
 * be send to the hardware after calling dvb_fe_set_parms().
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_fe_store_parm (dvb_v5_fe_parms* parms, uint cmd, uint value);

/**
 * @brief Sets the delivery system
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param sys	delivery system to be selected
 *
 * This function changes the delivery system of the frontend. By default,
 * the libdvbv5 will use the first available delivery system. If another
 * delivery system is desirable, this function should be called before being
 * able to store the properties for the new delivery system via
 * dvb_fe_store_parm().
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_set_sys (dvb_v5_fe_parms* parms, fe_delivery_system_t sys);

/**
 * @brief Make dvb properties reflect the current standard
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param sys	delivery system to be selected
 *
 * This function prepares the properties cache for a given delivery system.
 *
 * It is automatically called by dvb_set_sys(), and should not be normally
 * called, except when dvb_fe_dummy() is used.
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_add_parms_for_sys (dvb_v5_fe_parms* parms, fe_delivery_system_t sys);

/**
 * @brief Sets the delivery system
 * @ingroup frontend
 *
 * @param parms			struct dvb_v5_fe_parms pointer to the opened
 *				device
 * @param desired_system	delivery system to be selected
 *
 * This function changes the delivery system of the frontend. By default,
 * the libdvbv5 will use the first available delivery system. If another
 * delivery system is desirable, this function should be called before being
 * able to store the properties for the new delivery system via
 * dvb_fe_store_parm().
 *
 * This function is an enhanced version of dvb_set_sys(). It has an special
 * logic inside to work with Kernels that supports only DVBv3.
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_set_compat_delivery_system (
    dvb_v5_fe_parms* parms,
    uint desired_system);

/**
 * @brief Prints all the properties at the cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 *
 * Used mostly for debugging issues.
 */
void dvb_fe_prt_parms (const(dvb_v5_fe_parms)* parms);

/**
 * @brief Prints all the properties at the cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 *
 * Writes the properties stored at the DVB cache at the DVB hardware. At
 * return, some properties could have a different value, as the frontend
 * may not support the values set.
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_fe_set_parms (dvb_v5_fe_parms* parms);

/**
 * @brief Prints all the properties at the cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 *
 * Gets the properties from the DVB hardware. The values will only reflect
 * what's set at the hardware if the frontend is locked.
 *
 * @return Return 0 if success, EINVAL otherwise.
 */
int dvb_fe_get_parms (dvb_v5_fe_parms* parms);

/*
 * statistics functions
 */

/**
 * @brief Retrieve the stats for a DTV layer from cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param cmd	DVBv5 or libdvbv5 property
 * @param layer	DTV layer
 *
 * Gets the value for one stats cache, on a given layer. Layer 0 is
 * always present. On DTV standards that doesn't have layers, it returns
 * the same value as dvb_fe_retrieve_stats() for layer = 0.
 *
 * For DTV standards with multiple layers, like ISDB, layer=1 is layer 'A',
 * layer=2 is layer 'B' and layer=3 is layer 'C'. Please notice that not all
 * frontends support per-layer stats. Also, the layer value is only valid if
 * the layer exists at the original stream.
 * Also, on such standards, layer 0 is typically a mean value of the layers,
 * or a sum of events (if FE_SCALE_COUNTER).
 *
 * For it to be valid, dvb_fe_get_stats() should be called first.
 *
 * @return It returns a struct dtv_stats if succeed or NULL otherwise.
 */
dtv_stats* dvb_fe_retrieve_stats_layer (
    dvb_v5_fe_parms* parms,
    uint cmd,
    uint layer);

/**
 * @brief Retrieve the stats for a DTV layer from cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param cmd	DVBv5 or libdvbv5 property
 * @param value	DTV value pointer
 *
 * Gets the value for one stats property for layer = 0.
 *
 * For it to be valid, dvb_fe_get_stats() should be called first.
 *
 * @return The returned value is 0 if success, EINVAL otherwise.
 */
int dvb_fe_retrieve_stats (dvb_v5_fe_parms* parms, uint cmd, uint* value);

/**
 * @brief Retrieve the stats from the Kernel
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 *
 * Updates the stats cache from the available stats at the Kernel.
 *
 * @return The returned value is 0 if success, EINVAL otherwise.
 */
int dvb_fe_get_stats (dvb_v5_fe_parms* parms);

/**
 * @brief Retrieve the BER stats from cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param layer	DTV layer
 * @param scale	retrieves the scale
 *
 * Gets the value for BER stats from stats cache, on a given layer. Layer 0 is
 * always present. On DTV standards that doesn't have layers, it returns
 * the same value as dvb_fe_retrieve_stats() for layer = 0.
 *
 * For DTV standards with multiple layers, like ISDB, layer=1 is layer 'A',
 * layer=2 is layer 'B' and layer=3 is layer 'C'. Please notice that not all
 * frontends support per-layer stats. Also, the layer value is only valid if
 * the layer exists at the original stream.
 * Also, on such standards, layer 0 is typically a mean value of the layers,
 * or a sum of events (if FE_SCALE_COUNTER).
 *
 * For it to be valid, dvb_fe_get_stats() should be called first.
 *
 * @return It returns a float number for the BER value.
 * If the statistics is not available for any reason, scale will be equal to
 * FE_SCALE_NOT_AVAILABLE.
 */
float dvb_fe_retrieve_ber (
    dvb_v5_fe_parms* parms,
    uint layer,
    fecap_scale_params* scale);

/**
 * @brief Retrieve the PER stats from cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param layer	DTV layer
 *
 * Gets the value for BER stats from stats cache, on a given layer. Layer 0 is
 * always present. On DTV standards that doesn't have layers, it returns
 * the same value as dvb_fe_retrieve_stats() for layer = 0.
 *
 * For DTV standards with multiple layers, like ISDB, layer=1 is layer 'A',
 * layer=2 is layer 'B' and layer=3 is layer 'C'. Please notice that not all
 * frontends support per-layer stats. Also, the layer value is only valid if
 * the layer exists at the original stream.
 * Also, on such standards, layer 0 is typically a mean value of the layers,
 * or a sum of events (if FE_SCALE_COUNTER).
 *
 * For it to be valid, dvb_fe_get_stats() should be called first.
 *
 * @return A negative value indicates error.
 */
float dvb_fe_retrieve_per (dvb_v5_fe_parms* parms, uint layer);

/**
 * @brief Retrieve the quality stats from cache
 * @ingroup frontend
 *
 * @param parms	struct dvb_v5_fe_parms pointer to the opened device
 * @param layer	DTV layer
 *
 * Gets a quality measure for a given layer. Layer 0 is
 * always present. On DTV standards that doesn't have layers, it returns
 * the same value as dvb_fe_retrieve_stats() for layer = 0.
 *
 * For DTV standards with multiple layers, like ISDB, layer=1 is layer 'A',
 * layer=2 is layer 'B' and layer=3 is layer 'C'. Please notice that not all
 * frontends support per-layer stats. Also, the layer value is only valid if
 * the layer exists at the original stream.
 * Also, on such standards, layer 0 is typically a mean value of the layers,
 * or a sum of events (if FE_SCALE_COUNTER).
 *
 * For it to be valid, dvb_fe_get_stats() should be called first.
 *
 * @return returns an enum dvb_quantity, where DVB_QUAL_UNKNOWN means that
 * the stat isnot available.
 */
dvb_quality dvb_fe_retrieve_quality (dvb_v5_fe_parms* parms, uint layer);

/**
 * @brief Ancillary function to sprintf on ENG format
 * @ingroup frontend
 *
 * @param buf	buffer to store the value
 * @param len	buffer length
 * @param val	value to be printed
 *
 * On ENG notation, the exponential value should be multiple of 3. This is
 * good to display some values, like BER.
 *
 * @return At return, it shows the actual size of the print. A negative value
 * indicates an error.
 */
int dvb_fe_snprintf_eng (char* buf, int len, float val);

/**
 * @brief Ancillary function to sprintf on ENG format
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param cmd		DVBv5 or libdvbv5 property
 * @param display_name	String with the name of the property to be shown
 * @param layer		DTV Layer
 * @param buf		buffer to store the value
 * @param len		buffer length
 * @param show_layer_name	a value different than zero shows the layer name, if
 * 			the layer is bigger than zero.
 *
 * This function calls internally dvb_fe_retrieve_stats_layer(). It allows to
 * print a DVBv5 statistics value into a string. An extra property is available
 * (DTV_QUALITY) with prints either one of the values: Poor, Ok or Good,
 * depending on the overall measures.
 *
 * @return: It returns the length of the printed data. A negative value
 * indicates an error.
 */
int dvb_fe_snprintf_stat (
    dvb_v5_fe_parms* parms,
    uint cmd,
    char* display_name,
    int layer,
    char** buf,
    int* len,
    int* show_layer_name);

/**
 * @brief Get both status statistics and dvb parameters
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 *
 * That's similar of calling both dvb_fe_get_parms() and dvb_fe_get_stats().
 *
 * @return It returns 0 if success or an errorno otherwise.
 */
int dvb_fe_get_event (dvb_v5_fe_parms* parms);

/*
 * Other functions, associated to SEC/LNB/DISEqC
 *
 * The functions below are just wrappers for the Kernel calls, in order to
 * manually control satellite systems.
 *
 * Instead of using most them, the best is to set the LNBf parameters, and let
 * the libdvbv5 to automatically handle the calls.
 *
 * NOTE: It currently lacks support for two ioctl's:
 * FE_DISEQC_RESET_OVERLOAD	used only on av7110.
 * Spec says:
 *   If the bus has been automatically powered off due to power overload,
 *   this ioctl call restores the power to the bus. The call requires read/write
 *   access to the device. This call has no effect if the device is manually
 *   powered off. Not all DVB adapters support this ioctl.
 *
 * FE_DISHNETWORK_SEND_LEGACY_CMD is used on av7110, budget, gp8psk and stv0299
 * Spec says:
 *   WARNING: This is a very obscure legacy command, used only at stv0299
 *   driver. Should not be used on newer drivers.
 *   It provides a non-standard method for selecting Diseqc voltage on the
 *   frontend, for Dish Network legacy switches.
 *   As support for this ioctl were added in 2004, this means that such dishes
 *   were already legacy in 2004.
 *
 * So, it doesn't make much sense on implementing support for them.
 */

/**
 * @brief DVB ioctl wrapper for setting SEC voltage
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param on		a value different than zero indicates to enable
 *			voltage on a Satellite Equipment Control (SEC)
 * @param v18		if on != 0, a value different than zero means 18 Volts;
 *			zero means 13 Volts.
 *
 * If dvb_v5_fe_parms::lnb is set, this is controlled automatically.
 */
int dvb_fe_sec_voltage (dvb_v5_fe_parms* parms, int on, int v18);

/**
 * @brief DVB ioctl wrapper for setting SEC tone
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param tone		tone setting, as defined by DVB fe_sec_tone_mode_t type
 *
 * If dvb_v5_fe_parms::lnb is set, this is controlled automatically.
 */
int dvb_fe_sec_tone (dvb_v5_fe_parms* parms, fe_sec_tone_mode_t tone);

/**
 * @brief DVB ioctl wrapper for setting LNBf high voltage
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param on		a value different than zero indicates to produce
 *			lightly higher voltages instead of 13/18V, in order
 *			to compensate for long cables.
 */
int dvb_fe_lnb_high_voltage (dvb_v5_fe_parms* parms, int on);

/**
 * @brief DVB ioctl wrapper for setting SEC DiSeqC tone burst to select between
 *	  satellite A or B
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param mini_b	if different than zero, sends a 22 KHz tone burst to
 *			select satellite B. Otherwise, sends tone to select
 *			satellite A.
 *
 * Valid only on certain DISEqC arrangements.
 *
 * If dvb_v5_fe_parms::lnb is set, this is controlled automatically.
 */
int dvb_fe_diseqc_burst (dvb_v5_fe_parms* parms, int mini_b);

/**
 * @brief DVB ioctl wrapper for setting SEC DiSeqC command
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param len		size of the DiSEqC command
 * @param buf		DiSEqC command to be sent
 *
 * If dvb_v5_fe_parms::lnb is set, this is controlled automatically.
 */
int dvb_fe_diseqc_cmd (
    dvb_v5_fe_parms* parms,
    const uint len,
    const(ubyte)* buf);

/**
 * @brief DVB ioctl wrapper for getting SEC DiSEqC reply
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param len		size of the DiSEqC command
 * @param buf		DiSEqC command to be sent
 * @param timeout	maximum time to receive the command, in ms.
 *
 * If dvb_v5_fe_parms::lnb is set, this is controlled automatically.
 */
int dvb_fe_diseqc_reply (
    dvb_v5_fe_parms* parms,
    uint* len,
    char* buf,
    int timeout);

/**
 * @brief DVB Ancillary routine to check if a given Delivery system is satellite
 * @ingroup frontend
 *
 * @param delivery_system	delivery system to be selected
 */
int dvb_fe_is_satellite (uint delivery_system);

/**
 * @brief Set default country variant of delivery systems like ISDB-T
 * @ingroup frontend
 *
 * @param parms		struct dvb_v5_fe_parms pointer to the opened device
 * @param country	default country, in ISO 3166-1 two letter code. If
 *			NULL, default charset is guessed from locale environment
 *			variables.
 *
 * @return 0 if success or an errorno otherwise.
 *
 * "COUNTRY" property in dvb_fe_set_parm() overrides the setting.
 */
int dvb_fe_set_default_country (dvb_v5_fe_parms* parms, const(char)* country);

/*
 * Arrays from dvb-v5.h
 *
 * Those arrays can be used to translate from a DVB property into a name.
 *
 * No need to directly access them from userspace, as dvb_attr_names()
 * already handles them into a more standard way.
 */

extern __gshared const(uint)[8] fe_bandwidth_name;
extern __gshared const(char)*[71] dvb_v5_name;
extern __gshared const(void)*[] dvb_v5_attr_names;
extern __gshared const(char)*[20] delivery_system_name;
extern __gshared const(char)*[14] fe_code_rate_name;
extern __gshared const(char)*[15] fe_modulation_name;
extern __gshared const(char)*[10] fe_transmission_mode_name;
extern __gshared const(char)*[12] fe_guard_interval_name;
extern __gshared const(char)*[6] fe_hierarchy_name;
extern __gshared const(char)*[4] fe_voltage_name;
extern __gshared const(char)*[3] fe_tone_name;
extern __gshared const(char)*[4] fe_inversion_name;
extern __gshared const(char)*[4] fe_pilot_name;
extern __gshared const(char)*[5] fe_rolloff_name;

