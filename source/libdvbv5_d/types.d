import std.exception: enforce;
import std.string: toStringz;

import libdvbv5_d.dvb_demux: dvb_dmx_open, dvb_dmx_close;
import libdvbv5_d.dvb_fe: dvb_v5_fe_parms, dvb_fe_open, dvb_fe_close;
import libdvbv5_d.dvb_file: dvb_file, dvb_entry, dvb_file_free, dvb_file_formats, dvb_read_file_format;
import libdvbv5_d.dvb_scan: dvb_v5_descriptors, check_frontend_t, dvb_scan_transponder, dvb_scan_free_handler_table;

/**
 * A pair (adapter_number, frontend_number) to uniquely index all the frontends
 * available at any one time during execution. Collected directly from the files
 * in /dev/dvb.
 */
struct FrontendId {
	const uint adapter_number;
	const uint frontend_number;

	this(const uint a_n, const uint f_n) {
		adapter_number = a_n;
		frontend_number = f_n;
	}

	bool opEquals()(const FrontendId other) const {
		if (this is other) return true;
		if (other is null) return false;
		return this.adapter_number == other.adapter_number && this.frontend_number == other.frontend_number;
	}
};

/**
 * A pair (where the first item is a `FrontendId` pair)  to describe the tuning information
 * for a given frontend when it is tuned in.
 */
struct TuningId {
	const FrontendId frontend_id;
	const string channel_name;

	this(const FrontendId f_i, const string c_n) {
		frontend_id = f_i;
		channel_name = c_n;
	}

	bool opEquals()(const TuningId other) const {
		if (this is other) return true;
		if (other is null) return false;
		return this.frontend_id == other.frontend_id && this.channel_name == other.channel_name;
	}
};

/**
 * Given an adapter_number and a frontend_number for that adapter, instances of this type
 * are RAII compliant pointers to the kernel managed data relating to that frontend.
 *
 * The idea is that this is a domain specific std::unique_ptr like type.
 */
struct FrontendParameters_Ptr {
  private:
     dvb_v5_fe_parms* ptr;
  public:
	@disable this(this);
	this(const FrontendId fei, const uint verbose = 0, const uint useLegacyCall = 0) {
		ptr = enforce(dvb_fe_open(fei.adapter_number, fei.frontend_number, verbose, useLegacyCall));
	}
	~this() { dvb_fe_close(ptr); }
	auto c_ptr() { return ptr; }
	alias c_ptr this;
}

/**
 * An RAII compliant pointer to a `dvb_file`.
 */
struct File_Ptr {
  private:
	dvb_file* ptr;
  public:
	//@disable this(this);
	this(const string path, const uint delsys, const dvb_file_formats format) {
		ptr = enforce(dvb_read_file_format(toStringz(path), delsys, format));
	}
	this(dvb_file* p) {
		ptr = p;
	}
	~this() { dvb_file_free(ptr); }
	bool isOpen() { return ptr !is null; }
	auto c_ptr() { return ptr; }
	alias c_ptr this;
};

/**
 * An RAII compliant DMX file descriptor.
 */
struct DMX_FD {
  private:
	const int fd;
  public:
	@disable this(this);
	this(const FrontendId fei) {
		fd = enforce(dvb_dmx_open(fei.adapter_number, fei.frontend_number));
	}
	~this() { dvb_dmx_close(fd); }
	auto value() { return fd; }
};

/**
 * An RAII compliant pointer to a `dvb_v5_descriptors` object.
 */
struct ScanHandler_Ptr {
  private:
	dvb_v5_descriptors* ptr;
  public:
	@disable this(this);
	this(
		 dvb_v5_fe_parms* frontendParameters,
		 dvb_entry* entry,
		 const int dmx_fd,
		 check_frontend_t check_frontend,
		 const uint other_nit,
		 const uint timeout_multiplier
		 ) {
		ptr = enforce(
			dvb_scan_transponder(
				frontendParameters,
				entry,
				cast(int)dmx_fd,
				check_frontend,
				cast(void*)null,
				cast(uint)other_nit,
				cast(uint)timeout_multiplier
				)
		);
	}
	~this() { dvb_scan_free_handler_table(ptr); }
	auto c_ptr() { return ptr; }
	alias c_ptr this;
};