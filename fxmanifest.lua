fx_version 'adamant'
game 'gta5'

lua54 'yes'

client_scripts {
	"settings.lua",
	"client/cl_main.lua"
}

server_scripts {
	"settings_sv.lua",
	"@oxmysql/lib/MySQL.lua",
	"server/sv_main.lua"
}
