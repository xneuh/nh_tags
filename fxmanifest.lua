fx_version 'adamant'
game 'gta5'

lua54 'yes'

client_scripts {
	'@es_extended/imports.lua',
	"settings.lua",
	"client/cl_main.lua"
}

server_scripts {
	'@es_extended/imports.lua',
	"settings_sv.lua",
	"@oxmysql/lib/MySQL.lua",
	"server/sv_main.lua"
}
