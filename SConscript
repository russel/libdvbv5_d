Import('environment')

sources = [ 'source/libdvbv5_d/' + name for name in (
    'linux_dmx.d',
    'dvb_v5_std.d',
    'dvb_frontend.d',
    'dvb_log.d',
    'dvb_demux.d',
    'dvb_fe.d',
    'dvb_file.d',
    'dvb_scan.d',
    'dvb_sat.d',
)]

if environment['isTest']:
    staticLibrary = environment.ProgramAllAtOnce(environment['targetRoot'], sources, DFLAGS=['-unittest', '--main'])
    sharedLibrary = None
else:
    staticLibrary = environment.StaticLibrary(environment['targetRoot'], sources)
    sharedLibrary = environment.SharedLibrary(environment['targetRoot'], sources)

Return('staticLibrary', 'sharedLibrary')
