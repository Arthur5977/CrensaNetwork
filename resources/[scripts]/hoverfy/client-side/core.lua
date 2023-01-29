-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zone = {}
local Select = {}
local Active = false
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
-- DEADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			if not Active then
				local gridZone = getGridzone(Coords["x"],Coords["y"])

				if Zone[gridZone] then
					for _,Table in pairs(Zone[gridZone]) do
						if #(Coords - Table["Coords"]) < Table["Distance"] then
							SendNUIMessage({ Action = "Show", key = Table["key"], title = Table["title"], legend = Table["legend"] })
							Select = Table
							Active = true
						end
					end
				end
			else
				if #(Coords - Select["Coords"]) > Select["Distance"] then
					SendNUIMessage({ Action = "Hide" })
					TimeDistance = 100
					Active = false
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY:INSERT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hoverfy:Insert")
AddEventHandler("hoverfy:Insert",function(Tables)
	for Number = 1,#Tables do
		local Grid = getGridzone(Tables[Number][1],Tables[Number][2])

		if not Zone[Grid] then
			Zone[Grid] = {}
		end

		Zone[Grid][#Zone[Grid] + 1] = {
			["Coords"] = vec3(Tables[Number][1],Tables[Number][2],Tables[Number][3]),
			["Distance"] = Tables[Number][4],
			["key"] = Tables[Number][5],
			["title"] = Tables[Number][6],
			["legend"] = Tables[Number][7]
		}
	end
end)