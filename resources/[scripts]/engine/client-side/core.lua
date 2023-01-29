-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("engine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local fuelVeh = {}
local fuelLast = 0
local fuelPrice = 0
local fuelNui = false
local fuelSupply = false
local fuelEnter = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event == "CEventNetworkPlayerEnteredVehicle" then
		if Message[1] == PlayerId() and GetGameTimer() >= fuelEnter then
			fuelEnter = GetGameTimer() + 5000

			local Plate = GetVehicleNumberPlateText(Message[2])
			fuelVeh[Plate] = vSERVER.vehicleFuel(Plate)
			SetVehicleFuelLevel(Message[2],fuelVeh[Plate] + 0.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLASS
-----------------------------------------------------------------------------------------------------------------------------------------
local Class = {
	[0] = 1.0,
	[1] = 1.0,
	[2] = 1.0,
	[3] = 1.0,
	[4] = 1.0,
	[5] = 1.0,
	[6] = 1.0,
	[7] = 1.0,
	[8] = 1.0,
	[9] = 1.0,
	[10] = 1.0,
	[11] = 1.0,
	[12] = 1.0,
	[13] = 0.0,
	[14] = 0.0,
	[15] = 1.5,
	[16] = 1.0,
	[17] = 1.0,
	[18] = 1.0,
	[19] = 1.0,
	[20] = 1.0,
	[21] = 0.0,
	[22] = 1.0
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
local Consume = {
	[1.0] = 0.50,
	[0.9] = 0.45,
	[0.8] = 0.40,
	[0.7] = 0.35,
	[0.6] = 0.30,
	[0.5] = 0.25,
	[0.4] = 0.20,
	[0.3] = 0.15,
	[0.2] = 0.10,
	[0.1] = 0.05,
	[0.0] = 0.00
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLOOR
-----------------------------------------------------------------------------------------------------------------------------------------
function floor(Number)
	local Mult = 10 ^ 1
	return math.floor(Number * Mult + 0.5) / Mult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] <= 0 then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetVehicleFuelLevel(Vehicle) >= 1 then
					if (GetEntitySpeed(Vehicle) * 2.236936) >= 1 then
						local Plate = GetVehicleNumberPlateText(Vehicle)

						if fuelVeh[Plate] ~= nil then
							fuelVeh[Plate] = (fuelVeh[Plate] - (Consume[floor(GetVehicleCurrentRpm(Vehicle))] or 1.0) * (Class[GetVehicleClass(Vehicle)] or 1.0) / 10)
							SetVehicleFuelLevel(Vehicle,fuelVeh[Plate] + 0.0)
						end

						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							TriggerServerEvent("engine:tryFuel",Plate,fuelVeh[Plate])
						end
					end
				else
					SetVehicleEngineOn(Vehicle,false,true,true)
					TimeDistance = 1
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SUPPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:Supply")
AddEventHandler("engine:Supply",function(Entity)
	local Vehicle = Entity[3]
	fuelLast = GetVehicleFuelLevel(Vehicle)

	if fuelLast < 99.0 then
		local Gallon = Entity[5]
		if not fuelNui and not Gallon then
			SendNUIMessage({ Action = "Show" })
			fuelNui = true
		end

		fuelSupply = true
		local Plate = Entity[1]
		local Network = Entity[4]
		local Ped = PlayerPedId()
		TaskTurnPedToFaceEntity(Ped,Vehicle,5000)

		while fuelSupply do
			DisableControlAction(0,18,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,23,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,30,true)
			DisableControlAction(0,31,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)

			local vCoords = GetEntityCoords(Vehicle)
			local vFuel = GetVehicleFuelLevel(Vehicle)

			if not Gallon then
				fuelPrice = fuelPrice + 0.105
				SetVehicleFuelLevel(Vehicle,vFuel + 0.025)
				SendNUIMessage({ Action = "Tank", tank = floor(vFuel), price = fuelPrice, lts = 0.105 * 4 })
			else
				if GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100 > 1 then
					SetPedAmmo(Ped,883325847,math.floor(GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100))
					SetVehicleFuelLevel(Vehicle,vFuel + 0.025)
				end
			end

			DrawText3D(vCoords,"~g~E~w~   FINALIZAR")

			if not IsEntityPlayingAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) and LoadAnim("timetable@gardener@filling_can") then
				TaskPlayAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",8.0,8.0,-1,50,0,0,0,0)
			end

			if vFuel >= 100.0 or GetEntityHealth(Ped) <= 100 or (Gallon and GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100 <= 1) or IsControlJustPressed(1,38) then
				finishFuel(Gallon,Plate,vFuel,Network)
			end

			Wait(1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function finishFuel(Gallon,Plate,vFuel,Network)
	if not Gallon then
		if vSERVER.paymentFuel(fuelPrice,Plate,vFuel,fuelLast,Network) then
			TriggerServerEvent("engine:tryFuel",Plate,vFuel)
			fuelVeh[Plate] = vFuel
		else
			TriggerServerEvent("engine:tryFuel",Plate,fuelLast)
			fuelVeh[Plate] = fuelLast
		end

		SendNUIMessage({ Action = "Hide" })
	else
		TriggerServerEvent("engine:tryFuel",Plate,vFuel)
	end

	vRP.Destroy()
	fuelSupply = false
	fuelNui = false
	fuelPrice = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SYNCFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:syncFuel")
AddEventHandler("engine:syncFuel",function(Plate,Result,Network)
	fuelVeh[Plate] = Result

	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleFuelLevel(Vehicle,fuelVeh[Plate] + 0.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(Coords,Text)
	local onScreen,x,y = World3dToScreen2d(Coords["x"],Coords["y"],Coords["z"] + 1)

	if onScreen then
		SetTextFont(4)
		SetTextCentre(true)
		SetTextProportional(1)
		SetTextScale(0.35,0.35)
		SetTextColour(255,255,255,150)

		SetTextEntry("STRING")
		AddTextComponentString(Text)
		EndTextCommandDisplayText(x,y)

		local Width = (string.len(Text) + 4) / 170 * 0.45
		DrawRect(x,y + 0.0125,Width,0.03,15,15,15,175)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSTALL
-----------------------------------------------------------------------------------------------------------------------------------------
local Install = {
	[0] = "A",
	[1] = "B",
	[2] = "C",
	[3] = "D",
	[4] = "E"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:VEHRIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:Vehrify")
AddEventHandler("engine:Vehrify",function(Entity)
	local Vehicle = Entity[3]

	local Engine = GetVehicleMod(Vehicle,11)
	if Engine ~= -1 then
		exports["dynamic"]:AddButton("Motor","Modelo instalado: <yellow>"..Install[Engine].."</yellow>","","",false,false)
	end

	local Brake = GetVehicleMod(Vehicle,12)
	if Brake ~= -1 then
		exports["dynamic"]:AddButton("Freio","Modelo instalado: <yellow>"..Install[Brake].."</yellow>","","",false,false)
	end

	local Transmission = GetVehicleMod(Vehicle,13)
	if Transmission ~= -1 then
		exports["dynamic"]:AddButton("Transmissão","Modelo instalado: <yellow>"..Install[Transmission].."</yellow>","","",false,false)
	end

	local Suspension = GetVehicleMod(Vehicle,15)
	if Suspension ~= -1 then
		exports["dynamic"]:AddButton("Suspensão","Modelo instalado: <yellow>"..Install[Suspension].."</yellow>","","",false,false)
	end

	local Shielding = GetVehicleMod(Vehicle,16)
	if Shielding ~= -1 then
		exports["dynamic"]:AddButton("Blindagem","Modelo instalado: <yellow>"..Install[Shielding].."</yellow>","","",false,false)
	end

	local Force = GetVehicleEngineHealth(Vehicle) / 10
	exports["dynamic"]:AddButton("Potência","Potência do motor se encontra em <yellow>"..parseInt(Force).."%</yellow>.","","",false,false)

	local Body = GetVehicleBodyHealth(Vehicle) / 10
	exports["dynamic"]:AddButton("Lataria","Qualidade da lataria se encontra em <yellow>"..parseInt(Body).."%</yellow>.","","",false,false)

	local Health = GetEntityHealth(Vehicle) / 10
	exports["dynamic"]:AddButton("Chassi","Rigidez do chassi se encontra em <yellow>"..parseInt(Health).."%</yellow>.","","",false,false)

	exports["dynamic"]:openMenu()
end)