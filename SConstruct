buildDirectory = 'Build'

version = '0.1.0'

environment = Environment(
    tools=['ldc', 'link', 'ar'],
    DPATH=['#source', '#generated'],
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

Command('test', testExecutable, './$SOURCE')

Clean('.', buildDirectory)
