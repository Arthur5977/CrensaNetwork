-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("player",Creative)
vSERVER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Meth = 0
local Drunk = 0
local Cocaine = 0
local Carry = false
local Energetic = 0
local UseFps = false
local Residuals = nil
local inTrunk = false
local inTrash = false
local Megaphone = false
local WashProgress = false
local ShotDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Commands")
AddEventHandler("player:Commands",function(Status)
	LocalPlayer["state"]:set("Commands",Status,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fps",function()
	if UseFps then
		ClearTimecycleModifier()
		UseFps = false
	else
		SetTimecycleModifier("cinema")
		UseFps = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Carry")
AddEventHandler("player:Carry",function(Entity,Mode)
	if Carry then
		DetachEntity(PlayerPedId(),false,false)
		Carry = false
	else
		if Mode == "handcuff" then
			AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(Entity)),11816,0.0,0.5,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		else
			AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(Entity)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		end

		Carry = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Rope")
AddEventHandler("player:Rope",function(Entity)
	if LocalPlayer["state"]["Rope"] then
		DetachEntity(PlayerPedId(),false,false)
		LocalPlayer["state"]:set("Rope",false,false)
	else
		LocalPlayer["state"]:set("Rope",true,false)
		AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(Entity)),0,0.20,0.12,0.63,0.5,0.5,0.0,false,false,false,false,2,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROPEANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Rope"] then
			TimeDistance = 1
			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"nm","firemans_carry",3) then
				vRP.playAnim(false,{"nm","firemans_carry"},true)
			end

			DisableControlAction(0,23,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			TimeDistance = 100

			if not GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,true)
			end

			local Vehicle = GetVehiclePedIsIn(Ped)
			if GetPedInVehicleSeat(Vehicle,0) == Ped then
				if GetIsTaskActive(Ped,165) then
					SetPedIntoVehicle(Ped,Vehicle,0)
				end
			end
		else
			if GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,false)
			end
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(Timer,Number)
	Energetic = Energetic + Timer
	SetRunSprintMultiplierForPlayer(PlayerId(),Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetEnergetic")
AddEventHandler("resetEnergetic",function()
	if Energetic > 0 then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		Energetic = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Energetic > 0 then
			Energetic = Energetic - 1
			RestorePlayerStamina(PlayerId(),1.0)

			if Energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
				Energetic = 0
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMETH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setMeth")
AddEventHandler("setMeth",function()
	Meth = Meth + 30

	if not GetScreenEffectIsActive("DMT_flight") then
		StartScreenEffect("DMT_flight",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMETH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Meth > 0 then
			Meth = Meth - 1

			if Meth <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Meth = 0

				if GetScreenEffectIsActive("DMT_flight") then
					StopScreenEffect("DMT_flight")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setCocaine")
AddEventHandler("setCocaine",function()
	Cocaine = Cocaine + 30

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Cocaine > 0 then
			Cocaine = Cocaine - 1

			if Cocaine <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Cocaine = 0

				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(Timer)
	Drunk = Drunk + Timer

	LocalPlayer["state"]:set("Drunk",true,false)

	if LoadMovement("move_m@drunk@verydrunk") then
		SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Drunk > 0 then
			Drunk = Drunk - 1

			if Drunk <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				LocalPlayer["state"]:set("Drunk",false,false)
				ResetPedMovementClipset(PlayerPedId(),0.25)
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetDrugs")
AddEventHandler("resetDrugs",function()
	if GetScreenEffectIsActive("MinigameTransitionIn") then
		StopScreenEffect("MinigameTransitionIn")
	end

	if GetScreenEffectIsActive("DMT_flight") then
		StopScreenEffect("DMT_flight")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOODOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncHoodOptions")
AddEventHandler("player:syncHoodOptions",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,4,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,4,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORSOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoorsOptions")
AddEventHandler("player:syncDoorsOptions",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,5,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,5,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINDOWS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("player:Windows",function()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		Entity(Vehicle)["state"]:set("Windows",not Entity(Vehicle)["state"]["Windows"],true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Windows",nil,function(Name,Key,Value)
	local Network = parseInt(Name:gsub("entity:",""))
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToVeh(Network)
		if DoesEntityExist(Vehicle) then
			if Value then
				RollDownWindow(Vehicle,0)
				RollDownWindow(Vehicle,1)
				RollDownWindow(Vehicle,2)
				RollDownWindow(Vehicle,3)
			else
				RollUpWindow(Vehicle,0)
				RollUpWindow(Vehicle,1)
				RollUpWindow(Vehicle,2)
				RollUpWindow(Vehicle,3)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORNUMBER
-----------------------------------------------------------------------------------------------------------------------------------------
local DoorNumber = {
	["1"] = 0,
	["2"] = 1,
	["3"] = 2,
	["4"] = 3,
	["5"] = 5,
	["6"] = 4
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoors")
AddEventHandler("player:syncDoors",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) and GetVehicleDoorLockStatus(Vehicle) == 1 then
			if DoorNumber[Active] then
				if GetVehicleDoorAngleRatio(Vehicle,DoorNumber[Active]) == 0 then
					SetVehicleDoorOpen(Vehicle,DoorNumber[Active],0,0)
				else
					SetVehicleDoorShut(Vehicle,DoorNumber[Active],0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:seatPlayer")
AddEventHandler("player:seatPlayer",function(Index)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)

		if Index == "0" then
			if IsVehicleSeatFree(Vehicle,-1) then
				SetPedIntoVehicle(Ped,Vehicle,-1)
			end
		elseif Index == "1" then
			if IsVehicleSeatFree(Vehicle,0) then
				SetPedIntoVehicle(Ped,Vehicle,0)
			end
		else
			for Seat = 1,10 do
				if IsVehicleSeatFree(Vehicle,Seat) then
					SetPedIntoVehicle(Ped,Vehicle,Seat)
					break
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 100
		local Ped = PlayerPedId()
		if LocalPlayer["state"]["Handcuff"] or LocalPlayer["state"]["Target"] then
			TimeDistance = 1
			DisableControlAction(0,18,true)
			DisableControlAction(0,21,true)
			DisableControlAction(0,55,true)
			DisableControlAction(0,102,true)
			DisableControlAction(0,179,true)
			DisableControlAction(0,203,true)
			DisableControlAction(0,76,true)
			DisableControlAction(0,23,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,311,true)
			DisablePlayerFiring(Ped,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if LocalPlayer["state"]["Handcuff"] and GetEntityHealth(Ped) > 100 and not LocalPlayer["state"]["Rope"] and not Carry then
			if not IsEntityPlayingAnim(Ped,"mp_arresting","idle",3) then
				if LoadAnim("mp_arresting") then
					TaskPlayAnim(Ped,"mp_arresting","idle",8.0,8.0,-1,49,0,0,0,0)
				end

				TimeDistance = 1
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOSSANTOS
-----------------------------------------------------------------------------------------------------------------------------------------
local LosSantos = PolyZone:Create({
	vec2(-2153.08,-3131.33),
	vec2(-1581.58,-2092.38),
	vec2(-3271.05,275.85),
	vec2(-3460.83,967.42),
	vec2(-3202.39,1555.39),
	vec2(-1642.50,993.32),
	vec2(312.95,1054.66),
	vec2(1313.70,341.94),
	vec2(1739.01,-1280.58),
	vec2(1427.42,-3440.38),
	vec2(-737.90,-3773.97)
},{ name = "santos" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANDYSHORES
-----------------------------------------------------------------------------------------------------------------------------------------
local SandyShores = PolyZone:Create({
	vec2(-375.38,2910.14),
	vec2(307.66,3664.47),
	vec2(2329.64,4128.52),
	vec2(2349.93,4578.50),
	vec2(1680.57,4462.48),
	vec2(1570.01,4961.27),
	vec2(1967.55,5203.67),
	vec2(2387.14,5273.98),
	vec2(2735.26,4392.21),
	vec2(2512.33,3711.16),
	vec2(1681.79,3387.82),
	vec2(258.85,2920.16)
},{ name = "sandy" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- PALETOBAY
-----------------------------------------------------------------------------------------------------------------------------------------
local PaletoBay = PolyZone:Create({
	vec2(-529.40,5755.14),
	vec2(-234.39,5978.46),
	vec2(278.16,6381.84),
	vec2(672.67,6434.39),
	vec2(699.56,6877.77),
	vec2(256.59,7058.49),
	vec2(17.64,7054.53),
	vec2(-489.45,6449.50),
	vec2(-717.59,6030.94)
},{ name = "paleto" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not LocalPlayer["state"]["Policia"] and IsPedArmed(Ped,6) and GetGameTimer() >= ShotDelay then
			TimeDistance = 1

			if IsPedShooting(Ped) then
				ShotDelay = GetGameTimer() + 60000
				TriggerEvent("player:Residuals","Resíduo de Pólvora.")

				local Vehicle = false
				local Coords = GetEntityCoords(Ped)
				if not IsPedCurrentWeaponSilenced(Ped) then
					if (LosSantos:isPointInside(Coords) or SandyShores:isPointInside(Coords) or PaletoBay:isPointInside(Coords)) then
						TriggerServerEvent("evidence:dropEvidence","blue")

						if IsPedInAnyVehicle(Ped) then
							Vehicle = true
						end

						vSERVER.shotsFired(Vehicle)
					end
				else
					if math.random(100) >= 80 then
						if (LosSantos:isPointInside(Coords) or SandyShores:isPointInside(Coords) or PaletoBay:isPointInside(Coords)) then
							TriggerServerEvent("evidence:dropEvidence","blue")

							if IsPedInAnyVehicle(Ped) then
								Vehicle = true
							end

							vSERVER.shotsFired(Vehicle)
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAKESHOTTING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and IsPedArmed(Ped,6) then
			TimeDistance = 1

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if IsPedShooting(Ped) and (GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16) then
				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.05)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSOAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkSoap()
	return Residuals
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RESIDUALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Residuals")
AddEventHandler("player:Residuals",function(Informations)
	if Informations then
		if not Residuals then
			Residuals = {}
		end

		Residuals[Informations] = true
	else
		Residuals = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:INBENNYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:inBennys")
AddEventHandler("player:inBennys",function(status)
	inBennys = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveVehicle()
	if not inBennys then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			TaskLeaveVehicle(Ped,GetVehiclePedIsUsing(Ped),0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PlaceVehicle(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			local vehSeats = 10
			local Ped = PlayerPedId()

			repeat
				vehSeats = vehSeats - 1

				if IsVehicleSeatFree(Vehicle,vehSeats) then
					ClearPedTasks(Ped)
					ClearPedSecondaryTask(Ped)
					SetPedIntoVehicle(Ped,Vehicle,vehSeats)

					vehSeats = true
				end
			until vehSeats == true or vehSeats == 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRUISER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cr",function(source,Message)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if GetPedInVehicleSeat(Vehicle,-1) == Ped and not IsEntityInAir(Vehicle) and (GetEntitySpeed(Vehicle) * 2.236936) >= 10 then
			if not Message[1] then
				SetEntityMaxSpeed(Vehicle,GetVehicleEstimatedMaxSpeed(Vehicle))
				TriggerEvent("Notify","Sucesso","Controle de cruzeiro desativado.","verde",5000)
			else
				if parseInt(Message[1]) > 10 then
					SetEntityMaxSpeed(Vehicle,0.45 * Message[1])
					TriggerEvent("Notify","Sucesso","Controle de cruzeiro ativado.","verde",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,Message)
	if name == "CEventNetworkEntityDamage" then
		if (GetEntityHealth(Message[1]) <= 100 and PlayerPedId() == Message[2] and IsPedAPlayer(Message[1])) then
			local Index = NetworkGetPlayerIndexFromPed(Message[1])
			local source = GetPlayerServerId(Index)
			TriggerServerEvent("player:Death",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrunk")
AddEventHandler("player:enterTrunk",function(Entity)
	if not inTrunk then
		LocalPlayer["state"]:set("Commands",true,true)
		LocalPlayer["state"]:set("Invisible",true,false)

		SetEntityVisible(PlayerPedId(),false,false)
		AttachEntityToEntity(PlayerPedId(),Entity[3],-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
		inTrunk = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	if inTrunk then
		local Ped = PlayerPedId()
		local Vehicle = GetEntityAttachedTo(Ped)
		if DoesEntityExist(Vehicle) then
			inTrunk = false
			DetachEntity(Ped,false,false)
			SetEntityVisible(Ped,true,false)
			LocalPlayer["state"]:set("Invisible",false,false)
			LocalPlayer["state"]:set("Commands",false,true)
			SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		if inTrunk then
			local Ped = PlayerPedId()
			local Vehicle = GetEntityAttachedTo(Ped)
			if DoesEntityExist(Vehicle) then
				TimeDistance = 1

				DisablePlayerFiring(Ped,true)

				if IsEntityVisible(Ped) then
					LocalPlayer["state"]:set("Invisible",true,false)
					SetEntityVisible(Ped,false,false)
				end

				if IsControlJustPressed(1,38) then
					inTrunk = false
					DetachEntity(Ped,false,false)
					SetEntityVisible(Ped,true,false)
					LocalPlayer["state"]:set("Invisible",false,false)
					LocalPlayer["state"]:set("Commands",false,true)
					SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
				end
			else
				inTrunk = false
				DetachEntity(Ped,false,false)
				SetEntityVisible(Ped,true,false)
				LocalPlayer["state"]:set("Invisible",false,false)
				LocalPlayer["state"]:set("Commands",false,true)
				SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ancorar",function()
	local Ped = PlayerPedId()
	if IsPedInAnyBoat(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if CanAnchorBoatHere(Vehicle) then
			TriggerEvent("Notify","Sucesso","Embarcação desancorada.","verde",5000)
			SetBoatAnchor(Vehicle,false)
		else
			TriggerEvent("Notify","Sucesso","Embarcação ancorada.","verde",5000)
			SetBoatAnchor(Vehicle,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COWCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Cows = {
	vec3(2440.58,4736.35,34.29),
	vec3(2432.5,4744.58,34.31),
	vec3(2424.47,4752.37,34.31),
	vec3(2416.28,4760.8,34.31),
	vec3(2408.6,4768.88,34.31),
	vec3(2400.32,4777.48,34.53),
	vec3(2432.46,4802.66,34.83),
	vec3(2440.62,4794.22,34.66),
	vec3(2448.65,4786.57,34.64),
	vec3(2456.88,4778.08,34.49),
	vec3(2464.53,4770.04,34.37),
	vec3(2473.38,4760.98,34.31),
	vec3(2495.03,4762.77,34.37),
	vec3(2503.13,4754.08,34.31),
	vec3(2511.34,4746.04,34.31),
	vec3(2519.56,4737.35,34.20)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Cows) do
		exports["target"]:AddCircleZone("Cows:"..Index,v,0.5,{
			name = "Cows:"..Index,
			heading = 3374176
		},{
			Distance = 1.25,
			options = {
				{
					event = "inventory:MakeProducts",
					label = "Retirar Leite",
					tunnel = "products",
					service = "milkBottle"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrash")
AddEventHandler("player:enterTrash",function(Entity)
	if not inTrash then
		local Ped = PlayerPedId()
		FreezeEntityPosition(Ped,true)

		LocalPlayer["state"]:set("Commands",true,true)
		LocalPlayer["state"]:set("Invisible",true,false)
		SetEntityVisible(Ped,false,false)
		SetEntityCoords(Ped,Entity[4],false,false,false,false)

		inTrash = GetOffsetFromEntityInWorldCoords(Entity[1],0.0,-1.5,0.0)

		while inTrash do
			Wait(1)

			if IsControlJustPressed(1,38) then
				FreezeEntityPosition(Ped,false)
				SetEntityVisible(Ped,true,false)
				LocalPlayer["state"]:set("Invisible",false,false)
				LocalPlayer["state"]:set("Commands",false,true)
				SetEntityCoords(Ped,inTrash,false,false,false,false)

				inTrash = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	if inTrash then
		local Ped = PlayerPedId()
		FreezeEntityPosition(Ped,false)
		SetEntityVisible(Ped,true,false)
		LocalPlayer["state"]:set("Invisible",false,false)
		LocalPlayer["state"]:set("Commands",false,true)
		SetEntityCoords(Ped,inTrash,false,false,false,false)

		inTrash = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Megaphone")
AddEventHandler("player:Megaphone",function()
	Megaphone = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Megaphone then
			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"anim@random@shop_clothes@watches","base",3) then
				TriggerServerEvent("pma-voice:Megaphone",false)
				TriggerEvent("pma-voice:Megaphone",false)
				Megaphone = false
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUIVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local DuiTextures = {}
local InnerTexture = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUITABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:DuiTable")
AddEventHandler("player:DuiTable",function(Table)
	DuiTextures = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Line,v in pairs(DuiTextures) do
				if #(Coords - v["Coords"]) <= 15 then
					if not InnerTexture[Line] then
						InnerTexture[Line] = true

						local Texture = CreateRuntimeTxd("Texture"..Line)
						local TextureObject = CreateDui(v["Link"],v["Width"],v["Weight"])
						local TextureHandle = GetDuiHandle(TextureObject)

						CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Line,TextureHandle)
						AddReplaceTexture(v["Dict"],v["Texture"],"Texture"..Line,"Back"..Line)

						exports["target"]:AddCircleZone("Texture"..Line,v["Coords"],v["Dimension"],{
							name = "Texture"..Line,
							heading = 3374176
						},{
							shop = Line,
							Distance = v["Distance"],
							options = {
								{
									event = "player:Texture",
									label = v["Label"],
									tunnel = "server"
								}
							}
						})
					end
				else
					if InnerTexture[Line] then
						exports["target"]:RemCircleZone("Texture"..Line)
						RemoveReplaceTexture(v["Dict"],v["Texture"])
						InnerTexture[Line] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUIUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:DuiUpdate")
AddEventHandler("player:DuiUpdate",function(Name,Table)
	DuiTextures[Name] = Table

	local Ped = PlayerPedId()
	local Fast = DuiTextures[Name]
	local Coords = GetEntityCoords(Ped)
	if #(Coords - Fast["Coords"]) <= 15 then
		local Texture = CreateRuntimeTxd("Texture"..Name)
		local TextureObject = CreateDui(Fast["Link"],Fast["Width"],Fast["Weight"])
		local TextureHandle = GetDuiHandle(TextureObject)

		CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Name,TextureHandle)
		AddReplaceTexture(Fast["Dict"],Fast["Texture"],"Texture"..Name,"Back"..Name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RELATIONSHIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Relationship")
AddEventHandler("player:Relationship",function(Group)
	if Group == "Ballas" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_BALLAS"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_BALLAS"))
	elseif Group == "Families" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_FAMILY"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_FAMILY"))
	elseif Group == "Vagos" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MEXICAN"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_MEXICAN"))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
local Wash = {
	vec3(24.27,-1391.96,28.7),
	vec3(170.59,-1718.43,28.66),
	vec3(167.69,-1715.92,28.66),
	vec3(-699.86,-932.84,18.38)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Table = {}

	for _,v in pairs(Wash) do
		table.insert(Table,{ v["x"],v["y"],v["z"],2.5,"E","Car Wash","Pressione para lavar" })
	end

	TriggerEvent("hoverfy:Insert",Table)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not WashProgress then
			local Coords = GetEntityCoords(Ped)
			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				for _,v in pairs(Wash) do
					if #(Coords - v) <= 2.5 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) and vSERVER.Pay() then
							WashProgress = true

							FreezeEntityPosition(Vehicle,true)

							UseParticleFxAssetNextCall("core")
							local Particle01 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v["x"],v["y"],v["z"],0.0,0.0,0.0,1.0,false,false,false,false)

							UseParticleFxAssetNextCall("core")
							local Particle02 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v["x"] + 2.5,v["y"],v["z"],0.0,0.0,0.0,1.0,false,false,false,false)

							TriggerEvent("Progress","Lavando",15000)
							SetTimeout(15000,function()
								TriggerServerEvent("CleanVehicle",VehToNet(Vehicle))

								FreezeEntityPosition(Vehicle,false)
								StopParticleFxLooped(Particle01,0)
								StopParticleFxLooped(Particle02,0)
								WashProgress = false
							end)
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)