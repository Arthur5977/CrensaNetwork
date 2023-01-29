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
Tunnel.bindInterface("postit",Creative)
vSERVER = Tunnel.getInterface("postit")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local displayText = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local rotation = GetGameplayCamRot()
	local adjustedRotation = vec3((math.pi / 180) * rotation["x"],(math.pi / 180) * rotation["y"],(math.pi / 180) * rotation["z"])
	local direction = vec3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])),math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])),math.sin(adjustedRotation[1]))

	return vec3(Coords[1] + direction[1] * Distance, Coords[2] + direction[2] * Distance, Coords[3] + direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT:INITPOSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("postit:initPostit")
AddEventHandler("postit:initPostit",function()
	CreateThread(function()
		while true do
			local Ped = PlayerPedId()
			local cam = GetGameplayCamCoord()
			local handle = StartExpensiveSynchronousShapeTestLosProbe(cam,GetCoordsFromCam(25.0,cam),-1,Ped,4)
			local _,_,Coords = GetShapeTestResult(handle)

			DrawMarker(28,Coords["x"],Coords["y"],Coords["z"],0.0,0.0,0.0,0.0,0.0,0.0,0.05,0.05,0.05,162,124,219,200,0,0,0,0)

			if IsControlJustPressed(1,38) then
				--TriggerServerEvent("admin:Coords",Coords)

				vSERVER.newPostIts(Coords)
				break
			end

			Wait(1)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPOSTITS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for k,v in pairs(GlobalState["Postit"]) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= v[5] then
				local _,x,y = GetScreenCoordFromWorldCoord(v[1],v[2],v[3])
				if not displayText[k] then
					SendNUIMessage({ Action = "Show", text = "", id = k, x = x, y = y })
					displayText[k] = true
				end

				TimeDistance = 1
				SendNUIMessage({ Action = "Update", text = v[4], id = k, x = x, y = y })

				if IsControlJustPressed(1,47) and Distance <= 2 then
					vSERVER.deletePostIts(k)
				end
			else
				if displayText[k] then
					SendNUIMessage({ Action = "Remove", id = k })
					displayText[k] = nil
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT:DELETEPOSTITS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("postit:deletePostIts")
AddEventHandler("postit:deletePostIts",function(id)
	if displayText[id] then
		SendNUIMessage({ Action = "Remove", id = id })
		displayText[id] = nil
	end
end)