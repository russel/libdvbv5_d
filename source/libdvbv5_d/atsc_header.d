/*
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

module libdvbv5_d.atsc_header;

extern (C):

/**
 * @file atsc_header.h
 * @ingroup dvb_table
 * @brief Provides some common ATSC stuff
 * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
 * @author Andre Roth
 *
 * @par Bug Report
 * Please submit bug reports and patches to linux-media@vger.kernel.org
 */

/* ssize_t */

/**
 * @def ATSC_BASE_PID
 *	@brief ATSC PID for the Program and System Information Protocol
 * @ingroup dvb_table
 */
enum ATSC_BASE_PID = 0x1FFB;

/* Deprecated, as it causes troubles with doxygen */

/* _DOXYGEN */

/* _ATSC_HEADER_H */
