-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("evidence",Creative)
vSERVER = Tunnel.getInterface("evidence")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Evidences = {}
local LastUpdate = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v["x"] << 8) | v["y"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) and GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_FLASHLIGHT") and IsPlayerFreeAiming(PlayerId()) then
				local Coords = GetEntityCoords(Ped)
				local Grid = getGridzone(Coords["x"],Coords["y"])

				if GetGameTimer() > LastUpdate then
					if MumbleIsConnected() then
						Evidences = vSERVER.GetEvidences(Grid)
					end

					LastUpdate = GetGameTimer() + 10000
				end

				for Number,v in pairs(Evidences) do
					local Distance = #(Coords - vec3(v[1]["x"],v[1]["y"],v[1]["z"]))
					if Distance <= 5 then
						TimeDistance = 1
						DrawMarker(28,v[1]["x"],v[1]["y"],v[1]["z"] + 0.05,0.0,0.0,0.0,180.0,0.0,0.0,0.045,0.045,0.045,v[3][1],v[3][2],v[3][3],200,0,0,0,0)

						if Distance <= 1.2 and IsControlJustPressed(1,38) then
							TriggerServerEvent("evidence:pickupEvidence",Number,Grid)
							Evidences[Number] = nil
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSITIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetPostions()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local gridZone = getGridzone(Coords["x"],Coords["y"])
	local _,cdz = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

	return vec3(Coords["x"],Coords["y"],cdz),gridZone
end