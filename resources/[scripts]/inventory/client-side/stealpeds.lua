-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if not IsPedInAnyVehicle(Ped) and IsPedArmed(Ped,7) then
			local Progress = 500
			local Pid = PlayerId()
			local Entitys = ClosestPed(2)
			if Entitys and not List[Entitys] and (IsPedInMeleeCombat(Ped) or IsPlayerFreeAiming(Pid)) then
				List[Entitys] = true

				ClearPedTasks(Entitys)
				ClearPedSecondaryTask(Entitys)
				ClearPedTasksImmediately(Entitys)

				TaskSetBlockingOfNonTemporaryEvents(Entitys,true)
				SetBlockingOfNonTemporaryEvents(Entitys,true)
				SetEntityAsMissionEntity(Entitys,true,true)
				SetPedDropsWeaponsWhenDead(Entitys,false)
				TaskTurnPedToFaceEntity(Entitys,Ped,3.0)
				SetPedSuffersCriticalHits(Entitys,false)

				LocalPlayer["state"]:set("Buttons",true,true)
				LocalPlayer["state"]:set("Commands",true,true)

				if LoadAnim("random@mugging3") then
					TaskPlayAnim(Entitys,"random@mugging3","handsup_standing_base",8.0,8.0,-1,16,0,0,0,0)
				end

				while true do
					local Pid = PlayerId()
					local Ped = PlayerPedId()
					local Coords = GetEntityCoords(Ped)
					local EntityCoords = GetEntityCoords(Entitys)

					if #(Coords - EntityCoords) <= 2 and MumbleIsConnected() and (IsPedInMeleeCombat(Ped) or IsPlayerFreeAiming(Pid)) then
						Progress = Progress - 1

						if not IsEntityPlayingAnim(Entitys,"random@mugging3","handsup_standing_base",3) then
							TaskPlayAnim(Entitys,"random@mugging3","handsup_standing_base",8.0,8.0,-1,16,0,0,0,0)
						end

						if Progress <= 0 and LoadModel("prop_paper_bag_small") then
							local Object = CreateObject("prop_paper_bag_small",Coords["x"],Coords["y"],Coords["z"],false,false,false)
							AttachEntityToEntity(Object,Entitys,GetPedBoneIndex(Entitys,28422),0.0,-0.05,0.05,180.0,0.0,0.0,false,false,false,false,2,true)

							if LoadAnim("mp_safehouselost@") then
								TaskPlayAnim(Entitys,"mp_safehouselost@","package_dropoff",8.0,8.0,-1,16,0,0,0,0)
							end

							Wait(3000)

							if DoesEntityExist(Object) then
								DeleteEntity(Object)
							end

							if MumbleIsConnected() then
								vSERVER.StealPeds()
							end

							ClearPedSecondaryTask(Entitys)
							TaskWanderStandard(Entitys,10.0,10)
							SetEntityAsNoLongerNeeded(Entitys)

							LocalPlayer["state"]:set("Buttons",false,true)
							LocalPlayer["state"]:set("Commands",false,true)

							break
						end
					else
						ClearPedSecondaryTask(Entitys)
						TaskWanderStandard(Entitys,10.0,10)
						SetEntityAsNoLongerNeeded(Entitys)

						LocalPlayer["state"]:set("Buttons",false,true)
						LocalPlayer["state"]:set("Commands",false,true)

						break
					end

					Wait(1)
				end
			end
		end

		Wait(TimeDistance)
	end
end)