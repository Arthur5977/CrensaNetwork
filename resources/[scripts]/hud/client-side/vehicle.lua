-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Fuel = 0
local Speed = 0
local Nitro = 0
local Tyres = 0
local Locked = false
local Handbrake = false
local Headbeams = false
local Headlights = false
local ActualVehicle = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
local NitroFuel = 0
local NitroFlame = false
local NitroButton = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGHTTRAILS
-----------------------------------------------------------------------------------------------------------------------------------------
local LightTrails = {}
local LightParticles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
local PurgeSprays = {}
local PurgeParticles = {}
local PurgeActive = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local SeatbeltSpeed = 0
local SeatbeltLock = false
local SeatbeltVelocity = vec3(0,0,0)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	LoadPtfxAsset("veh_xs_vehicle_mods")

	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Active"] and Display then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				TimeDistance = 100

				if not IsMinimapRendering() then
					SetBigmapActive(false,false)
					DisplayRadar(true)
				end

				local Vehicle = GetVehiclePedIsUsing(Ped)
				local Rpm = GetVehicleCurrentRpm(Vehicle)
				local VFuel = GetVehicleFuelLevel(Vehicle)
				local Gear = GetVehicleCurrentGear(Vehicle)
				local VSpeed = GetEntitySpeed(Vehicle) * 3.6
				local Plate = GetVehicleNumberPlateText(Vehicle)
				local VLocked = GetVehicleDoorLockStatus(Vehicle)
				local _,VHeadlight,VHighBeam = GetVehicleLightsState(Vehicle)

				if ActualVehicle ~= Vehicle then
					SendNUIMessage({ Action = "Vehicle", Status = true })
					ActualVehicle = Vehicle
				end

				if Locked ~= VLocked then
					SendNUIMessage({ Action = "Locked", Status = VLocked })
					Locked = VLocked
				end

				if Headlights ~= VHeadlight or Headbeams ~= VHighBeam then
					SendNUIMessage({ Action = "Headlight", Status = VHeadlight, Beam = VHighBeam })
					Headlights = VHeadlight
					Headbeams = VHighBeam
				end

				local Tyre = 0
				for i = 0,5 do
					if IsVehicleTyreBurst(Vehicle,i,true) then
						Tyre = Tyre + 1
					end
				end

				if Tyres ~= Tyre then
					SendNUIMessage({ Action = "Tyres", Number = Tyre })
					Tyres = Tyre
				end

				if LocalPlayer["state"]["Nitro"] then
					SendNUIMessage({ Action = "Nitro", Number = NitroFuel })
					Nitro = NitroFuel
				else
					if (GlobalState["Nitro"][Plate] or 0) ~= Nitro then
						SendNUIMessage({ Action = "Nitro", Number = GlobalState["Nitro"][Plate] or 0 })
						Nitro = GlobalState["Nitro"][Plate] or 0
					end
				end

				if Fuel ~= VFuel then
					SendNUIMessage({ Action = "Fuel", Number = VFuel })
					Fuel = VFuel
				end

				if Speed ~= VSpeed then
					SendNUIMessage({ Action = "Speed", Number = VSpeed })
					Speed = VSpeed
				end

				if (VSpeed == 0 and Gear == 0) or (VSpeed == 0 and Gear == 1) then
					Gear = "N"
				elseif (VSpeed > 0 and Gear == 0) then
					Gear = "R"
				end

				SendNUIMessage({ Action = "Rpm", Number = Rpm, Gear = Gear })
			else
				if ActualVehicle then
					ActualVehicle = nil
					SendNUIMessage({ Action = "Vehicle", Status = false })

					Locked = false
					SendNUIMessage({ Action = "Locked", Status = false })

					if Handbrake then
						Handbrake = false
						SendNUIMessage({ Action = "Handbrake", Status = false })
					end

					Headbeams = false
					Headlights = false
					SendNUIMessage({ Action = "Headlight", Status = 0, Beam = 0 })

					Nitro = 0
					SendNUIMessage({ Action = "Nitro", Number = 0 })

					Tyres = 0
					SendNUIMessage({ Action = "Tyres", Number = 0 })

					Speed = 0
					SendNUIMessage({ Action = "Speed", Number = 0 })

					if IsMinimapRendering() then
						DisplayRadar(false)
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITROENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function NitroEnable()
	if GetGameTimer() >= NitroButton and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			NitroButton = GetGameTimer() + 1000

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				if GetVehicleTopSpeedModifier(Vehicle) < 50.0 then
					local Plate = GetVehicleNumberPlateText(Vehicle)
					NitroFuel = GlobalState["Nitro"][Plate] or 0

					if NitroFuel >= 1 then
						if GetIsVehicleEngineRunning(Vehicle) then
							local Speed = GetEntitySpeed(Vehicle) * 3.6
							if Speed > 10 then
								LocalPlayer["state"]:set("Nitro",true,true)

								while LocalPlayer["state"]["Nitro"] do
									if NitroFuel >= 1 then
										NitroFuel = NitroFuel - 1

										if not NitroFlame then
											SetVehicleRocketBoostActive(Vehicle,true)
											SetVehicleNitroEnabled(Vehicle,true)
											SetVehicleBoostActive(Vehicle,true)
											ModifyVehicleTopSpeed(Vehicle,50.0)
											SetLightTrail(Vehicle,true)
											NitroFlame = Plate
										end
									else
										if NitroFlame then
											SetVehicleRocketBoostActive(Vehicle,false)
											vSERVER.UpdateNitro(NitroFlame,NitroFuel)
											SetVehicleNitroEnabled(Vehicle,false)
											SetVehicleBoostActive(Vehicle,false)
											ModifyVehicleTopSpeed(Vehicle,0.0)
											SetLightTrail(Vehicle,false)
											NitroFlame = false

											LocalPlayer["state"]:set("Nitro",false,true)
										end
									end

									Wait(1)
								end
							else
								SetPurgeSprays(Vehicle,true)
								PurgeActive = true
							end
						else
							SetPurgeSprays(Vehicle,true)
							PurgeActive = true
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRODISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function NitroDisable()
	local Vehicle = GetLastDrivenVehicle()

	if NitroFlame then
		SetVehicleRocketBoostActive(Vehicle,false)
		vSERVER.UpdateNitro(NitroFlame,NitroFuel)
		SetVehicleNitroEnabled(Vehicle,false)
		SetVehicleBoostActive(Vehicle,false)
		ModifyVehicleTopSpeed(Vehicle,0.0)
		SetLightTrail(Vehicle,false)
		NitroFlame = false

		LocalPlayer["state"]:set("Nitro",false,true)
	end

	if PurgeActive then
		SetPurgeSprays(Vehicle,false)
		PurgeActive = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeNitro",NitroEnable)
RegisterCommand("-activeNitro",NitroDisable)
RegisterKeyMapping("+activeNitro","Ativação do nitro.","keyboard","LMENU")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETLIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function SetLightTrail(Vehicle,Enable)
	if LightTrails[Vehicle] == Enable then
		return
	end

	if Enable then
		local Particles = {}
		local LeftTrail = CreateLightTrail(Vehicle,GetEntityBoneIndexByName(Vehicle,"taillight_l"))
		local RightTrail = CreateLightTrail(Vehicle,GetEntityBoneIndexByName(Vehicle,"taillight_r"))

		Particles[#Particles + 1] = LeftTrail
		Particles[#Particles + 1] = RightTrail

		LightTrails[Vehicle] = true
		LightParticles[Vehicle] = Particles
	else
		if LightParticles[Vehicle] and #LightParticles[Vehicle] > 0 then
			for _,v in ipairs(LightParticles[Vehicle]) do
				StopLightTrail(v)
			end
		end

		LightTrails[Vehicle] = nil
		LightParticles[Vehicle] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATELIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateLightTrail(Vehicle,Bone)
	UseParticleFxAssetNextCall("core")
	local Particle = StartParticleFxLoopedOnEntityBone("veh_light_red_trail",Vehicle,0.0,0.0,0.0,0.0,0.0,0.0,Bone,1.0,false,false,false)
	SetParticleFxLoopedEvolution(Particle,"speed",1.0,false)

	return Particle
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPLIGHTTRAIL
-----------------------------------------------------------------------------------------------------------------------------------------
function StopLightTrail(Particle)
	CreateThread(function()
		local endTime = GetGameTimer() + 500
		while GetGameTimer() < endTime do 
			Wait(0)
			local now = GetGameTimer()
			local Scale = (endTime - now) / 500
			SetParticleFxLoopedScale(Particle,Scale)
			SetParticleFxLoopedAlpha(Particle,Scale)
		end

		StopParticleFxLooped(Particle)
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
function SetPurgeSprays(Vehicle,Enable)
	if PurgeSprays[Vehicle] == Enable then
		return
	end

	if Enable then
		local Particles = {}
		local Bone = GetEntityBoneIndexByName(Vehicle,"bonnet")
		local Position = GetWorldPositionOfEntityBone(Vehicle,Bone)
		local Offset = GetOffsetFromEntityGivenWorldCoords(Vehicle,Position["x"],Position["y"],Position["z"])

		for i = 0,3 do
			local LeftPurge = CreatePurgeSprays(Vehicle,Offset["x"] - 0.5,Offset["y"] + 0.05,Offset["z"],40.0,-20.0,0.0,0.5)
			local RightPurge = CreatePurgeSprays(Vehicle,Offset["x"] + 0.5,Offset["y"] + 0.05,Offset["z"],40.0,20.0,0.0,0.5)

			Particles[#Particles + 1] = LeftPurge
			Particles[#Particles + 1] = RightPurge
		end

		PurgeSprays[Vehicle] = true
		PurgeParticles[Vehicle] = Particles
	else
		if PurgeParticles[Vehicle] then
			RemoveParticleFxFromEntity(Vehicle)
		end

		PurgeSprays[Vehicle] = nil
		PurgeParticles[Vehicle] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPURGESPRAYS
-----------------------------------------------------------------------------------------------------------------------------------------
function CreatePurgeSprays(Vehicle,xOffset,yOffset,zOffset,xRot,yRot)
	UseParticleFxAssetNextCall("core")
	return StartNetworkedParticleFxNonLoopedOnEntity("ent_sht_steam",Vehicle,xOffset,yOffset,zOffset,xRot,yRot,0.0,0.5,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPACEENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function spaceEnable()
	if not Handbrake then
		SendNUIMessage({ Action = "Handbrake", Status = true })
		Handbrake = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPACEDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function spaceDisable()
	if Handbrake then
		SendNUIMessage({ Action = "Handbrake", Status = false })
		Handbrake = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPACE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+SpaceVehicle",spaceEnable)
RegisterCommand("-SpaceVehicle",spaceDisable)
RegisterKeyMapping("+SpaceVehicle","Freio do veículo.","keyboard","SPACE")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBELT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
					TimeDistance = 1

					local Vehicle = GetVehiclePedIsUsing(Ped)
					local Speed = GetEntitySpeed(Vehicle) * 3.6
					if GetVehicleDoorLockStatus(Vehicle) == 2 or SeatbeltLock then
						DisableControlAction(1,75,true)
					end

					if Speed ~= SeatbeltSpeed then
						if (SeatbeltSpeed - Speed) >= 60 and not SeatbeltLock then
							SmashVehicleWindow(Vehicle,6)
							SetEntityNoCollisionEntity(Ped,Vehicle,false)
							SetEntityNoCollisionEntity(Vehicle,Ped,false)
							TriggerServerEvent("hud:VehicleEject",SeatbeltVelocity)

							Wait(500)

							SetEntityNoCollisionEntity(Ped,Vehicle,true)
							SetEntityNoCollisionEntity(Vehicle,Ped,true)
						end

						SeatbeltVelocity = GetEntityVelocity(Vehicle)
						SeatbeltSpeed = Speed
					end
				end
			else
				if SeatbeltSpeed ~= 0 then
					SeatbeltSpeed = 0
				end

				if SeatbeltLock then
					SendNUIMessage({ Action = "Seatbelt", Status = false })
					SeatbeltLock = false
				end

				if NitroFlame then
					NitroDisable()
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Beltz",function(source)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
			if SeatbeltLock then
				TriggerEvent("sounds:Private","unbelt",0.5)
				SendNUIMessage({ Action = "Seatbelt", Status = false })
				SeatbeltLock = false
			else
				TriggerEvent("sounds:Private","belt",0.5)
				SendNUIMessage({ Action = "Seatbelt", Status = true })
				SeatbeltLock = true
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Beltz","Colocar/Retirar o cinto.","keyboard","G")