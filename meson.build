# -*- mode:python; code=utf-8; -*-

project(
    'libdvbv5_d',
    'd',
    version: '0.0.0',
    default_options: ['buildtype=release'],
)

sources = [
    'source/libdvbv5_d/linux_dmx.d',
    'source/libdvbv5_d/dvb_v5_std.d',
    'source/libdvbv5_d/dvb_frontend.d',
    'source/libdvbv5_d/dvb_log.d',
    'source/libdvbv5_d/dvb_demux.d',
    'source/libdvbv5_d/dvb_fe.d',
    'source/libdvbv5_d/dvb_file.d',
    'source/libdvbv5_d/dvb_scan.d',
    'source/libdvbv5_d/dvb_sat.d',
]

includes = [
  include_directories('source'),
]

shared_library(
  'dvbv5_d',
  sources,
  include_directories: includes,
  d_args: [],
  link_args: [],
  version: meson.project_version(),
  install: true,
)

#static_library(
#  'dvbv5_d',
#  sources,
#  include_directories: includes,
#  d_args: [],
#  link_args: [],
#  install: true,
#)

install_headers(sources, subdir: 'd/' + meson.project_name())

# The pkgconfig system produces C/C++ library flags which are of
# little use with ldc2, so must do things the hard way. :-(

pc_file_data = configuration_data()
pc_file_data.set('NAME', meson.project_name())
pc_file_data.set('VERSION', meson.project_version())
pc_file_data.set('DESCRIPTION', 'D binding for the libdvbv5 library..')
pc_file_data.set('LIBS', '-L-L${libdir} -L-l' + meson.project_name())
pc_file_data.set('CFLAGS', '-I${includedir}/d')
pc_file_data.set('PREFIX', get_option('prefix'))
pc_file = configure_file(configuration: pc_file_data, input: meson.project_name() + '.pc.in', output: meson.project_name() + '.pc')

install_data(pc_file, install_dir: 'share/pkgconfig')

test_executable = executable(
  'libdvbv5_d_test',
  sources,
  include_directories: includes,
  d_args: ['-unittest'],
  link_args: ['--main'],
)

test('all tests', test_executable)