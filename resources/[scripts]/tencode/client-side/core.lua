-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tencode")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
local policeRadar = false
local policeFreeze = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(Data,Callback)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ tencode = false })

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendCode",function(Data,Callback)
	if MumbleIsConnected() then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		vSERVER.sendCode(Data["code"])
		SendNUIMessage({ tencode = false })
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyPoliceVehicle(Ped) and LocalPlayer["state"]["Police"] then
			if policeRadar then
				if not policeFreeze then
					TimeDistance = 100

					local vehicle = GetVehiclePedIsUsing(Ped)
					local vehicleDimension = GetOffsetFromEntityInWorldCoords(vehicle,0.0,1.0,1.0)

					local vehicleFront = GetOffsetFromEntityInWorldCoords(vehicle,0.0,105.0,0.0)
					local vehicleFrontShape = StartShapeTestCapsule(vehicleDimension,vehicleFront,3.0,10,vehicle,7)
					local _,_,_,_,vehFront = GetShapeTestResult(vehicleFrontShape)

					if IsEntityAVehicle(vehFront) then
						local vehHash = vRP.VehicleModel(vehFront)
						local vehSpeed = GetEntitySpeed(vehFront) * 3.6
						local Plate = GetVehicleNumberPlateText(vehFront)

						SendNUIMessage({ radar = "top", plate = Plate, Model = VehicleName(vehHash), speed = vehSpeed })
					end

					local vehicleBack = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-105.0,0.0)
					local vehicleBackShape = StartShapeTestCapsule(vehicleDimension,vehicleBack,3.0,10,vehicle,7)
					local _,_,_,_,vehBack = GetShapeTestResult(vehicleBackShape)

					if IsEntityAVehicle(vehBack) then
						local vehHash = vRP.VehicleModel(vehBack)
						local vehSpeed = GetEntitySpeed(vehBack) * 3.6
						local Plate = GetVehicleNumberPlateText(vehBack)

						SendNUIMessage({ radar = "bot", plate = Plate, Model = VehicleName(vehHash), speed = vehSpeed })
					end
				end
			end
		end

		if not IsPedInAnyVehicle(Ped) and policeRadar then
			policeRadar = false
			SendNUIMessage({ radar = false })
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLERADAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("toggleRadar",function()
	if MumbleIsConnected() and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		if IsPedInAnyPoliceVehicle(Ped) and LocalPlayer["state"]["Police"] then
			if policeRadar then
				policeRadar = false
				SendNUIMessage({ radar = false })
			else
				policeRadar = true
				SendNUIMessage({ radar = true })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEFREEZE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("toggleFreeze",function()
	local Ped = PlayerPedId()
	if IsPedInAnyPoliceVehicle(Ped) and LocalPlayer["state"]["Police"] and not IsPauseMenuActive() then
		policeFreeze = not policeFreeze
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enterTencodes",function()
	if LocalPlayer["state"]["Police"] and MumbleIsConnected() and LocalPlayer["state"]["Route"] < 900000 and not IsPauseMenuActive() then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.1)
		SendNUIMessage({ tencode = true })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("enterTencodes","Manusear o código policial.","keyboard","F3")
RegisterKeyMapping("toggleRadar","Ativar/Desativar radar das viaturas.","keyboard","N")
RegisterKeyMapping("toggleFreeze","Travar/Destravar radar das viaturas.","keyboard","M")