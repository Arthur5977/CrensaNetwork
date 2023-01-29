-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Objects = {}
local Active = false
local Cooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Active and Components[Active] then
			local Ped = PlayerPedId()
			local Armour = GetPedArmour(Ped)
			local Crashed = Components[Active]
			local Coords = GetEntityCoords(Ped)
			local Healths = GetEntityHealth(Ped)
			local Distance = #(Coords - Crashed["1"][1])

			if Distance <= 250 then
				TimeDistance = 1
				DrawMarker(1,Crashed["1"][1]["x"],Crashed["1"][1]["y"],Crashed["1"][1]["z"] - 100.0,0.0,0.0,0.0,0.0,0.0,0.0,300.0,300.0,200.0,255,0,0,255,0,0,0,0)

				if Distance <= 152.5 then
					if IsPedInAnyVehicle(Ped) then
						TriggerEvent("garages:Delete")
					end

					if Healths > 100 and GetGameTimer() > Cooldown then
						Cooldown = GetGameTimer() + 5000
						SetEntityHealth(Ped,Healths + 2)
						SetPedArmour(Ped,Armour + 2)
					end
				end

				for Number,v in pairs(Crashed) do
					if not Objects[Number] and LoadModel(v[3]) then
						Objects[Number] = CreateObjectNoOffset(v[3],v[1],false,false,false)
						PlaceObjectOnGroundProperly(Objects[Number])
						FreezeEntityPosition(Objects[Number],true)
						SetEntityLodDist(Objects[Number],0xFFFF)
						SetEntityHeading(Objects[Number],v[2])

						if Healths > 100 then
							if Number ~= "1" then
								exports["target"]:AddBoxZone("Helicrash:"..Number,v[1],1.25,2.0,{
									name = "Helicrash:"..Number,
									heading = v[2],
									minZ = v[1]["z"] - 1.00,
									maxZ = v[1]["z"] + 0.25
								},{
									shop = "Helicrash:"..Number,
									Distance = 1.75,
									options = {
										{
											event = "chest:Open",
											label = "Abrir",
											tunnel = "shop",
											service = "Custom"
										}
									}
								})
							end
						end
					end
				end
			else
				if Objects["1"] then
					for Number,v in pairs(Objects) do
						DeleteEntity(Objects[Number])
						Objects[Number] = nil
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Helicrash",nil,function(Name,Key,Value)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	Active = Value

	if not Value then
		if Objects["1"] then
			for Number,_ in pairs(Objects) do
				if Number ~= "1" then
					exports["target"]:RemCircleZone("Helicrash:"..Number)

					if DoesEntityExist(Objects[Number]) then
						DeleteEntity(Objects[Number])
					end

					Objects[Number] = nil
				end
			end
		end
	else
		HeliBlip(Active)

		if Objects["1"] then
			for Number,v in pairs(Objects) do
				exports["target"]:RemCircleZone("Helicrash:"..Number)

				if DoesEntityExist(Objects[Number]) then
					DeleteEntity(Objects[Number])
				end

				Objects[Number] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("onClientResourceStart")
AddEventHandler("onClientResourceStart",function(Resource)
    if (GetCurrentResourceName() ~= Resource) then
        return
    end

    if GlobalState["Helicrash"] then
        Active = GlobalState["Helicrash"]
        HeliBlip(Active)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELIBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function HeliBlip(Number)
	if Components[Number] then
		Blip = AddBlipForCoord(Components[Number]["1"][1],Components[Number]["1"][2],Components[Number]["1"][3])
		SetBlipSprite(Blip,43)
		SetBlipDisplay(Blip,4)
		SetBlipAsShortRange(Blip,true)
		SetBlipColour(Blip,5)
		SetBlipScale(Blip,0.8)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Helicrash")
		EndTextCommandSetBlipName(Blip)

		SetTimeout(600000,function()
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
			end
		end)
	end
end