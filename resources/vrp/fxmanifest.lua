fx_version "bodacious"
game "gta5"
lua54 "yes"
version "HensaRewritten"
author "ImagicTheCat"
creative_network "yes"
creator "no"

ui_page "gui/index.html"

client_scripts {
	"lib/Utils.lua",

	"config/Global.lua",
	"config/Discord.lua",
	"config/Groups.lua",
	"config/Item.lua",
	"config/Native.lua",
	"config/Vehicle.lua",

	"client/base.lua",
	"client/vehicles.lua",
	"client/gui.lua",
	"client/iplloader.lua",
	"client/noclip.lua",
	"client/objects.lua",
	"client/player.lua",
	"client/survival.lua"
}

server_scripts {
	"lib/Utils.lua",

	"config/Global.lua",
	"config/Discord.lua",
	"config/Groups.lua",
	"config/Item.lua",
	"config/Native.lua",
	"config/Vehicle.lua",

	"modules/vrp.lua",
	"modules/base.lua",
	"modules/drugs.lua",
	"modules/groups.lua",
	"modules/identity.lua",
	"modules/experience.lua",
	"modules/inventory.lua",
	"modules/money.lua",
	"modules/player.lua",
	"modules/premium.lua",
	"modules/medicplan.lua",
	"modules/prepare.lua",
	"modules/queue.lua",
	"modules/vehicles.lua"
}

files {
	"lib/*",
	"gui/*",
	"config/*",
	"config/**/*"
}

escrow_ignore {
	"lib/*",
	"gui/*",
	"config/*",
	"modules/vrp.lua",
	"modules/prepare.lua"
}