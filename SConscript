Import('environment')

sources = Glob('source/libdvbv5_d/*.d') + Glob('generated/libdvbv5_d/*.d')

if environment['isTest']:
    staticLibrary = environment.ProgramAllAtOnce(environment['targetRoot'], sources, DFLAGS=['-unittest', '--main'])
    sharedLibrary = None
else:
    staticLibrary = environment.StaticLibrary(environment['targetRoot'], sources)
    sharedLibrary = environment.SharedLibrary(environment['targetRoot'], sources)

Return('staticLibrary', 'sharedLibrary')
