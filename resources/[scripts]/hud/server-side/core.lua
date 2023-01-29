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
Tunnel.bindInterface("hud",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Work"] = 0
GlobalState["Hours"] = 12
GlobalState["Minutes"] = 0
GlobalState["Weather"] = "CLEAR"
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Blackout"] = 0
GlobalState["BlackoutCount"] = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEATHERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local weatherList = { "CLEAR","EXTRASUNNY","SMOG","OVERCAST","CLOUDS","CLEARING" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		GlobalState["Work"] = GlobalState["Work"] + 1
		GlobalState["Minutes"] = GlobalState["Minutes"] + 1

		if GlobalState["Minutes"] >= 60 then
			GlobalState["Hours"] = GlobalState["Hours"] + 1
			GlobalState["Minutes"] = 0

			if GlobalState["Hours"] >= 24 then
				GlobalState["Hours"] = 0

				repeat
					randWeather = math.random(#weatherList)
				until GlobalState["Weather"] ~= weatherList[randWeather]

				GlobalState["Weather"] = weatherList[randWeather]
			end
		end

		if GlobalState["Blackout"] == 1 then
			GlobalState["BlackoutCount"] = GlobalState["BlackoutCount"] + 1

			if GlobalState["BlackoutCount"] >= 80 then
				GlobalState["Blackout"] = 0
				GlobalState["BlackoutCount"] = 0
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("timeset",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			GlobalState["Hours"] = parseInt(Message[1])
			GlobalState["Minutes"] = parseInt(Message[2])

			if Message[3] then
				GlobalState["Weather"] = Message[3]
			end

			if Message[4] then
				GlobalState["Blackout"] = parseInt(Message[4])
			end
		end
	end
end)