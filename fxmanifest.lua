fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

author 'Tox'
description ''
version '1.0.0'

server_scripts {
    '@ox_lib/init.lua',
    'cfg/sv_config.lua',
	'server/sv_main.lua'
}

client_scripts {
    '@ox_lib/init.lua',
	'client/cl_main.lua'
}
