-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Race = 1
local Saved = 0
local Blips = {}
local Points = 0
local Progress = 0
local Checkpoint = 1
local Actived = false
local Ranking = false
local TyreExplodes = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,Info in pairs(Races) do
		local Blip = AddBlipForCoord(Info["Init"]["x"],Info["Init"]["y"],Info["Init"]["z"])
		SetBlipSprite(Blip,38)
		SetBlipDisplay(Blip,4)
		SetBlipAsShortRange(Blip,true)
		SetBlipColour(Blip,4)
		SetBlipScale(Blip,0.5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Circuito")
		EndTextCommandSetBlipName(Blip)
	end

	while true do
		local TimeDistance = 999
		if not LocalPlayer["state"]["Race"] then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			if Actived then
				Points = GetGameTimer() - Saved
				SendNUIMessage({ Action = "Progress", Points = Points, Timer = Progress - GetGameTimer() })

				if GetGameTimer() >= Progress or not IsPedInAnyVehicle(Ped) then
					Leave()
				end

				local Distance = #(Coords - Races[Race]["Coords"][Checkpoint])
				if Distance <= 200 then
					TimeDistance = 1

					if Checkpoint >= #Races[Race]["Coords"] then
						DrawMarker(22,Races[Race]["Coords"][Checkpoint]["x"],Races[Race]["Coords"][Checkpoint]["y"],Races[Race]["Coords"][Checkpoint]["z"] + 2.0,0.0,0.0,0.0,0.0,180.0,GetEntityHeading(Ped) - 90,7.5,7.5,5.0,65,130,226,100,0,0,0,0)
					else
						DrawMarker(22,Races[Race]["Coords"][Checkpoint]["x"],Races[Race]["Coords"][Checkpoint]["y"],Races[Race]["Coords"][Checkpoint]["z"] + 3.0,0.0,0.0,0.0,0.0,180.0,0.0,7.5,7.5,5.0,65,130,226,100,0,0,0,1)
					end

					DrawMarker(1,Races[Race]["Coords"][Checkpoint]["x"],Races[Race]["Coords"][Checkpoint]["y"],Races[Race]["Coords"][Checkpoint]["z"] - 3.0,0.0,0.0,0.0,0.0,0.0,0.0,15.0,15.0,10.0,255,255,255,50,0,0,0,0)

					if Distance <= 10 then
						if Checkpoint >= #Races[Race]["Coords"] then
							SendNUIMessage({ Action = "Display", Status = false })
							vSERVER.Finish(Race,Points)
							CleanBlips()

							Race = 1
							Saved = 0
							Points = 0
							Checkpoint = 1
							Actived = false
						else
							if DoesBlipExist(Blips[Checkpoint]) then
								RemoveBlip(Blips[Checkpoint])
								Blips[Checkpoint] = nil
							end

							SendNUIMessage({ Action = "Checkpoint" })
							SetBlipRoute(Blips[Checkpoint + 1],true)
							Checkpoint = Checkpoint + 1
						end
					end
				end
			else
				if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyBoat(Ped) and not IsPedInAnyPlane(Ped) then
					for Number,v in pairs(Races) do
						local Distance = #(Coords - v["Init"])
						if Distance <= 25 then
							local Vehicle = GetVehiclePedIsUsing(Ped)
							if GetPedInVehicleSeat(Vehicle,-1) == Ped then
								DrawMarker(5,v["Init"]["x"],v["Init"]["y"],v["Init"]["z"] - 0.4,0.0,0.0,5.0,0.0,0.0,0.0,10.0,10.0,10.0,65,130,226,100,0,0,0,0)
								TimeDistance = 1

								if Distance <= 5 then
									if IsControlJustPressed(0,47) then
										Ranking = not Ranking

										if Ranking then
											SendNUIMessage({ Action = "Ranking", Ranking = vSERVER.Ranking(Number) })
										else
											SendNUIMessage({ Action = "Ranking", Ranking = false })
										end
									end

									if IsControlJustPressed(1,38) then
										if vSERVER.Start(Number) then
											if Ranking then
												SendNUIMessage({ Action = "Ranking", Ranking = false })
												Ranking = false
											end

											SendNUIMessage({ Action = "Display", Status = true, Max = #Races[Number]["Coords"] })
											Progress = GetGameTimer() + (v["Timer"] * 1000)
											Saved = GetGameTimer()
											Checkpoint = 1
											Race = Number
											Points = 0

											MakeBlips()

											Actived = true
										end
									end
								else
									if Ranking then
										SendNUIMessage({ Action = "Ranking", Ranking = false })
										Ranking = false
									end
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeBlips()
	for Number = 1,#Races[Race]["Coords"] do
		Blips[Number] = AddBlipForCoord(Races[Race]["Coords"][Number]["x"],Races[Race]["Coords"][Number]["y"],Races[Race]["Coords"][Number]["z"])
		SetBlipSprite(Blips[Number],1)
		SetBlipColour(Blips[Number],77)
		SetBlipScale(Blips[Number],0.75)
		SetBlipRoute(Blips[Checkpoint],true)
		ShowNumberOnBlip(Blips[Number],Number)
		SetBlipAsShortRange(Blips[Number],true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanBlips()
	for Number,Bliped in pairs(Blips) do
		if DoesBlipExist(Bliped) then
			RemoveBlip(Bliped)
			Blips[Number] = nil
		end
	end

	Blips = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Leave()
	SendNUIMessage({ Action = "Display", Status = false })
	vSERVER.Cancel()
	Actived = false

	CleanBlips()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTYREEXPLODES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if not Actived then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TimeDistance = 1

				DisableControlAction(0,345,true)

				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetPedInVehicleSeat(Vehicle,-1) == Ped then
					local Speed = GetEntitySpeed(Vehicle) * 2.236936
					if Speed ~= TyreExplodes then
						if (TyreExplodes - Speed) >= 125 then
							local Tyre = math.random(4)
							if Tyre == 1 then
								if GetTyreHealth(Vehicle,0) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,0,true,1000.0)
								end
							elseif Tyre == 2 then
								if GetTyreHealth(Vehicle,1) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,1,true,1000.0)
								end
							elseif Tyre == 3 then
								if GetTyreHealth(Vehicle,4) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,4,true,1000.0)
								end
							elseif Tyre == 4 then
								if GetTyreHealth(Vehicle,5) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,5,true,1000.0)
								end
							end
						end

						TyreExplodes = Speed
					end
				end
			else
				if TyreExplodes ~= 0 then
					TyreExplodes = 0
				end
			end
		end

		Wait(TimeDistance)
	end
end)