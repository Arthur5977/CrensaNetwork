-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bus")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Selected = 1
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local Locations = {
	vec3(407.9,-581.35,28.75),
	vec3(656.14,-236.33,43.32),
	vec3(897.14,154.11,73.47),
	vec3(1107.09,347.24,91.04),
	vec3(988.99,512.08,102.56),
	vec3(857.11,374.6,118.2),
	vec3(587.13,284.43,103.76),
	vec3(527.69,133.92,97.68),
	vec3(270.61,177.96,104.64),
	vec3(134.84,11.83,68.56),
	vec3(-117.74,73.22,71.22),
	vec3(-478.41,129.02,63.94),
	vec3(-806.65,94.21,53.65),
	vec3(-817.67,-16.39,39.45),
	vec3(-736.37,-180.96,37.15),
	vec3(-565.74,-157.23,38.08),
	vec3(-357.73,-329.09,31.51),
	vec3(-231.07,-560.79,34.61),
	vec3(-502.7,-652.86,33.06),
	vec3(-884.47,-651.73,27.92),
	vec3(-1149.83,-818.65,14.81),
	vec3(-1103.77,-951.99,2.46),
	vec3(-996.85,-1135.96,2.16),
	vec3(-1086.92,-1291.54,5.63),
	vec3(-1204.25,-1206.94,7.72),
	vec3(-1283.49,-1223.59,4.57),
	vec3(-1177.21,-1451.11,4.36),
	vec3(-1064.98,-1611.65,4.4),
	vec3(-1026.73,-1554.34,5.12),
	vec3(-1078.03,-1376.3,5.16),
	vec3(-862.48,-1180.82,5.19),
	vec3(-743.02,-1173.32,10.63),
	vec3(-691.01,-1481.69,10.87),
	vec3(-974.91,-1838.18,19.55),
	vec3(-987.13,-2126.21,10.41),
	vec3(-784.2,-1977.09,8.96),
	vec3(-475.02,-2149.62,9.42),
	vec3(-180.87,-2186.07,10.31),
	vec3(-68.96,-1969.1,17.56),
	vec3(-206.87,-1809.15,29.91),
	vec3(-36.69,-1820.95,26.29),
	vec3(109.73,-1845.34,25.43),
	vec3(309.29,-1901.76,26.42),
	vec3(278.71,-2123.67,15.87),
	vec3(453.28,-2102.33,21.74),
	vec3(422.63,-1871.74,26.84),
	vec3(501.74,-1734.14,29.1),
	vec3(387.79,-1560.14,29.3),
	vec3(203.65,-1344.34,29.28),
	vec3(373.48,-1286.72,32.45),
	vec3(500.91,-1099.79,29.15),
	vec3(486.02,-677.07,25.93)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUS:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("bus:Init")
AddEventHandler("bus:Init",function()
	if Active then
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
			Blip = nil
		end

		exports["target"]:LabelText("WorkBus","Trabalhar")
		TriggerEvent("Notify","Sucesso","Trabalho finalizado.","verde",5000)
		Active = false
	else
		exports["target"]:LabelText("WorkBus","Finalizar")
		TriggerEvent("Notify","Sucesso","Trabalho iniciado.","verde",5000)
		Active = true
		MakeBlips()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Active then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetEntityArchetypeName(Vehicle) == "bus" then
					local Coords = GetEntityCoords(Ped)
					local Distance = #(Coords - Locations[Selected])

					if Distance <= 200 then
						TimeDistance = 1

						DrawMarker(22,Locations[Selected]["x"],Locations[Selected]["y"],Locations[Selected]["z"] + 3.0,0.0,0.0,0.0,0.0,180.0,0.0,7.5,7.5,5.0,65,130,226,100,0,0,0,1)
						DrawMarker(1,Locations[Selected]["x"],Locations[Selected]["y"],Locations[Selected]["z"] - 3.0,0.0,0.0,0.0,0.0,0.0,0.0,15.0,15.0,10.0,255,255,255,50,0,0,0,0)

						if Distance <= 10 then
							if Selected >= #Locations then
								Selected = 1
							else
								Selected = Selected + 1
							end

							vSERVER.Payment()
							MakeBlips()
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeBlips()
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end

	Blip = AddBlipForCoord(Locations[Selected]["x"],Locations[Selected]["y"],Locations[Selected]["z"])
	SetBlipSprite(Blip,1)
	SetBlipDisplay(Blip,4)
	SetBlipAsShortRange(Blip,true)
	SetBlipColour(Blip,77)
	SetBlipScale(Blip,0.75)
	SetBlipRoute(Blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Motorista")
	EndTextCommandSetBlipName(Blip)
end