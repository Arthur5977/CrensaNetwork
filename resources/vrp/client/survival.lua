-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Death = false
local DeathTimer = 300
local Cooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	LocalPlayer["state"]:set("Name",Name,true)
	LocalPlayer["state"]:set("Active",true,true)
	LocalPlayer["state"]:set("Invincible",true,true)
	LocalPlayer["state"]:set("Passport",Passport,true)

	SetDiscordAppId(909884329084223488)
	SetDiscordRichPresenceAsset("creative")
	SetRichPresence("#"..Passport.." "..Name)
	SetDiscordRichPresenceAssetSmall("creative")
	SetDiscordRichPresenceAssetText("Hensa Rewritten")
	SetDiscordRichPresenceAssetSmallText("Hensa Rewritten")
	SetDiscordRichPresenceAction(0,"Nosso Discord","https://www.creative-rp.com/")
	SetDiscordRichPresenceAction(1,"Nosso Instagram","https://www.creative-rp.com/instagram/")

	local Pid = PlayerId()
	local Ped = PlayerPedId()

	SetEntityInvincible(Ped,true)
	FreezeEntityPosition(Ped,false)
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(Ped,true,false)

	StopAudioScenes()
	RemovePickups(Pid)
	SetMaxWantedLevel(0)
	SetRandomBoats(false)
	SetRandomTrains(false)
	SetGarbageTrucks(false)
	SetPedHelmet(Ped,false)
	SetDeepOceanScaler(0.0)
	SetPlayerTargetingMode(0)
	SetRandomEventFlag(false)
	SetPoliceRadarBlips(false)
	DistantCopCarSirens(false)
	SetWeaponsNoAutoswap(true)
	ClearPlayerWantedLevel(Pid)
	SetPoliceIgnorePlayer(Ped,true)
	SetArtificialLightsState(false)
	SetPlayerCanUseCover(Pid,false)
	SetPedSteersAroundPeds(Ped,true)
	DisableVehicleDistantlights(true)
	SetDispatchCopsForPlayer(Ped,false)
	SetAllVehicleGeneratorsActive(true)
	SetFlashLightKeepOnWhileMoving(true)
	SetPedDropsWeaponsWhenDead(Ped,false)
	SetPedCanLosePropsOnDamage(Ped,false,0)
	SetPedCanBeKnockedOffVehicle(Ped,false)
	SetPedCanRagdollFromPlayerImpact(Ped,false)

	SetPedConfigFlag(Ped,48,true)
	SetPedConfigFlag(Ped,33,false)
	SetPedConfigFlag(Ped,461,true)
	SetPedConfigFlag(Ped,438,true)
	SetPedConfigFlag(Ped,434,true)

	SetEntityDrawOutlineShader(1)
	SetBlipAlpha(GetNorthRadarBlip(),0)
	SetEntityDrawOutlineColor(65,130,226,255)
	ReplaceHudColourWithRgba(116,65,130,226,255)

	SetAudioFlag("DisableFlightMusic",true)
	SetAudioFlag("PoliceScannerDisabled",true)
	SetScenarioGroupEnabled("Heist_Island_Peds",true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_SOLO",true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)

	SetWeaponDamageModifierThisFrame("WEAPON_BAT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KATANA",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_HAMMER",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_WRENCH",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_UNARMED",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_HATCHET",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_CROWBAR",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_MACHETE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_POOLCUE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KNUCKLE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KARAMBIT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_GOLFCLUB",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_BATTLEAXE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_FLASHLIGHT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_NIGHTSTICK",0.35)
	SetWeaponDamageModifierThisFrame("WEAPON_SMOKEGRENADE",0.0)
	SetWeaponDamageModifierThisFrame("WEAPON_STONE_HATCHET",0.25)

	for Number = 0,121 do
		EnableDispatchService(Number,false)
	end

	SetTimeout(10000,function()
		SetEntityInvincible(Ped,false)
		LocalPlayer["state"]:set("Invincible",false,true)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPICKUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function RemovePickups(Pid)
	local Pickups = {
		`PICKUP_AMMO_BULLET_MP`,
		`PICKUP_AMMO_FIREWORK`,
		`PICKUP_AMMO_FLAREGUN`,
		`PICKUP_AMMO_GRENADELAUNCHER`,
		`PICKUP_AMMO_GRENADELAUNCHER_MP`,
		`PICKUP_AMMO_HOMINGLAUNCHER`,
		`PICKUP_AMMO_MG`,
		`PICKUP_AMMO_MINIGUN`,
		`PICKUP_AMMO_MISSILE_MP`,
		`PICKUP_AMMO_PISTOL`,
		`PICKUP_AMMO_RIFLE`,
		`PICKUP_AMMO_RPG`,
		`PICKUP_AMMO_SHOTGUN`,
		`PICKUP_AMMO_SMG`,
		`PICKUP_AMMO_SNIPER`,
		`PICKUP_ARMOUR_STANDARD`,
		`PICKUP_CAMERA`,
		`PICKUP_CUSTOM_SCRIPT`,
		`PICKUP_GANG_ATTACK_MONEY`,
		`PICKUP_HEALTH_SNACK`,
		`PICKUP_HEALTH_STANDARD`,
		`PICKUP_MONEY_CASE`,
		`PICKUP_MONEY_DEP_BAG`,
		`PICKUP_MONEY_MED_BAG`,
		`PICKUP_MONEY_PAPER_BAG`,
		`PICKUP_MONEY_PURSE`,
		`PICKUP_MONEY_SECURITY_CASE`,
		`PICKUP_MONEY_VARIABLE`,
		`PICKUP_MONEY_WALLET`,
		`PICKUP_PARACHUTE`,
		`PICKUP_PORTABLE_CRATE_FIXED_INCAR`,
		`PICKUP_PORTABLE_CRATE_UNFIXED`,
		`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,
		`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,
		`PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,
		`PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,
		`PICKUP_PORTABLE_PACKAGE`,
		`PICKUP_SUBMARINE`,
		`PICKUP_VEHICLE_ARMOUR_STANDARD`,
		`PICKUP_VEHICLE_CUSTOM_SCRIPT`,
		`PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,
		`PICKUP_VEHICLE_HEALTH_STANDARD`,
		`PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,
		`PICKUP_VEHICLE_MONEY_VARIABLE`,
		`PICKUP_VEHICLE_WEAPON_APPISTOL`,
		`PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,
		`PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,
		`PICKUP_VEHICLE_WEAPON_GRENADE`,
		`PICKUP_VEHICLE_WEAPON_MICROSMG`,
		`PICKUP_VEHICLE_WEAPON_MOLOTOV`,
		`PICKUP_VEHICLE_WEAPON_PISTOL`,
		`PICKUP_VEHICLE_WEAPON_PISTOL50`,
		`PICKUP_VEHICLE_WEAPON_SAWNOFF`,
		`PICKUP_VEHICLE_WEAPON_SMG`,
		`PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,
		`PICKUP_VEHICLE_WEAPON_STICKYBOMB`,
		`PICKUP_WEAPON_ADVANCEDRIFLE`,
		`PICKUP_WEAPON_APPISTOL`,
		`PICKUP_WEAPON_ASSAULTRIFLE`,
		`PICKUP_WEAPON_ASSAULTSHOTGUN`,
		`PICKUP_WEAPON_ASSAULTSMG`,
		`PICKUP_WEAPON_AUTOSHOTGUN`,
		`PICKUP_WEAPON_BAT`,
		`PICKUP_WEAPON_BATTLEAXE`,
		`PICKUP_WEAPON_BOTTLE`,
		`PICKUP_WEAPON_BULLPUPRIFLE`,
		`PICKUP_WEAPON_BULLPUPSHOTGUN`,
		`PICKUP_WEAPON_CARBINERIFLE`,
		`PICKUP_WEAPON_COMBATMG`,
		`PICKUP_WEAPON_COMBATPDW`,
		`PICKUP_WEAPON_COMBATPISTOL`,
		`PICKUP_WEAPON_COMPACTLAUNCHER`,
		`PICKUP_WEAPON_COMPACTRIFLE`,
		`PICKUP_WEAPON_CROWBAR`,
		`PICKUP_WEAPON_DAGGER`,
		`PICKUP_WEAPON_DBSHOTGUN`,
		`PICKUP_WEAPON_FIREWORK`,
		`PICKUP_WEAPON_FLAREGUN`,
		`PICKUP_WEAPON_FLASHLIGHT`,
		`PICKUP_WEAPON_GRENADE`,
		`PICKUP_WEAPON_GRENADELAUNCHER`,
		`PICKUP_WEAPON_GUSENBERG`,
		`PICKUP_WEAPON_GOLFCLUB`,
		`PICKUP_WEAPON_HAMMER`,
		`PICKUP_WEAPON_HATCHET`,
		`PICKUP_WEAPON_HEAVYPISTOL`,
		`PICKUP_WEAPON_HEAVYSHOTGUN`,
		`PICKUP_WEAPON_HEAVYSNIPER`,
		`PICKUP_WEAPON_HOMINGLAUNCHER`,
		`PICKUP_WEAPON_KNIFE`,
		`PICKUP_WEAPON_KNUCKLE`,
		`PICKUP_WEAPON_MACHETE`,
		`PICKUP_WEAPON_MACHINEPISTOL`,
		`PICKUP_WEAPON_MARKSMANPISTOL`,
		`PICKUP_WEAPON_MARKSMANRIFLE`,
		`PICKUP_WEAPON_MG`,
		`PICKUP_WEAPON_MICROSMG`,
		`PICKUP_WEAPON_MINIGUN`,
		`PICKUP_WEAPON_MINISMG`,
		`PICKUP_WEAPON_MOLOTOV`,
		`PICKUP_WEAPON_MUSKET`,
		`PICKUP_WEAPON_NIGHTSTICK`,
		`PICKUP_WEAPON_PETROLCAN`,
		`PICKUP_WEAPON_PIPEBOMB`,
		`PICKUP_WEAPON_PISTOL`,
		`PICKUP_WEAPON_PISTOL50`,
		`PICKUP_WEAPON_POOLCUE`,
		`PICKUP_WEAPON_PROXMINE`,
		`PICKUP_WEAPON_PUMPSHOTGUN`,
		`PICKUP_WEAPON_RAILGUN`,
		`PICKUP_WEAPON_REVOLVER`,
		`PICKUP_WEAPON_RPG`,
		`PICKUP_WEAPON_SAWNOFFSHOTGUN`,
		`PICKUP_WEAPON_SMG`,
		`PICKUP_WEAPON_SMOKEGRENADE`,
		`PICKUP_WEAPON_SNIPERRIFLE`,
		`PICKUP_WEAPON_SNSPISTOL`,
		`PICKUP_WEAPON_SPECIALCARBINE`,
		`PICKUP_WEAPON_STICKYBOMB`,
		`PICKUP_WEAPON_STUNGUN`,
		`PICKUP_WEAPON_SWITCHBLADE`,
		`PICKUP_WEAPON_VINTAGEPISTOL`,
		`PICKUP_WEAPON_WRENCH`,
		`PICKUP_WEAPON_RAYCARBINE`
	}

	for Number = 1,#Pickups do
		ToggleUsePickupsForPlayer(Pid,Pickups[Number],false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) <= 100 then
				if not Death then
					Death = true

					local Coords = GetEntityCoords(Ped)
					NetworkResurrectLocalPlayer(Coords,0.0)

					NetworkSetFriendlyFireOption(false)
					SetEntityInvincible(Ped,true)
					SetEntityHealth(Ped,100)

					if LocalPlayer["state"]["Route"] < 900000 then
						DeathTimer = 300

						TriggerEvent("hud:RemoveHood")
						TriggerEvent("hud:ScubaRemove")
						TriggerEvent("radio:RadioClean")
						TriggerEvent("inventory:Cancel")
						TriggerEvent("inventory:CleanWeapons")
						TriggerServerEvent("paramedic:bloodDeath")
						TriggerServerEvent("pma-voice:toggleMute",true)
					else
						DeathTimer = 5
					end

					SendNUIMessage({ Action = "Display", Mode = "block" })
					TriggerEvent("inventory:preventWeapon",false)
					tvRP.playAnim(false,{"dead","dead_a"},true)
					TriggerEvent("inventory:Close")
				else
					TimeDistance = 1
					SetEntityHealth(Ped,100)

					DisableControlAction(1,18,true)
					DisableControlAction(1,22,true)
					DisableControlAction(1,24,true)
					DisableControlAction(1,25,true)
					DisableControlAction(1,68,true)
					DisableControlAction(1,70,true)
					DisableControlAction(1,91,true)
					DisableControlAction(1,69,true)
					DisableControlAction(1,75,true)
					DisableControlAction(1,140,true)
					DisableControlAction(1,142,true)
					DisableControlAction(1,257,true)
					DisablePlayerFiring(Ped,true)

					if not IsEntityPlayingAnim(Ped,"dead","dead_a",3) and not IsPedInAnyVehicle(Ped) and not IsEntityPlayingAnim(Ped,"nm","firemans_carry",3) then
						tvRP.playAnim(false,{"dead","dead_a"},true)
					end

					if IsPedInAnyVehicle(Ped) then
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							SetVehicleEngineOn(Vehicle,false,true,true)
						end
					end
					
					if LocalPlayer["state"]["Route"] > 900000 and IsControlJustPressed(1,38) then
						TriggerEvent("arena:ResetStreek")
						TriggerEvent("arena:Respawn")
					end

					if GetGameTimer() >= Cooldown then
						Cooldown = GetGameTimer() + 1000

						if DeathTimer > 0 then
							DeathTimer = DeathTimer - 1
							SendNUIMessage({ Action = "Message", Message = "Você está inconsciente, aguarde "..DeathTimer.." segundos" })

							if DeathTimer <= 0 then
								if LocalPlayer["state"]["Route"] < 900000 then
									SendNUIMessage({ Action = "Message", Message = "Digite <color>/GG</color> para desistir imediatamente" })
								else
									SendNUIMessage({ Action = "Message", Message = "Pressione <color>E</color> para renascer dentro da arena" })
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
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()

		SetPlayerHealthRechargeMultiplier(Pid,0.0)
		SetPlayerHealthRechargeLimit(Pid,0.0)

		if GetEntityMaxHealth(Ped) ~= 200 then
			SetEntityMaxHealth(Ped,200)
			SetPedMaxHealth(Ped,200)
		end

		if GetPlayerMaxArmour(Ped) ~= 100 then
			SetPlayerMaxArmour(Ped,100)
		end

		if GetPlayerMaxStamina(Pid) ~= 100.0 then
			SetPlayerMaxStamina(Pid,100.0)
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CheckDeath()
	if Death and DeathTimer <= 0 then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Respawn()
	Death = false
	DeathTimer = 300

	ClearPedTasks(PlayerPedId())
	NetworkSetFriendlyFireOption(true)
	ClearPedBloodDamage(PlayerPedId())
	SetEntityHealth(PlayerPedId(),200)
	SetEntityInvincible(PlayerPedId(),false)

	TriggerEvent("paramedic:Reset")
	TriggerEvent("inventory:CleanWeapons")
	LocalPlayer["state"]:set("Handcuff",false,true)
	TriggerServerEvent("pma-voice:toggleMute",false)

	DoScreenFadeOut(0)

	if LocalPlayer["state"]["Policia"] then
		SetEntityCoords(PlayerPedId(),RevivePoliceCoords)
	elseif LocalPlayer["state"]["Paramedico"] then
		SetEntityCoords(PlayerPedId(),ReviveParamedicCoords)
	else
		SetEntityCoords(PlayerPedId(),RevivePedCoords)
	end

	SendNUIMessage({ Action = "Display", Mode = "none" })
	Wait(1000)
	DoScreenFadeIn(1000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Revive(Health,Arena)
	local Ped = PlayerPedId()

	SetEntityHealth(Ped,Health)
	SetEntityInvincible(Ped,false)

	if Arena then
		SetPedArmour(Ped,99)
	end

	if Death then
		Death = false
		DeathTimer = 300

		ClearPedTasks(Ped)
		NetworkSetFriendlyFireOption(true)

		SendNUIMessage({ Action = "Display", Mode = "none" })

		if LocalPlayer["state"]["Route"] < 900000 then
			TriggerEvent("paramedic:Reset")
			TriggerServerEvent("pma-voice:toggleMute",false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("SyncArea")
AddEventHandler("SyncArea",function(x,y,z,Distance)
	ClearAreaOfVehicles(x,y,z,Distance + 0.0,false,false,false,false,false)
	ClearAreaOfEverything(x,y,z,Distance + 0.0,false,false,false,false)
end)