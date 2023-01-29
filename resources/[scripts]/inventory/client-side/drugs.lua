-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {}
local Timer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if not IsPedInAnyVehicle(Ped) then
			local Progress = 500
			local Pid = PlayerId()
			local Entitys = ClosestPed(1)
			if Entitys and not List[Entitys] then
				TimeDistance = 1

				if IsControlJustPressed(1,38) and GetGameTimer() >= Timer and MumbleIsConnected() and vSERVER.CheckDrugs() then
					List[Entitys] = true
					Timer = GetGameTimer() + 5000

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

					if LoadAnim("jh_1_ig_3-2") then
						TaskPlayAnim(Entitys,"jh_1_ig_3-2","cs_jewelass_dual-2",8.0,8.0,-1,16,0,0,0,0)
					end

					while true do
						local Ped = PlayerPedId()
						local Coords = GetEntityCoords(Ped)
						local EntityCoords = GetEntityCoords(Entitys)

						if #(Coords - EntityCoords) <= 2 then
							Progress = Progress - 1

							if not IsEntityPlayingAnim(Entitys,"jh_1_ig_3-2","cs_jewelass_dual-2",3) then
								TaskPlayAnim(Entitys,"jh_1_ig_3-2","cs_jewelass_dual-2",8.0,8.0,-1,16,0,0,0,0)
							end

							if Progress <= 0 and LoadModel("prop_anim_cash_note") then
								local Object = CreateObject("prop_anim_cash_note",Coords["x"],Coords["y"],Coords["z"],false,false,false)
								AttachEntityToEntity(Object,Entitys,GetPedBoneIndex(Entitys,28422),0.0,0.0,0.0,90.0,0.0,0.0,false,false,false,false,2,true)
								vRP.CreateObjects("mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)
								SetModelAsNoLongerNeeded("prop_anim_cash_note")

								if LoadAnim("mp_safehouselost@") then
									TaskPlayAnim(Entitys,"mp_safehouselost@","package_dropoff",8.0,8.0,-1,16,0,0,0,0)
								end

								Wait(3000)

								if DoesEntityExist(Object) then
									DeleteEntity(Object)
								end

								ClearPedSecondaryTask(Entitys)
								TaskWanderStandard(Entitys,10.0,10)
								SetEntityAsNoLongerNeeded(Entitys)

								if MumbleIsConnected() then
									vSERVER.PaymentDrugs()
								end

								vRP.Destroy()

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
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESTPED
-----------------------------------------------------------------------------------------------------------------------------------------
function ClosestPed(Radius)
	local Selected = false
	local Ped = PlayerPedId()
	local Radius = Radius + 0.0001
	local Coords = GetEntityCoords(Ped)
	local GamePool = GetGamePool("CPed")

	for _,Entity in pairs(GamePool) do
		if Entity ~= PlayerPedId() and not IsPedAPlayer(Entity) and not IsEntityDead(Entity) and not IsPedDeadOrDying(Entity) and GetPedArmour(Entity) <= 0 and not IsPedInAnyVehicle(Entity) and GetPedType(Entity) ~= 28 then
			local EntityCoords = GetEntityCoords(Entity)
			local EntityDistance = #(Coords - EntityCoords)

			if EntityDistance < Radius then
				Radius = EntityDistance
				Selected = Entity
			end
		end
	end

	return Selected
end