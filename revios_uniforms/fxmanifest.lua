fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Revios Ace'
description 'Put Outfits on and off'

client_scripts {
	'config/config.lua',
	'client/client.lua'
}

shared_script '@es_extended/imports.lua'

server_scripts {
	'config/config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}
