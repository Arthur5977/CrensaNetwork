-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("plants",Creative)
vSERVER = Tunnel.getInterface("plants")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Plants = {}
local Objects = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for k,v in pairs(Plants) do
			local Distance = #(Coords - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]))
			if Distance <= 50 then
				if not Objects[k] and v["Route"] == LocalPlayer["state"]["Route"] then
					exports["target"]:AddBoxZone("Plants:"..k,vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]),0.4,0.4,{
						name = "Plants:"..k,
						heading = 3374176,
						minZ = v["Coords"][3] + 0.50,
						maxZ = v["Coords"][3] + 1.50
					},{
						shop = k,
						Distance = 1.5,
						options = {
							{
								event = "plants:Informations",
								label = "Verificar",
								tunnel = "shop"
							}
						}
					})

					createModels(k,v["Coords"])
				end
			else
				if Objects[k] then
					if DoesEntityExist(Objects[k]) then
						exports["target"]:RemCircleZone("Plants:"..k)
						DeleteEntity(Objects[k])
						Objects[k] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("plants:Informations")
AddEventHandler("plants:Informations",function(Number)
	local Informations = vSERVER.Informations(Number)
	if Informations then
		exports["dynamic"]:AddButton("Coletar",Informations[1],"plants:Collect",Number,false,true)
		exports["dynamic"]:AddButton("Clonagem",Informations[2],"plants:Cloning",Number,false,true)

		exports["dynamic"]:openMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
function createModels(Number,Coords)
	if LoadModel("bkr_prop_weed_med_01a") then
		Objects[Number] = CreateObjectNoOffset("bkr_prop_weed_med_01a",Coords[1],Coords[2],Coords[3],false,false,false)
		SetModelAsNoLongerNeeded("bkr_prop_weed_med_01a")
		PlaceObjectOnGroundProperly(Objects[Number])
		FreezeEntityPosition(Objects[Number],true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("plants:Table")
AddEventHandler("plants:Table",function(table)
	Plants = table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:NEW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("plants:New")
AddEventHandler("plants:New",function(Number,Table)
	Plants[Number] = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("plants:Remover")
AddEventHandler("plants:Remover",function(Number)
	Plants[Number] = nil

	if DoesEntityExist(Objects[Number]) then
		exports["target"]:RemCircleZone("Plants:"..Number)
		DeleteEntity(Objects[Number])
		Objects[Number] = nil
	end
end)