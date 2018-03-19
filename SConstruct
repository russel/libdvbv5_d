buildDirectory = 'Build'

version = '0.0.0'

environment = Environment(
    tools=['ldc', 'link', 'ar'],
    DPATH=['#source',],
    DFLAGS=['-O', '-release'],
    SHLIBVERSION=version,
    DSHLIBVERSION=version,
    targetRoot='libdvbv5_d',
    isTest=False,
)

staticLibrary, sharedLibrary = SConscript('SConscript', variant_dir=buildDirectory + '/Release', duplicate=0, exports={'environment': environment})

Alias('libraries', [staticLibrary, sharedLibrary])

testEnvironment = environment.Clone()
testEnvironment['isTest'] = True

testExecutable, _ = SConscript('SConscript', variant_dir=buildDirectory + '/Test', duplicate=0, exports={'environment': testEnvironment})

Alias('test', testExecutable)

Clean('.', buildDirectory)
