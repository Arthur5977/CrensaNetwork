-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
tvRP = {}
Proxy.addInterface("vRP",tvRP)
Tunnel.bindInterface("vRP",tvRP)
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local animFlags = 0
local animDict = nil
local animName = nil
local blipsPlayers = {}
local BlipAdmin = false
local animActived = false
local showPassports = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.BlipAdmin()
	BlipAdmin = not BlipAdmin

	while BlipAdmin do
		blipsPlayers = vRPS.userPlayers()
		Wait(10000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if BlipAdmin then
			TimeDistance = 1

			local Ped = PlayerPedId()
			local userList = GetPlayers()
			local Coords = GetEntityCoords(Ped)

			for k,v in pairs(userList) do
				local uPlayer = GetPlayerFromServerId(k)
				if uPlayer ~= PlayerId() and NetworkIsPlayerConnected(uPlayer) then
					local uPed = GetPlayerPed(uPlayer)
					local uCoords = GetEntityCoords(uPed)
					local Distance = #(Coords - uCoords)
					if Distance <= 1000 and blipsPlayers[k] ~= nil then
						DrawText3D(uCoords,"~o~ID:~w~ "..blipsPlayers[k].."     ~g~H:~w~ "..GetEntityHealth(uPed).."     ~y~A:~w~ "..GetPedArmour(uPed),0.275)
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESTPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.ClosestPeds(Radius)
	local List = {}
	local Ped = PlayerPedId()
	local Players = GetPlayers()
	local Coords = GetEntityCoords(Ped)

	for Source,v in pairs(Players) do
		local uPlayer = GetPlayerFromServerId(Source)
		if uPlayer ~= PlayerId() and NetworkIsPlayerConnected(uPlayer) then
			local uPed = GetPlayerPed(uPlayer)
			local uCoords = GetEntityCoords(uPed)
			local Distance = #(Coords - uCoords)
			if Distance <= Radius then
				List[uPlayer] = { Distance,Source }
			end
		end
	end

	return List
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Players()
	local Players = {}
	for _,v in ipairs(GetActivePlayers()) do
		Players[#Players + 1] = GetPlayerServerId(v)
	end

	return Players
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESTPED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.ClosestPed(Radius)
	local Selected = false
	local Min = Radius + 0.0001
	local List = tvRP.ClosestPeds(Radius)

	for _,v in pairs(List) do
		if v[1] <= Min then
			Selected = v[2]
			Min = v[1]
		end
	end

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
	local Players = {}

	for _,v in ipairs(GetActivePlayers()) do
		Players[GetPlayerServerId(v)] = true
	end

	return Players
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playAnim(animUpper,animSequency,animLoop)
	local playFlags = 0
	local ped = PlayerPedId()
	if animSequency["task"] then
		tvRP.stopAnim(true)

		if animSequency["task"] == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
			local coords = GetEntityCoords(ped)
			TaskStartScenarioAtPosition(ped,animSequency["task"],coords["x"],coords["y"],coords["z"] - 1,GetEntityHeading(ped),0,0,false)
		else
			TaskStartScenarioInPlace(ped,animSequency["task"],0,false)
		end
	else
		tvRP.stopAnim(animUpper)

		if animUpper then
			playFlags = playFlags + 48
		end

		if animLoop then
			playFlags = playFlags + 1
		end

		CreateThread(function()
			RequestAnimDict(animSequency[1])
			while not HasAnimDictLoaded(animSequency[1]) do
				Wait(1)
			end

			if HasAnimDictLoaded(animSequency[1]) then
				animDict = animSequency[1]
				animName = animSequency[2]
				animFlags = playFlags

				if playFlags == 49 then
					animActived = true
				end

				TaskPlayAnim(ped,animSequency[1],animSequency[2],8.0,8.0,-1,playFlags,0,0,0,0)
			end
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if animActived then
			if not IsEntityPlayingAnim(Ped,animDict,animName,3) then
				TaskPlayAnim(Ped,animDict,animName,8.0,8.0,-1,animFlags,0,0,0,0)
				TimeDistance = 1
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if animActived then
			TimeDistance = 1
			DisableControlAction(0,18,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.stopAnim(animUpper)
	animActived = false
	local Ped = PlayerPedId()

	if animUpper then
		ClearPedSecondaryTask(Ped)
	else
		ClearPedTasks(Ped)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.stopActived()
	animActived = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.PlaySound(dict,name)
	PlaySoundFrontend(-1,dict,name,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTENALBLE
-----------------------------------------------------------------------------------------------------------------------------------------
function passportEnable()
	if UsableF7 then
		if showPassports or not MumbleIsConnected() then return end

		showPassports = true
		local playerList = vRPS.userPlayers()

		while showPassports do
			local Ped = PlayerPedId()
			local userList = GetPlayers()
			local Coords = GetEntityCoords(Ped)

			for k,v in pairs(userList) do
				local uPlayer = GetPlayerFromServerId(k)
				if NetworkIsPlayerConnected(uPlayer) then
					local uPed = GetPlayerPed(uPlayer)
					local uCoords = GetEntityCoords(uPed)
					local Distance = #(Coords - uCoords)
					if Distance <= 5 then
						DrawText3D(uCoords,"~w~"..playerList[k],0.45)
					end
				end
			end

			Wait(0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function passportDisable()
	showPassports = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+showPassports",passportEnable)
RegisterCommand("-showPassports",passportDisable)
RegisterKeyMapping("+showPassports","Visualizar passaportes.","keyboard","F7")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(Coords,Text,Weight)
	local onScreen,x,y = World3dToScreen2d(Coords["x"],Coords["y"],Coords["z"] + 1.10)

	if onScreen then
		SetTextFont(4)
		SetTextCentre(true)
		SetTextProportional(1)
		SetTextScale(0.35,0.35)
		SetTextColour(255,255,255,150)

		SetTextEntry("STRING")
		AddTextComponentString(Text)
		EndTextCommandDisplayText(x,y)

		local Width = string.len(Text) / 160 * Weight
		DrawRect(x,y + 0.0125,Width,0.03,15,15,15,175)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onClientResourceStop",function(Resource)
	if Resource == "vrp" then
		CancelEvent()
	end
end)