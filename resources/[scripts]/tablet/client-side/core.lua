-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicle = nil
local Drive = false
local Open = "Santos"
local TestCoords = { 0.0,0.0,0.0 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Open")
AddEventHandler("tablet:Open",function(Select)
	if LocalPlayer["state"]["Route"] < 900000 then
		local Ped = PlayerPedId()
		if not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(Ped) > 100 then
			Open = Select
			SetNuiFocus(true,true)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "Open" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "Close" })

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Carros",function(Data,Callback)
	Callback({ result = GlobalState["Cars"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Motos",function(Data,Callback)
	Callback({ result = GlobalState["Bikes"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Aluguel",function(Data,Callback)
	Callback({ result = GlobalState["Rental"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Buy",function(Data,Callback)
	vSERVER.Buy(Data["name"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rental",function(Data,Callback)
	vSERVER.Rental(Data["name"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Update")
AddEventHandler("tablet:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Drive",function(Data,Callback)
	if vSERVER.Start() then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "Close" })

		local Ped = PlayerPedId()
		TestCoords = GetEntityCoords(Ped)

		LocalPlayer["state"]:set("Race",true,true)
		LocalPlayer["state"]:set("Commands",true,true)
		TriggerEvent("Notify","Sucesso","Teste iniciado, para finalizar saia do veículo.","verde",5000)

		Wait(1000)

		VehicleCreate(Data["name"])

		Wait(1000)

		SetPedIntoVehicle(Ped,Vehicle,-1)
		Drive = true
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLECREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function VehicleCreate(Name)
	if LoadModel(Name) then
		if Open == "Santos" then
			Vehicle = CreateVehicle(Name,-53.28,-1110.93,26.47,68.04,false,false)
		elseif Open == "Sandy" then
			Vehicle = CreateVehicle(Name,1209.74,2713.49,37.81,175.75,false,false)
		end

		SetVehicleNumberPlateText(Vehicle,"PDMSPORT")
		SetEntityInvincible(Vehicle,true)
		SetModelAsNoLongerNeeded(Name)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Drive then
			TimeDistance = 1
			DisableControlAction(0,69,false)

			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				Wait(1000)

				Drive = false
				vSERVER.removeDrive()
				SetEntityCoords(Ped,TestCoords)
				LocalPlayer["state"]:set("Race",false,true)
				LocalPlayer["state"]:set("Commands",false,true)

				if DoesEntityExist(Vehicle) then
					DeleteEntity(Vehicle)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local initVehicles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicles = {
	{
		["Coords"] = vec3(-42.39,-1101.32,25.98),
		["heading"] = 19.85,
		["Model"] = "sultan",
		["Distance"] = 100
	},{
		["Coords"] = vec3(-54.61,-1096.86,25.98),
		["heading"] = 31.19,
		["Model"] = "sultan",
		["Distance"] = 100
	},{
		["Coords"] = vec3(-47.57,-1092.05,25.98),
		["heading"] = 283.47,
		["Model"] = "sultan",
		["Distance"] = 100
	},{
		["Coords"] = vec3(-37.02,-1093.42,25.98),
		["heading"] = 206.93,
		["Model"] = "sultan",
		["Distance"] = 100
	},{
		["Coords"] = vec3(-49.78,-1083.86,25.98),
		["heading"] = 65.2,
		["Model"] = "sultan",
		["Distance"] = 100
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for k,v in pairs(Vehicles) do
			if #(Coords - v["Coords"]) <= v["Distance"] then
				if not initVehicles[k] and LoadModel(v["Model"]) then
					initVehicles[k] = CreateVehicle(v["Model"],v["Coords"],v["heading"],false,false)
					SetVehicleNumberPlateText(initVehicles[k],"PDMSPORT")

					SetVehicleCustomPrimaryColour(initVehicles[k],255,255,255)
					SetVehicleCustomSecondaryColour(initVehicles[k],255,255,255)

					FreezeEntityPosition(initVehicles[k],true)
					SetVehicleDoorsLocked(initVehicles[k],2)
					SetModelAsNoLongerNeeded(v["Model"])
				end
			else
				if initVehicles[k] then
					if DoesEntityExist(initVehicles[k]) then
						DeleteEntity(initVehicles[k])
					end

					initVehicles[k] = nil
				end
			end
		end

		Wait(1000)
	end
end)