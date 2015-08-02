package = 'lib'
version = 'scm-1'
source  = {
    url    = 'git://github.com/Mons/tnt-lib.git',
    branch = 'master',
}
description = {
    summary  = "Easily set custom package.path",
    homepage = 'https://github.com/Mons/tnt-lib.git',
    license  = 'BSD',
}
dependencies = {
    'lua >= 5.1'
}
build = {
    type = 'builtin',
    modules = {
        ['lib'] = 'lib.lua'
    }
}

-- vim: syntax=lua
