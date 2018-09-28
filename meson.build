# -*- mode:python; code=utf-8; -*-

project(
    'libdvbv5_d',
    'd',
    version: '0.1.0',
    default_options: ['buildtype=release'],
)

sources = run_command('sh', '-c', 'cd $MESON_SOURCE_ROOT && ls source/libdvbv5_d/*.d generated/libdvbv5_d/*.d').stdout().split()

includes = [
  include_directories('source'),
  include_directories('generated'),
]

libdvbv5_d = library(
  'dvbv5_d',
  sources,
  include_directories: includes,
  d_args: [],
  link_args: [],
  version: meson.project_version(),
  install: true,
)

install_headers(sources, subdir: 'd/' + meson.project_name())

pkgconfig = import('pkgconfig')
pkgconfig.generate(
    description: 'D binding for the libdvbv5 library.',
    name: meson.project_name(),
    version: meson.project_version(),
    subdirs: 'd/',
    libraries: libdvbv5_d,
)

test_executable = executable(
  'libdvbv5_d_test',
  sources,
  include_directories: includes,
  d_args: ['-unittest'],
  link_args: ['--main'],
)

test('all_tests', test_executable)
