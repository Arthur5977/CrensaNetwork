-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("tencode",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local codes = {
	[1] = {
		tag = "QTI",
		text = "Deslocamento",
		blip = 77
	},
	[2] = {
		tag = "QTH",
		text = "Localização",
		blip = 1
	},
	[3] = {
		tag = "QRR",
		text = "Reforço solicitado",
		blip = 38
	},
	[4] = {
		tag = "QRT",
		text = "Oficial ferido",
		blip = 6
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDCODE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.sendCode(code)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Identity = vRP.Identity(Passport)
		local Service = vRP.NumPermission("Police")
		for Passports,Sources in pairs(Service) do
			async(function()
				if code ~= 4 then
					vRPC.playSound(Sources,"Event_Start_Text","GTAO_FM_Events_Soundset")
				end

				TriggerClientEvent("NotifyPush",Sources,{ code = codes[parseInt(code)]["tag"], title = codes[parseInt(code)]["text"], x = Coords["x"], y = Coords["y"], z = Coords["z"], name = Identity["name"].." "..Identity["name2"], time = "Recebido às "..os.date("%H:%M"), blipColor = codes[parseInt(code)]["blip"] })
			end)
		end
	end
end