-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("inventory",Creative)
vGARAGE = Tunnel.getInterface("garages")
vSERVER = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drops = {}
local Types = ""
local Weapon = ""
local Usables = 1
local Actived = false
local Inventory = false
local TakeWeapon = false
local StoreWeapon = false
local Reloaded = GetGameTimer()
local UseCooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Weapons",function()
	return Weapon
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Cancel")
AddEventHandler("inventory:Cancel",function()
	vSERVER.Cancel()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:ObjectsVerify")
AddEventHandler("inventory:ObjectsVerify",function(Entity,Service)
	vSERVER.VerifyObjects(Entity,Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:LOOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Loot")
AddEventHandler("inventory:Loot",function(Entity,Service)
	vSERVER.Loot(Entity,Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STEALTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:StealTrunk")
AddEventHandler("inventory:StealTrunk",function(Entity)
	vSERVER.StealTrunk(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Animals")
AddEventHandler("inventory:Animals",function(Entity,Service)
	vSERVER.Animals(Entity,Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:StoreObjects")
AddEventHandler("inventory:StoreObjects",function(Number)
	vSERVER.StoreObjects(Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:MAKEPRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:MakeProducts")
AddEventHandler("inventory:MakeProducts",function(Service)
	vSERVER.MakeProducts(Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:MAKEPACKAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:MakePackage")
AddEventHandler("inventory:MakePackage",function(Service)
	vSERVER.MakePackage(Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Dismantle")
AddEventHandler("inventory:Dismantle",function(Entity)
	vSERVER.Dismantle(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RemoveTyres")
AddEventHandler("inventory:RemoveTyres",function(Entity)
	vSERVER.RemoveTyres(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEANWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:CleanWeapons")
AddEventHandler("inventory:CleanWeapons",function(Create)
	if Weapon ~= "" then
		RemoveAllPedWeapons(PlayerPedId(),true)
	end

	TriggerEvent("hud:Weapon",false)
	Actived = false
	Weapon = ""
	Types = ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if LocalPlayer["state"]["Buttons"] then
			TimeDistance = 1
			DisableControlAction(0,75,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,257,true)
			DisablePlayerFiring(Ped,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Buttons")
AddEventHandler("inventory:Buttons",function(status)
	LocalPlayer["state"]["Buttons"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- throwableWeapons
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:throwableWeapons")
AddEventHandler("inventory:throwableWeapons",function(weaponName)
	currentWeapon = weaponName

	local ped = PlayerPedId()
	if GetSelectedPedWeapon(ped) == GetHashKey(currentWeapon) then
		while GetSelectedPedWeapon(ped) == GetHashKey(currentWeapon) do
			if IsPedShooting(ped) then
				vSERVER.removeThrowing(currentWeapon)
			end
			Wait(0)
		end

		currentWeapon = ""
	else
		Creative.storeWeaponHands()
		currentWeapon = ""
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Inventory then
		Inventory = false
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "hideMenu" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(Data,Callback)
	TriggerEvent("inventory:Close")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deliver",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Deliver(Data["slot"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Repair",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Repair(Data["slot"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:SLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Slot")
AddEventHandler("inventory:Slot",function(Number,Amount)
	Usables = parseInt(Number)
	if MumbleIsConnected() then
		vSERVER.UseItem(Number,Amount)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("useItem",function(Data,Callback)
	if GetGameTimer() >= UseCooldown then
		TriggerEvent("inventory:Slot",Data["slot"],Data["amount"])
		UseCooldown = GetGameTimer() + 1000
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendItem",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.SendItem(Data["slot"],Data["amount"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(Data,Callback)
	vSERVER.invUpdate(Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Update")
AddEventHandler("inventory:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:verifyWeapon")
AddEventHandler("inventory:verifyWeapon",function(Item)
	local Split = splitString(Item,"-")
	local Name = Split[1]

	if Weapon == Name then
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)
		if not vSERVER.verifyWeapon(Weapon,Ammo) or not MumbleIsConnected() then
			TriggerEvent("inventory:CleanWeapons",false)
		end
	else
		if Weapon == "" or not MumbleIsConnected() then
			vSERVER.verifyWeapon(Name)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:preventWeapon")
AddEventHandler("inventory:preventWeapon",function()
	if Weapon ~= "" then
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

		if MumbleIsConnected() then
			vSERVER.preventWeapon(Weapon,Ammo)
		end

		TriggerEvent("hud:Weapon",false)
		RemoveAllPedWeapons(Ped,true)

		Actived = false
		Weapon = ""
		Types = ""
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Inventory",function()
	if not IsPauseMenuActive() and GetEntityHealth(PlayerPedId()) > 100 and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not IsPlayerFreeAiming(PlayerId()) then
		Inventory = true
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "showMenu" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Inventory","Abrir/Fechar a mochila.","keyboard","OEM_3")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairVehicle")
AddEventHandler("inventory:repairVehicle",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local Tyres = {}

				for i = 0,7 do
					local Status = false

					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						Status = true
					end

					Tyres[i] = Status
				end

				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleFixed(Vehicle)
				SetVehicleDeformationFixed(Vehicle)

				SetVehicleFuelLevel(Vehicle,Fuel)

				for Tyre,Burst in pairs(Tyres) do
					if Burst then
						SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRTYRE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairTyre")
AddEventHandler("inventory:repairTyre",function(Vehicle,Tyres,Plate)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				for i = 0,7 do
					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						SetVehicleTyreBurst(Vehicle,i,true,1000.0)
					end
				end

				SetVehicleTyreFixed(Vehicle,Tyres)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairPlayer")
AddEventHandler("inventory:repairPlayer",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleEngineHealth(Vehicle,1000.0)
				SetVehicleBodyHealth(Vehicle,1000.0)
				SetEntityHealth(Vehicle,1000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairAdmin")
AddEventHandler("inventory:repairAdmin",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleFixed(Vehicle)
				SetVehicleDeformationFixed(Vehicle)

				SetVehicleFuelLevel(Vehicle,Fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEALARM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:vehicleAlarm")
AddEventHandler("inventory:vehicleAlarm",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleAlarm(Vehicle,true)
				StartVehicleAlarm(Vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARACHUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Parachute()
	GiveWeaponToPed(PlayerPedId(),"GADGET_PARACHUTE",1,false,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHING
-----------------------------------------------------------------------------------------------------------------------------------------
local Fishing = PolyZone:Create({
	vec2(2308.64,3906.11),
	vec2(2180.13,3885.29),
	vec2(2058.22,3883.56),
	vec2(2024.97,3942.53),
	vec2(1748.72,3964.53),
	vec2(1655.65,3886.34),
	vec2(1547.59,3830.17),
	vec2(1540.73,3826.94),
	vec2(1535.67,3816.55),
	vec2(1456.35,3756.87),
	vec2(1263.44,3670.38),
	vec2(1172.99,3648.83),
	vec2(967.98,3653.54),
	vec2(840.55,3679.16),
	vec2(633.13,3600.70),
	vec2(361.73,3626.24),
	vec2(310.58,3571.61),
	vec2(266.92,3493.13),
	vec2(173.49,3421.45),
	vec2(128.16,3442.66),
	vec2(143.41,3743.49),
	vec2(-38.59,3754.16),
	vec2(-132.62,3716.80),
	vec2(-116.73,3805.33),
	vec2(-157.23,3838.81),
	vec2(-204.70,3846.28),
	vec2(-208.28,3873.08),
	vec2(-236.88,4076.58),
	vec2(-184.11,4231.52),
	vec2(-139.54,4253.54),
	vec2(-45.38,4344.43),
	vec2(-5.96,4408.34),
	vec2(38.36,4411.02),
	vec2(150.77,4311.74),
	vec2(216.02,4342.85),
	vec2(294.16,4245.62),
	vec2(396.21,4342.24),
	vec2(438.37,4315.38),
	vec2(505.22,4178.69),
	vec2(606.65,4202.34),
	vec2(684.48,4169.83),
	vec2(773.54,4152.33),
	vec2(877.34,4172.67),
	vec2(912.20,4269.57),
	vec2(850.92,4428.91),
	vec2(922.96,4376.48),
	vec2(941.32,4328.09),
	vec2(995.318,4288.70),
	vec2(1050.33,4215.29),
	vec2(1082.27,4285.61),
	vec2(1060.97,4365.31),
	vec2(1072.62,4372.37),
	vec2(1119.24,4317.53),
	vec2(1275.27,4354.90),
	vec2(1360.96,4285.09),
	vec2(1401.09,4283.69),
	vec2(1422.33,4339.60),
	vec2(1516.60,4393.69),
	vec2(1597.58,4455.65),
	vec2(1650.81,4499.17),
	vec2(1781.12,4525.83),
	vec2(1828.69,4560.26),
	vec2(1866.59,4554.49),
	vec2(2162.70,4664.53),
	vec2(2279.31,4660.26),
	vec2(2290.52,4630.90),
	vec2(2418.64,4613.91),
	vec2(2427.06,4597.69),
	vec2(2449.86,4438.97),
	vec2(2396.62,4353.36),
	vec2(2383.66,4160.74),
	vec2(2383.05,4046.07)
},{ name = "Fishing" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Fishing()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	if Fishing:isPointInside(Coords) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.animalAnim()
	local Ped = PlayerPedId()
	if IsEntityPlayingAnim(Ped,"anim@gangops@facility@servers@bodysearch@","player_search",3) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.returnWeapon()
	return Weapon ~= "" and Weapon or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkWeapon(Hash)
	return Weapon == Hash and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponAttachs = {
	["attachsFlashlight"] = {
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_02",
		["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_03",
		["WEAPON_PISTOL50"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SMG"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_FLSH"
	},
	["attachsCrosshair"] = {
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_RAIL",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_RAIL_02",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_SCOPE_MACRO",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_SCOPE_MEDIUM",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_SCOPE_SMALL",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_SCOPE_MACRO_02_MK2",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_SCOPE_MEDIUM",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SCOPE_SMALL_MK2",
		["WEAPON_SMG"] = "COMPONENT_AT_SCOPE_MACRO_02",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_SCOPE_MACRO",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_SCOPE_MACRO"
	},
	["attachsMagazine"] = {
		["WEAPON_PISTOL"] = "COMPONENT_PISTOL_CLIP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_PISTOL_MK2_CLIP_02",
		["WEAPON_COMPACTRIFLE"] = "COMPONENT_COMPACTRIFLE_CLIP_02",
		["WEAPON_APPISTOL"] = "COMPONENT_APPISTOL_CLIP_02",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_HEAVYPISTOL_CLIP_02",
		["WEAPON_MACHINEPISTOL"] = "COMPONENT_MACHINEPISTOL_CLIP_02",
		["WEAPON_MICROSMG"] = "COMPONENT_MICROSMG_CLIP_02",
		["WEAPON_MINISMG"] = "COMPONENT_MINISMG_CLIP_02",
		["WEAPON_SNSPISTOL"] = "COMPONENT_SNSPISTOL_CLIP_02",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_SNSPISTOL_MK2_CLIP_02",
		["WEAPON_VINTAGEPISTOL"] = "COMPONENT_VINTAGEPISTOL_CLIP_02",
		["WEAPON_PISTOL50"] = "COMPONENT_PISTOL50_CLIP_02",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_COMBATPISTOL_CLIP_02",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_CARBINERIFLE_CLIP_02",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
		["WEAPON_ADVANCEDRIFLE"] = "COMPONENT_ADVANCEDRIFLE_CLIP_02",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_BULLPUPRIFLE_CLIP_02",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_SPECIALCARBINE_CLIP_02",
		["WEAPON_SMG"] = "COMPONENT_SMG_CLIP_02",
		["WEAPON_SMG_MK2"] = "COMPONENT_SMG_MK2_CLIP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_ASSAULTRIFLE_CLIP_02",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_ASSAULTSMG_CLIP_02",
		["WEAPON_GUSENBERG"] = "COMPONENT_GUSENBERG_CLIP_02"
	},
	["attachsSilencer"] = {
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_MACHINEPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
		["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_COLTXM177"] = "COMPONENT_COLTXM177_SUPP",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02"
	},
	["attachsGrip"] = {
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_01",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_MUZZLE_01",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_MUZZLE_08",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_MUZZLE_01",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkAttachs(nameItem,nameWeapon)
	return weaponAttachs[nameItem][nameWeapon]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putAttachs(nameItem,nameWeapon)
	GiveWeaponComponentToPed(PlayerPedId(),nameWeapon,weaponAttachs[nameItem][nameWeapon])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putWeaponHands(Name,Ammo,Components,Type)
	if not TakeWeapon then
		if not Ammo then
			Ammo = 0
		end

		if Ammo > 0 then
			Actived = true
		end

		TakeWeapon = true
		LocalPlayer["state"]:set("Cancel",true,true)

		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			if LoadAnim("rcmjosh4") then
				TaskPlayAnim(Ped,"rcmjosh4","josh_leadout_cop2",8.0,8.0,-1,48,0,0,0,0)
			end

			Wait(200)

			Weapon = Name
			TriggerEvent("inventory:RemoveWeapon",Name)
			GiveWeaponToPed(Ped,Name,Ammo,false,true)

			Wait(300)

			ClearPedTasks(Ped)
		else
			Weapon = Name
			TriggerEvent("inventory:RemoveWeapon",Name)
			GiveWeaponToPed(Ped,Name,Ammo,false,true)
		end

		if Components then
			for nameItem,_ in pairs(Components) do
				Creative.putAttachs(nameItem,Name)
			end
		end

		if Type then
			Types = Type
		end

		TakeWeapon = false
		LocalPlayer["state"]:set("Cancel",false,true)

		if itemAmmo(Name) then
			TriggerEvent("hud:Weapon",true,Name)
		end

		if not MumbleIsConnected() or vSERVER.dropWeapons(Name) or LocalPlayer["state"]["Safezone"] then
			TriggerEvent("inventory:CleanWeapons",true)
		end

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeWeaponHands()
	if not StoreWeapon then
		StoreWeapon = true

		local Last = Weapon
		local Ped = PlayerPedId()
		LocalPlayer["state"]:set("Cancel",true,true)

		if not IsPedInAnyVehicle(Ped) then
			if LoadAnim("weapons@pistol@") then
				TaskPlayAnim(Ped,"weapons@pistol@","aim_2_holster",8.0,8.0,-1,48,0,0,0,0)
			end

			Wait(450)

			ClearPedTasks(Ped)
		end

		local Ammos = GetAmmoInPedWeapon(Ped,Weapon)

		StoreWeapon = false
		LocalPlayer["state"]:set("Cancel",false,true)
		TriggerEvent("inventory:CleanWeapons",true)

		return true,Ammos,Last
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMOS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponAmmos = {
	["WEAPON_PISTOL_AMMO"] = {
		"WEAPON_PISTOL",
		"WEAPON_PISTOL_MK2",
		"WEAPON_PISTOL50",
		"WEAPON_REVOLVER",
		"WEAPON_COMBATPISTOL",
		"WEAPON_APPISTOL",
		"WEAPON_HEAVYPISTOL",
		"WEAPON_SNSPISTOL",
		"WEAPON_SNSPISTOL_MK2",
		"WEAPON_VINTAGEPISTOL"
	},
	["WEAPON_NAIL_AMMO"] = {
		"WEAPON_NAILGUN"
	},
	["WEAPON_SMG_AMMO"] = {
		"WEAPON_MICROSMG",
		"WEAPON_MINISMG",
		"WEAPON_SMG",
		"WEAPON_SMG_MK2",
		"WEAPON_GUSENBERG",
		"WEAPON_MACHINEPISTOL"
	},
	["WEAPON_RIFLE_AMMO"] = {
		"WEAPON_FNFAL",
		"WEAPON_PARAFAL",
		"WEAPON_COLTXM177",
		"WEAPON_COMPACTRIFLE",
		"WEAPON_CARBINERIFLE",
		"WEAPON_CARBINERIFLE_MK2",
		"WEAPON_BULLPUPRIFLE",
		"WEAPON_BULLPUPRIFLE_MK2",
		"WEAPON_ADVANCEDRIFLE",
		"WEAPON_ASSAULTRIFLE",
		"WEAPON_ASSAULTSMG",
		"WEAPON_ASSAULTRIFLE_MK2",
		"WEAPON_SPECIALCARBINE",
		"WEAPON_SPECIALCARBINE_MK2"
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		"WEAPON_PUMPSHOTGUN",
		"WEAPON_PUMPSHOTGUN_MK2",
		"WEAPON_SAWNOFFSHOTGUN"
	},
	["WEAPON_MUSKET_AMMO"] = {
		"WEAPON_MUSKET"
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		"WEAPON_PETROLCAN"
	},
	["WEAPON_RPG_AMMO"] = {
		"WEAPON_RPG"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGECHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.rechargeCheck(ammoType)
	local weaponAmmo = 0
	local weaponHash = nil
	local Ped = PlayerPedId()
	local weaponStatus = false

	if weaponAmmos[ammoType] then
		weaponAmmo = GetAmmoInPedWeapon(Ped,Weapon)

		for _,v in pairs(weaponAmmos[ammoType]) do
			if Weapon == v then
				weaponHash = Weapon
				weaponStatus = true
				break
			end
		end
	end

	return weaponStatus,weaponHash,weaponAmmo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.rechargeWeapon(Hash,Ammo)
	AddAmmoToPed(PlayerPedId(),Hash,Ammo)
	Actived = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOREWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Actived and Weapon ~= "" then
			TimeDistance = 10

			local Ped = PlayerPedId()
			local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

			if GetGameTimer() >= Reloaded and IsPedReloading(Ped) then
				vSERVER.preventWeapon(Weapon,Ammo)
				Reloaded = GetGameTimer() + 100
			end

			if Ammo <= 0 or (Weapon == "WEAPON_PETROLCAN" and Ammo <= 135 and IsPedShooting(Ped)) or IsPedSwimming(Ped) then
				if Types ~= "" then
					vSERVER.removeThrowing(Types)
				else
					vSERVER.preventWeapon(Weapon,Ammo)
				end

				TriggerEvent("inventory:CleanWeapons",true)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKFOUNTAIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkFountain()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	if DoesObjectOfTypeExistAtCoords(Coords,0.7,GetHashKey("prop_watercooler"),true) or DoesObjectOfTypeExistAtCoords(Coords,0.7,GetHashKey("prop_watercooler_dark"),true) then
		return true,"fountain"
	end

	if IsEntityInWater(Ped) then
		return true,"floor"
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADRELOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local AdreLocates = {
	{ -471.94,6287.48,14.63,4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADREDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AdreDistance()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	for k,v in pairs(AdreLocates) do
		local Distance = #(Coords - vec3(v[1],v[2],v[3]))
		if Distance <= v[4] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
local Firecracker = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkCracker()
	return GetGameTimer() <= Firecracker and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Firecracker")
AddEventHandler("inventory:Firecracker",function()
	if LoadPtfxAsset("scr_indep_fireworks") then
		Firecracker = GetGameTimer() + (5 * 60000)

		local Explosive = 25
		local Ped = PlayerPedId()
		local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.6,0.0)
		local Progression,Network = vRPS.CreateObject("ind_prop_firework_03",Coords["x"],Coords["y"],Coords["z"])
		if Progression then
			local Entity = LoadNetwork(Network)
			if Entity then
				FreezeEntityPosition(Entity,true)
				PlaceObjectOnGroundProperly(Entity)
				SetModelAsNoLongerNeeded("ind_prop_firework_03")
			end

			Wait(8000)

			repeat
				Wait(2000)
				Explosive = Explosive - 1
				UseParticleFxAssetNextCall("scr_indep_fireworks")
				StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",Coords["x"],Coords["y"],Coords["z"],0.0,0.0,0.0,2.5,false,false,false,false)
			until Explosive <= 0

			TriggerServerEvent("DeleteObject",Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWATER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkWater()
	return IsEntityInWater(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropItem",function(Data,Callback)
	if MumbleIsConnected() and not TakeWeapon and not StoreWeapon then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local _,CoordsZ = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

		vSERVER.Drops(Data["item"],Data["slot"],Data["amount"],Coords["x"],Coords["y"],CoordsZ)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Table")
AddEventHandler("drops:Table",function(Table)
	Drops = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:ADICIONAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Adicionar")
AddEventHandler("drops:Adicionar",function(Number,Table)
	Drops[Number] = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Remover")
AddEventHandler("drops:Remover",function(Number)
	if Drops[Number] then
		Drops[Number] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:ATUALIZAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Atualizar")
AddEventHandler("drops:Atualizar",function(Number,Amount)
	if Drops[Number] then
		Drops[Number]["amount"] = Amount
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROP
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for _,v in pairs(Drops) do
				if #(Coords - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3])) <= 50 then
					TimeDistance = 1
					DrawMarker(21,v["Coords"][1],v["Coords"][2],v["Coords"][3] + 0.25,0.0,0.0,0.0,0.0,180.0,0.0,0.25,0.35,0.25,65,130,226,100,0,0,0,1)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestInventory",function(Data,Callback)
	local Items = {}

	if LocalPlayer["state"]["Route"] < 900000 then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local _,CoordsZ = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

		for Index,v in pairs(Drops) do
			if #(vec3(Coords["x"],Coords["y"],CoordsZ) - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3])) <= 0.9 then
				local Number = #Items + 1

				Items[Number] = v
				Items[Number]["id"] = Index
			end
		end
	end

	local inventario,invPeso,invMaxpeso = vSERVER.requestInventory()
	if inventario then
		Callback({ inventario = inventario, drop = Items, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupItem",function(Data,Callback)
	vSERVER.Pickup(Data["id"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.wheelChair(Plate)
	local Ped = PlayerPedId()
	local heading = GetEntityHeading(Ped)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.75,0.0)
	local myVehicle = vGARAGE.ServerVehicle("wheelchair",Coords["x"],Coords["y"],Coords["z"],heading,Plate,0,nil,1000)

	if NetworkDoesNetworkIdExist(myVehicle) then
		local vehicleNet = NetToEnt(myVehicle)
		if NetworkDoesNetworkIdExist(vehicleNet) then
			SetVehicleOnGroundProperly(vehicleNet)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELTREADS
-----------------------------------------------------------------------------------------------------------------------------------------
local Wheelchair = false
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			local Model = GetEntityModel(Vehicle)
			if Model == -1178021069 then
				if not IsEntityPlayingAnim(Ped,"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester",3) then
					vRP.playAnim(true,{"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester"},true)
					Wheelchair = true
				end
			end
		else
			if Wheelchair then
				vRP.Destroy("one")
				Wheelchair = false
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARISCANNER
-----------------------------------------------------------------------------------------------------------------------------------------
local scanTable = {}
local initSounds = {}
local SoundScanner = 999
local InitScanner = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCANCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local scanCoords = {
	{ -1811.94,-968.5,1.72,357.17 },
	{ -1788.29,-958.0,3.35,328.82 },
	{ -1756.9,-942.98,6.91,311.82 },
	{ -1759.97,-910.12,7.58,334.49 },
	{ -1791.44,-904.11,5.12,39.69 },
	{ -1827.87,-900.32,2.48,68.04 },
	{ -1840.76,-882.39,2.81,51.03 },
	{ -1793.4,-819.9,7.73,328.82 },
	{ -1737.69,-791.3,9.44,317.49 },
	{ -1714.6,-784.61,9.82,306.15 },
	{ -1735.88,-757.92,10.11,2.84 },
	{ -1763.22,-764.65,9.49,65.2 },
	{ -1786.23,-782.4,8.71,99.22 },
	{ -1809.5,-798.29,7.89,104.89 },
	{ -1816.35,-827.68,6.44,141.74 },
	{ -1833.23,-856.58,3.52,147.41 },
	{ -1842.88,-869.45,2.98,144.57 },
	{ -1865.34,-858.4,2.12,99.22 },
	{ -1868.01,-835.58,3.0,51.03 },
	{ -1860.76,-810.59,4.04,8.51 },
	{ -1848.85,-790.99,6.3,348.67 },
	{ -1834.31,-767.03,8.17,337.33 },
	{ -1819.3,-742.04,8.85,331.66 },
	{ -1804.76,-713.39,9.76,331.66 },
	{ -1805.32,-695.22,10.23,348.67 },
	{ -1824.32,-685.97,10.23,36.86 },
	{ -1849.16,-699.25,9.45,85.04 },
	{ -1868.9,-716.3,8.86,110.56 },
	{ -1890.07,-736.57,6.27,124.73 },
	{ -1909.8,-759.44,3.52,130.4 },
	{ -1920.19,-782.25,2.8,144.57 },
	{ -1939.84,-765.34,1.99,85.04 },
	{ -1932.96,-746.47,3.05,8.51 },
	{ -1954.69,-722.8,3.03,28.35 },
	{ -1954.53,-688.85,4.06,11.34 },
	{ -1939.8,-651.94,8.74,351.5 },
	{ -1926.48,-627.37,10.67,348.67 },
	{ -1920.73,-615.67,10.95,340.16 },
	{ -1924.48,-596.03,11.56,51.03 },
	{ -1952.53,-597.0,11.02,70.87 },
	{ -1972.12,-609.32,8.73,102.05 },
	{ -1989.01,-629.48,5.21,124.73 },
	{ -2002.97,-659.48,3.03,141.74 },
	{ -2028.03,-658.61,1.82,107.72 },
	{ -2045.57,-637.91,2.02,65.2 },
	{ -2031.42,-618.65,3.23,0.0 },
	{ -2003.74,-603.38,6.3,328.82 },
	{ -1982.79,-588.43,10.01,317.49 },
	{ -1968.4,-565.72,11.42,323.15 },
	{ -1980.98,-545.43,11.58,5.67 },
	{ -1996.36,-552.72,11.68,17.01 },
	{ -2013.33,-573.78,8.95,102.05 },
	{ -2030.05,-604.62,3.93,133.23 },
	{ -2035.79,-626.99,3.0,150.24 },
	{ -2053.05,-626.67,2.31,113.39 },
	{ -2062.58,-596.05,3.03,45.36 },
	{ -2096.8,-579.13,2.75,53.86 },
	{ -2116.49,-559.09,2.29,48.19 },
	{ -2093.8,-539.57,3.74,22.68 },
	{ -2067.11,-526.37,6.98,328.82 },
	{ -2049.71,-516.4,9.13,308.98 },
	{ -2029.87,-507.17,11.49,300.48 },
	{ -2049.27,-492.94,11.17,11.34 },
	{ -2073.38,-483.05,9.13,42.52 },
	{ -2102.99,-470.71,6.52,56.7 },
	{ -2119.62,-451.87,6.67,48.19 },
	{ -2134.43,-460.37,5.24,93.55 },
	{ -1805.06,-936.1,2.53,189.93 },
	{ -1786.4,-932.99,4.38,269.3},
	{ -1744.87,-926.96,7.65,269.3 },
	{ -1763.18,-925.72,6.99,104.89 },
	{ -1773.65,-895.76,7.35,357.17 },
	{ -1750.28,-883.7,7.75,277.8 },
	{ -1733.24,-862.29,8.17,311.82 },
	{ -1703.01,-838.56,9.03,300.48 },
	{ -1720.85,-834.19,8.95,31.19 },
	{ -1747.12,-839.86,8.39,138.9 },
	{ -1764.27,-856.95,7.75,147.41 },
	{ -1776.27,-868.44,7.78,119.06 },
	{ -1803.86,-872.72,5.34,93.55 },
	{ -1744.12,-901.55,7.7,79.38 },
	{ -1765.09,-808.12,8.58,31.19 },
	{ -1773.17,-728.07,10.01,8.51 },
	{ -1849.14,-729.09,8.85,136.07 },
	{ -1866.65,-758.66,6.96,150.24 },
	{ -1886.42,-794.12,3.25,158.75 },
	{ -1795.97,-748.07,9.17,297.64 },
	{ -1915.8,-682.79,8.0,62.37 },
	{ -1911.86,-651.71,10.26,0.0 },
	{ -1899.29,-623.49,11.34,345.83 },
	{ -1847.11,-670.69,10.45,17.01 },
	{ -1874.69,-647.34,10.92,39.69 },
	{ -1958.9,-629.78,8.34,73.71 },
	{ -1951.39,-575.59,11.53,343.0 },
	{ -1991.28,-569.55,10.72,164.41 },
	{ -2056.68,-569.32,4.57,99.22 },
	{ -2088.29,-560.62,3.27,87.88 },
	{ -2042.45,-542.51,8.46,308.98 },
	{ -2020.91,-528.58,11.12,306.15 },
	{ -2092.91,-499.58,5.37,79.38 },
	{ -2113.6,-521.59,2.27,147.41 },
	{ -2139.09,-496.06,2.27,48.19 },
	{ -2122.44,-486.23,3.56,280.63 },
	{ -2034.27,-577.42,6.74,294.81 },
	{ -2003.72,-536.62,11.78,320.32 },
	{ -2023.41,-551.31,9.59,255.12 },
	{ -2014.0,-626.04,3.76,189.93 },
	{ -1967.67,-656.53,5.24,255.12 },
	{ -1878.77,-672.36,9.76,257.96 },
	{ -1827.96,-702.26,9.67,240.95 },
	{ -1855.87,-771.67,6.94,164.41 },
	{ -1846.08,-830.98,3.79,175.75 },
	{ -1830.72,-804.5,6.67,334.49 },
	{ -1770.76,-835.92,7.84,311.82 },
	{ -1724.61,-812.2,9.25,303.31 },
	{ -1828.9,-719.11,9.3,65.2 },
	{ -1893.81,-707.65,7.73,110.56 },
	{ -1921.84,-716.82,5.22,212.6 },
	{ -1891.7,-756.03,4.95,218.27 },
	{ -1890.51,-818.0,2.95,303.31 },
	{ -1806.69,-770.32,8.29,306.15 },
	{ -1763.57,-747.01,9.81,303.31 },
	{ -1980.27,-691.34,3.02,189.93 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:UPDATESCANNER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:updateScanner")
AddEventHandler("inventory:updateScanner",function(Status)
	InitScanner = Status
	SoundScanner = 999
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSCANNER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if InitScanner then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for k,v in pairs(scanTable) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 7.25 then
						SoundScanner = 1000

						if not initSounds[k] then
							initSounds[k] = true
						end

						if Distance <= 1.25 then
							TimeDistance = 1
							SoundScanner = 250

							if IsControlJustPressed(1,38) then
								TriggerEvent("inventory:MakeProducts","scanner")

								local rand = math.random(#scanCoords)
								scanTable[k] = scanCoords[rand]
								initSounds[k] = nil
								SoundScanner = 999
							end
						end
					else
						if initSounds[k] then
							initSounds[k] = nil
							SoundScanner = 999
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSCANNERSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if InitScanner and (SoundScanner == 1000 or SoundScanner == 250) then
			PlaySoundFrontend(-1,"MP_IDLE_TIMER","HUD_FRONTEND_DEFAULT_SOUNDSET")
		end

		Wait(SoundScanner)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLODETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:explodeTyres")
AddEventHandler("inventory:explodeTyres",function(Network,Plate,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local TyreList = {
	["wheel_lf"] = 0,
	["wheel_rf"] = 1,
	["wheel_lm"] = 2,
	["wheel_rm"] = 3,
	["wheel_lr"] = 4,
	["wheel_rr"] = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.tyreStatus()
	local Ped = PlayerPedId()
	if not IsPedInAnyVehicle(Ped) then
		local Vehicle = vRP.ClosestVehicle(7)
		if IsEntityAVehicle(Vehicle) then
			local Coords = GetEntityCoords(Ped)

			for Index,Tyre in pairs(TyreList) do
				local Selected = GetEntityBoneIndexByName(Vehicle,Index)
				if Selected ~= -1 then
					local CoordsWheel = GetWorldPositionOfEntityBone(Vehicle,Selected)
					if #(Coords - CoordsWheel) <= 1.0 then
						return true,Tyre,VehToNet(Vehicle),GetVehicleNumberPlateText(Vehicle)
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.tyreHealth(Network,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			return GetTyreHealth(Vehicle,Tyre)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.objectExist(Coords,Hash)
	return DoesObjectOfTypeExistAtCoords(Coords["x"],Coords["y"],Coords["z"],0.35,Hash,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM
-----------------------------------------------------------------------------------------------------------------------------------------
local Atm = {
	["1"] = vec3(121.17,-3019.62,7.04),
	["2"] = vec3(797.69,-767.52,26.77),
	["3"] = vec3(-1431.17,-447.73,35.91),
	["4"] = vec3(168.55,6636.81,31.69),
	["5"] = vec3(-32.08,-1104.32,27.26),
	["6"] = vec3(228.18,338.4,105.56),
	["7"] = vec3(158.63,234.22,106.63),
	["8"] = vec3(-57.67,-92.62,57.78),
	["9"] = vec3(356.97,173.54,103.07),
	["10"] = vec3(-1415.94,-212.03,46.51),
	["11"] = vec3(-1430.2,-211.08,46.51),
	["12"] = vec3(-1282.54,-210.9,42.44),
	["13"] = vec3(-1286.25,-213.44,42.44),
	["14"] = vec3(-1289.32,-226.82,42.44),
	["15"] = vec3(-1285.58,-224.28,42.44),
	["16"] = vec3(-1109.8,-1690.82,4.36),
	["17"] = vec3(1686.85,4815.82,42.01),
	["18"] = vec3(1701.21,6426.57,32.76),
	["19"] = vec3(1171.56,2702.58,38.16),
	["20"] = vec3(1172.5,2702.59,38.16),
	["21"] = vec3(-1091.49,2708.66,18.96),
	["22"] = vec3(-3144.38,1127.6,20.86),
	["23"] = vec3(527.36,-160.69,57.09),
	["24"] = vec3(285.45,143.39,104.17),
	["25"] = vec3(-846.27,-341.28,38.67),
	["26"] = vec3(-846.85,-340.2,38.67),
	["27"] = vec3(-721.06,-415.56,34.98),
	["28"] = vec3(-1410.34,-98.75,52.42),
	["29"] = vec3(-1409.78,-100.49,52.39),
	["30"] = vec3(-712.9,-818.92,23.72),
	["31"] = vec3(-710.05,-818.9,23.72),
	["32"] = vec3(-660.71,-854.07,24.48),
	["33"] = vec3(-594.58,-1161.29,22.33),
	["34"] = vec3(-596.09,-1161.28,22.33),
	["35"] = vec3(-821.64,-1081.91,11.12),
	["36"] = vec3(155.93,6642.86,31.59),
	["37"] = vec3(174.14,6637.94,31.58),
	["38"] = vec3(-283.01,6226.11,31.49),
	["39"] = vec3(-95.55,6457.19,31.46),
	["40"] = vec3(-97.3,6455.48,31.46),
	["41"] = vec3(-132.93,6366.52,31.48),
	["42"] = vec3(-386.74,6046.08,31.49),
	["43"] = vec3(24.47,-945.96,29.35),
	["44"] = vec3(5.24,-919.83,29.55),
	["45"] = vec3(295.77,-896.1,29.22),
	["46"] = vec3(296.47,-894.21,29.23),
	["47"] = vec3(1138.22,-468.93,66.73),
	["48"] = vec3(1166.97,-456.06,66.79),
	["49"] = vec3(1077.75,-776.54,58.23),
	["50"] = vec3(289.1,-1256.8,29.44),
	["51"] = vec3(288.81,-1282.37,29.64),
	["52"] = vec3(-1571.05,-547.38,34.95),
	["53"] = vec3(-1570.12,-546.72,34.95),
	["54"] = vec3(-1305.4,-706.41,25.33),
	["55"] = vec3(-2072.36,-317.28,13.31),
	["56"] = vec3(-2295.48,358.13,174.6),
	["57"] = vec3(-2294.7,356.46,174.6),
	["58"] = vec3(-2293.92,354.8,174.6),
	["59"] = vec3(2558.75,351.01,108.61),
	["60"] = vec3(89.69,2.47,68.29),
	["61"] = vec3(-866.69,-187.75,37.84),
	["62"] = vec3(-867.62,-186.09,37.84),
	["63"] = vec3(-618.22,-708.89,30.04),
	["64"] = vec3(-618.23,-706.89,30.04),
	["65"] = vec3(-614.58,-704.83,31.24),
	["66"] = vec3(-611.93,-704.83,31.24),
	["67"] = vec3(-537.82,-854.49,29.28),
	["68"] = vec3(-526.62,-1222.98,18.45),
	["69"] = vec3(-165.15,232.7,94.91),
	["70"] = vec3(-165.17,234.78,94.91),
	["71"] = vec3(-303.25,-829.74,32.42),
	["72"] = vec3(-301.7,-830.01,32.42),
	["73"] = vec3(-203.81,-861.37,30.26),
	["74"] = vec3(119.06,-883.72,31.12),
	["75"] = vec3(112.58,-819.4,31.34),
	["76"] = vec3(111.26,-775.25,31.44),
	["77"] = vec3(114.43,-776.38,31.41),
	["78"] = vec3(-256.23,-715.99,33.53),
	["79"] = vec3(-258.87,-723.38,33.48),
	["80"] = vec3(-254.42,-692.49,33.6),
	["81"] = vec3(-28.0,-724.52,44.23),
	["82"] = vec3(-30.23,-723.69,44.23),
	["83"] = vec3(-1315.75,-834.69,16.95),
	["84"] = vec3(-1314.81,-835.96,16.95),
	["85"] = vec3(-2956.86,487.64,15.47),
	["86"] = vec3(-2958.98,487.73,15.47),
	["87"] = vec3(-3043.97,592.42,7.9),
	["88"] = vec3(-3241.17,997.6,12.55),
	["89"] = vec3(-1205.78,-324.79,37.86),
	["90"] = vec3(-1205.02,-326.3,37.84),
	["91"] = vec3(147.58,-1035.77,29.34),
	["92"] = vec3(146.0,-1035.17,29.34),
	["93"] = vec3(33.55,-1345.0,29.49),
	["94"] = vec3(2555.28,389.99,108.61),
	["95"] = vec3(1153.65,-326.78,69.2),
	["96"] = vec3(-717.71,-915.66,19.21),
	["97"] = vec3(-56.98,-1752.09,29.42),
	["98"] = vec3(381.93,326.43,103.56),
	["99"] = vec3(-3243.78,1009.24,12.82),
	["100"] = vec3(1737.02,6413.25,35.03),
	["101"] = vec3(540.4,2667.86,42.16),
	["102"] = vec3(1966.81,3746.52,32.33),
	["103"] = vec3(2680.45,3288.48,55.23),
	["104"] = vec3(1703.0,4933.6,42.06),
	["105"] = vec3(-1827.3,784.88,138.3),
	["106"] = vec3(-3043.91,592.48,7.9),
	["107"] = vec3(238.61,212.44,106.27),
	["108"] = vec3(239.06,213.67,106.27),
	["109"] = vec3(239.5,214.88,106.27),
	["110"] = vec3(239.94,216.15,106.27),
	["111"] = vec3(241.01,219.02,106.27),
	["112"] = vec3(241.43,220.24,106.27),
	["113"] = vec3(241.89,221.49,106.27),
	["114"] = vec3(242.35,222.7,106.27),
	["115"] = vec3(264.02,203.62,106.27),
	["116"] = vec3(264.48,204.89,106.27),
	["117"] = vec3(264.94,206.14,106.27),
	["118"] = vec3(265.38,207.34,106.27),
	["119"] = vec3(126.82,-1296.6,29.27),
	["120"] = vec3(127.81,-1296.03,29.27),
	["121"] = vec3(-248.04,6327.51,32.42),
	["122"] = vec3(315.09,-593.68,43.29),
	["123"] = vec3(-677.36,5834.58,17.32),
	["124"] = vec3(472.3,-1001.57,30.68),
	["125"] = vec3(468.52,-990.55,26.27),
	["126"] = vec3(349.86,-594.51,28.8),
	["127"] = vec3(2564.5,2584.79,38.08),
	["128"] = vec3(-1200.76,-885.44,13.26),
	["129"] = vec3(821.54,-780.27,26.17),
	["130"] = vec3(-1243.12,-1455.52,4.31),
	["131"] = vec3(-1242.01,-1454.75,4.31),
	["132"] = vec3(-1240.89,-1453.96,4.31),
	["133"] = vec3(822.93,-825.94,26.32),
	["134"] = vec3(961.42,41.48,71.7)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Atm(Coords)
	local Select = false
	local BombZone = false

	for Number,v in pairs(Atm) do
		if #(Coords - v) <= 1.0 then
			BombZone = vec3(v["x"],v["y"],v["z"] - 1)
			Select = Number
			break
		end
	end

	return BombZone,Select
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKARMS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckArms()
	return exports["paramedic"]:Arms()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local disSelect = 1
local disPlate = nil
local disModel = nil
local disActive = false
local disVehicle = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Dismantles = {
	vec4(2055.47,3179.24,44.97,59.53),
	vec4(2175.76,3499.56,45.17,340.16),
	vec4(2480.51,3829.97,39.92,85.04),
	vec4(2467.19,4106.69,37.86,337.33),
	vec4(2505.29,4214.18,39.73,144.57),
	vec4(2637.09,4246.96,44.62,314.65),
	vec4(2588.58,4664.46,33.88,317.49),
	vec4(2142.51,4783.96,40.78,25.52),
	vec4(2011.63,4970.06,41.37,116.23),
	vec4(1665.84,4970.69,42.07,133.23),
	vec4(1728.26,4772.97,41.65,0.0),
	vec4(1342.81,4309.73,37.79,167.25),
	vec4(736.69,4176.68,40.52,345.83),
	vec4(17.36,3685.17,39.5,291.97),
	vec4(472.46,3568.16,33.04,167.25),
	vec4(899.0,3579.55,33.18,0.0),
	vec4(1272.59,3621.74,32.86,107.72),
	vec4(1484.0,3751.71,33.58,212.6),
	vec4(1704.33,3765.01,34.17,317.49),
	vec4(1963.98,3834.32,31.81,209.77),
	vec4(1959.72,3764.37,32.0,28.35),
	vec4(1127.61,2647.57,37.79,0.0),
	vec4(970.73,2724.43,39.29,348.67),
	vec4(565.84,2719.71,41.87,2.84),
	vec4(466.12,2591.94,43.08,11.34),
	vec4(262.59,2581.57,44.74,99.22),
	vec4(-448.95,2865.45,35.64,124.73),
	vec4(-1159.67,2674.09,17.89,221.11),
	vec4(-1906.89,2008.71,141.39,272.13),
	vec4(-2530.33,2347.3,32.86,212.6),
	vec4(-2308.52,3271.63,32.64,59.53),
	vec4(-2078.14,2818.11,32.62,266.46),
	vec4(-2283.83,4269.35,43.89,238.12),
	vec4(-1051.88,5322.76,44.96,297.64),
	vec4(-579.04,5370.35,70.16,252.29),
	vec4(-743.45,5536.11,33.3,28.35),
	vec4(-674.75,5779.26,17.14,62.37),
	vec4(-480.18,6260.08,12.92,246.62),
	vec4(-202.91,6570.24,10.78,223.94),
	vec4(-82.87,6561.1,31.29,223.94),
	vec4(435.01,6534.1,27.72,87.88),
	vec4(1579.31,6449.85,24.84,153.08),
	vec4(3321.63,5141.53,18.16,99.22),
	vec4(2866.44,4729.55,48.54,195.6),
	vec4(2949.8,4642.16,48.34,226.78),
	vec4(3002.34,4113.8,57.12,172.92),
	vec4(2976.39,3485.07,71.24,138.9),
	vec4(3511.77,3783.87,29.74,167.25)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLECATEGORY
-----------------------------------------------------------------------------------------------------------------------------------------
local DismantleCategory = {
	["B"] = {
		"prairie","rhapsody","blista","emperor2","emperor","bfinjection","ingot","regina","asea","asterope","bison",
		"bobcatxl","bodhi2","brawler","brioso2","asbo","voodoo","rancherxl","buffalo"
	},
	["B+"] = {
		"brioso","club","weevil","felon","felon2","jackal","oracle","zion","zion2","buccaneer","virgo","blista3",
		"bifta","bjxl","cavalcade","gresley","habanero","rocoto","primo","stratum","blista2","exemplar",
		"peyote","manana","streiter","gt500","toros","clique","windsor","rebel"
	},
	["A"] = {
		"windsor2","blade","dominator","faction2","gauntlet","moonbeam","nightshade","caracara2","contender","sheava",
		"sabregt2","tampa","vagrant","baller","baller2","baller3","baller4","cavalcade2","fq2","huntley","landstalker","patriot","radi","xls",
		"retinue","stingergt","surano","specter","sultan","schwarzer","schafter2","ruston","rapidgt","raiden","ninef",
		"ninef2","omnis","massacro","jester","feltzer2","futo","banshee","banshee2","adder","alpha","tyrus"
	},
	["A+"] = {
		"voltic","sc1","sultanrs","tempesta","nero","nero2","reaper","gp1","infernus","bullet","turismo2","carbonizzare","retinue",
		"mamba","infernus2","feltzer3","coquette2","futo2","zr350","tampa2","sugoi","sultan2","schlagen","penumbra","pariah","flashgt",
		"paragon","jester3","gb200","elegy","furoregt","bestiagts","penumbra2","pfister811","tyrant"
	},
	["S"] = {
		"zentorno","xa21","visione","vagner","vacca","turismor","t20","osiris","italigtb","entityxf","cheetah","autarch","sultan3","dominator7",
		"cypher","vectre","growler","comet6","jester4","euros","calico","neon","kuruma","issi7","italigto","komoda","elegy2","coquette4","entity2",
		"furia","italirsx","krieger","rr14","tigon","zorrusso","6str","delsoleg","revolution6str2"
	},
	["S+"] = {
		"22m5","69charger","488misha","675ltsp","a45amg","a80","acs8","ap2","bc","bdragon","bolide","bt62r","c7","chiron17",
		"contss18","cp9a","dc5","demon","e36prb","evo9","exor","filthynsx","fk8","fnf4r34","fnfrx7","granlb","gt63","gt86","gtrc",
		"kiagt","laferrari17","lc500","lfa","lp670","lp700","m3e46","m4","m5e60","maj350z","na1","por930","r8v10","r32","r35",
		"s30","senna","starone","tsgr20","veln","victor","vulcan"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismantle(Experience)
	if not disActive then
		disActive = true
		disSelect = math.random(#Dismantles)
		disPlate = "DISM"..(1000 + LocalPlayer["state"]["Passport"])

		local Category = ClassCategory(Experience)
		local ModelRandom = math.random(#DismantleCategory[Category])
		disModel = DismantleCategory[Category][ModelRandom]

		TriggerEvent("NotifyPush",{ code = 20, title = "Localização do Veículo", x = Dismantles[disSelect]["x"], y = Dismantles[disSelect]["y"], z = Dismantles[disSelect]["z"], vehicle = VehicleName(disModel), blipColor = 60 })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DismantleStatus()
	return disActive
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Disreset")
AddEventHandler("inventory:Disreset",function()
	disSelect = 1
	disPlate = nil
	disModel = nil
	disActive = false
	disVehicle = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if disActive and not disVehicle then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			local Distance = #(Coords - vec3(Dismantles[disSelect][1],Dismantles[disSelect][2],Dismantles[disSelect][3]))

			if Distance <= 125 then
				disVehicle = vGARAGE.ServerVehicle(disModel,Dismantles[disSelect][1],Dismantles[disSelect][2],Dismantles[disSelect][3],Dismantles[disSelect][4],disPlate,1000,nil,1000)

				if NetworkDoesNetworkIdExist(disVehicle) then
					local Network = NetToEnt(disVehicle)
					if NetworkDoesNetworkIdExist(Network) then
						SetVehicleOnGroundProperly(Network)
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local disPeds = {
	"ig_abigail","a_m_m_afriamer_01","ig_mp_agent14","csb_agent","ig_amandatownley","s_m_y_ammucity_01","u_m_y_antonb","g_m_m_armboss_01",
	"g_m_m_armgoon_01","g_m_m_armlieut_01","ig_ashley","s_m_m_autoshop_01","ig_money","g_m_y_ballaeast_01","g_f_y_ballas_01","g_m_y_ballasout_01",
	"s_m_y_barman_01","u_m_y_baygor","a_m_o_beach_01","ig_bestmen","a_f_y_bevhills_01","a_m_m_bevhills_02","u_m_m_bikehire_01","u_f_y_bikerchic",
	"mp_f_boatstaff_01","s_m_m_bouncer_01","ig_brad","ig_bride","u_m_y_burgerdrug_01","a_m_m_business_01","a_m_y_business_02","s_m_o_busker_01",
	"ig_car3guy2","cs_carbuyer","g_m_m_chiboss_01","g_m_m_chigoon_01","g_m_m_chigoon_02","u_f_y_comjane","ig_dale","ig_davenorton","s_m_y_dealer_01",
	"ig_denise","ig_devin","a_m_y_dhill_01","ig_dom","a_m_y_downtown_01","ig_dreyfuss"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local disWeapons = { "WEAPON_HEAVYPISTOL","WEAPON_SMG","WEAPON_ASSAULTSMG","WEAPON_APPISTOL","WEAPON_SPECIALCARBINE","WEAPON_PUMPSHOTGUN" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:DisPed")
AddEventHandler("inventory:DisPed",function()
local Ped = PlayerPedId()
	local Rand = math.random(#disPeds)
	local Coords = GetEntityCoords(Ped)
	local Weapon = math.random(#disWeapons)
	local cX = Coords["x"] + math.random(-25.0,25.0)
	local cY = Coords["y"] + math.random(-25.0,25.0)
	local Hit,EntCoords = GetSafeCoordForPed(cX,cY,Coords["z"],false,16)
	local Entity,EntityNet = vRPS.CreatePed(disPeds[Rand],EntCoords["x"],EntCoords["y"],EntCoords["z"],3374176,4)
	if Entity then
		Wait(1000)

		local NetEntity = LoadNetwork(EntityNet)

		SetPedArmour(NetEntity,99)
		SetPedAccuracy(NetEntity,100)
		SetPedRelationshipGroupHash(NetEntity,GetHashKey("HATES_PLAYER"))
		SetPedKeepTask(NetEntity,true)
		SetCanAttackFriendly(NetEntity,false,true)
		TaskCombatPed(NetEntity,Ped,0,16)
		SetPedCombatAttributes(NetEntity,46,true)
		SetPedCombatAbility(NetEntity,0)
		SetPedCombatAttributes(NetEntity,0,true)
		GiveWeaponToPed(NetEntity,disWeapons[Weapon],-1,false,true)
		SetPedDropsWeaponsWhenDead(NetEntity,false)
		SetPedCombatRange(NetEntity,2)
		SetPedFleeAttributes(NetEntity,0,0)
		SetPedConfigFlag(NetEntity,58,true)
		SetPedConfigFlag(NetEntity,75,true)
		SetPedFiringPattern(NetEntity,-957453492)
		SetBlockingOfNonTemporaryEvents(NetEntity,true)

		SetModelAsNoLongerNeeded(disPeds[Rand])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local WeaObjects = {}
local WeaConfig = {
	["WEAPON_KATANA"] = {
		["Bone"] = 24818,
		["x"] = 0.32,
		["y"] = -0.15,
		["z"] = 0.20,
		["RotX"] = -30.0,
		["RotY"] = -225.0,
		["RotZ"] = 205.0,
		["Model"] = "w_me_katana"
	},
	["WEAPON_COLTXM177"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_coltxm177"
	},
	["WEAPON_CARBINERIFLE"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_carbinerifle"
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_carbineriflemk2"
	},
	["WEAPON_ADVANCEDRIFLE"] = {
		["Bone"] = 24818,
		["x"] = 0.02,
		["y"] = -0.14,
		["z"] = -0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_advancedrifle"
	},
	["WEAPON_BULLPUPRIFLE"] = {
		["Bone"] = 24818,
		["x"] = 0.02,
		["y"] = -0.14,
		["z"] = -0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_bullpuprifle"
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.02,
		["y"] = -0.14,
		["z"] = -0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_bullpupriflemk2"
	},
	["WEAPON_SPECIALCARBINE"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_specialcarbine"
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_specialcarbinemk2"
	},
	["WEAPON_PARAFAL"] = {
		["Bone"] = 24818,
		["x"] = 0.0,
		["y"] = -0.14,
		["z"] = -0.12,
		["RotX"] = 0.0,
		["RotY"] = 360.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_parafal"
	},
	["WEAPON_FNFAL"] = {
		["Bone"] = 24818,
		["x"] = 0.0,
		["y"] = -0.14,
		["z"] = 0.12,
		["RotX"] = 180.0,
		["RotY"] = 360.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_fnfal"
	},
	["WEAPON_MUSKET"] = {
		["Bone"] = 24818,
		["x"] = -0.1,
		["y"] = -0.14,
		["z"] = 0.0,
		["RotX"] = 0.0,
		["RotY"] = 0.8,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_musket"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.08,
		["RotX"] = 0.0,
		["RotY"] = 180.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sg_pumpshotgun"
	},
	["WEAPON_PUMPSHOTGUN_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.08,
		["RotX"] = 0.0,
		["RotY"] = 180.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sg_pumpshotgunmk2"
	},
	["WEAPON_SMG"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sb_smg"
	},
	["WEAPON_SMG_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.22,
		["y"] = -0.14,
		["z"] = 0.12,
		["RotX"] = 0.0,
		["RotY"] = 180.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sb_smgmk2"
	},
	["WEAPON_COMPACTRIFLE"] = {
		["Bone"] = 24818,
		["x"] = 0.22,
		["y"] = -0.14,
		["z"] = 0.12,
		["RotX"] = 0.0,
		["RotY"] = 180.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_assaultrifle_smg"
	},
	["WEAPON_ASSAULTSMG"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = -0.07,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sb_assaultsmg"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		["Bone"] = 24818,
		["x"] = 0.08,
		["y"] = -0.14,
		["z"] = 0.08,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_assaultrifle"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		["Bone"] = 24818,
		["x"] = 0.08,
		["y"] = -0.14,
		["z"] = 0.08,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_ar_assaultrifle"
	},
	["WEAPON_GUSENBERG"] = {
		["Bone"] = 24818,
		["x"] = 0.12,
		["y"] = -0.14,
		["z"] = 0.04,
		["RotX"] = 0.0,
		["RotY"] = 135.0,
		["RotZ"] = 5.0,
		["Model"] = "w_sb_gusenberg"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RemoveWeapon")
AddEventHandler("inventory:RemoveWeapon",function(Item)
	local Split = splitString(Item,"-")
	local Name = Split[1]

	if WeaObjects[Name] then
		TriggerServerEvent("DeleteObject",0,Name)
		WeaObjects[Name] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CREATEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:CreateWeapon")
AddEventHandler("inventory:CreateWeapon",function(Item)
	local Split = splitString(Item,"-")
	local Name = Split[1]

	if not WeaObjects[Name] and WeaConfig[Name] then
		local Ped = PlayerPedId()
		local Config = WeaConfig[Name]
		local Coords = GetEntityCoords(Ped)
		local Bone = GetPedBoneIndex(Ped,Config["Bone"])

		local Progression,Network = vRPS.CreateObject(Config["Model"],Coords["x"],Coords["y"],Coords["z"],Name)
		if Progression then
			WeaObjects[Name] = LoadNetwork(Network)
			AttachEntityToEntity(WeaObjects[Name],Ped,Bone,Config["x"],Config["y"],Config["z"],Config["RotX"],Config["RotY"],Config["RotZ"],false,false,false,false,2,true)
			SetEntityCompletelyDisableCollision(WeaObjects[Name],false,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckMods(Vehicle,Mod)
	return GetNumVehicleMods(Vehicle,Mod) - 1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckCar(Vehicle)
	local Model = GetEntityModel(Vehicle)
	return IsThisModelACar(Model)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ActiveMods(Vehicle,Plate,Mod,Number)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleMod(Vehicle,Mod,Number)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PIZZATHIS
-----------------------------------------------------------------------------------------------------------------------------------------
local PizzaThis = PolyZone:Create({
	vec2(793.94,-747.72),
	vec2(794.00,-768.85),
	vec2(814.90,-768.82),
	vec2(814.93,-747.62),
	vec2(812.48,-739.99),
	vec2(794.07,-740.05)
},{ name = "PizzaThis" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEANMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
local BeanMachine = PolyZone:Create({
	vec2(129.73,-1029.63),
	vec2(118.45,-1025.35),
	vec2(110.82,-1046.34),
	vec2(122.31,-1050.47)
},{ name = "BeanMachine" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- UWUCOFFEE
-----------------------------------------------------------------------------------------------------------------------------------------
local UwUCoffee = PolyZone:Create({
	vec2(-565.30,-1071.24),
	vec2(-575.38,-1070.52),
	vec2(-601.44,-1069.51),
	vec2(-601.53,-1046.78),
	vec2(-565.33,-1047.50)
},{ name = "UwUCoffee" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Restaurant(Name)
	local Return = false
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	if Name == "PizzaThis" and PizzaThis:isPointInside(Coords) then
		Return = true
	elseif Name == "BeanMachine" and BeanMachine:isPointInside(Coords) then
		Return = true
	elseif Name == "UwuCoffee" and UwUCoffee:isPointInside(Coords) then
		Return = true
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local amountCoords = 0
	repeat
		amountCoords = amountCoords + 1
		local rand = math.random(#scanCoords)
		scanTable[amountCoords] = scanCoords[rand]
		Wait(1)
	until amountCoords == 25

	for Number,v in pairs(Atm) do
		exports["target"]:AddCircleZone("Atm:"..Number,v,0.5,{
			name = "Atm:"..Number,
			heading = 3374176
		},{
			Distance = 1.0,
			options = {
				{
					event = "Bank",
					label = "Abrir",
					tunnel = "client"
				},{
					event = "player:GetCard",
					label = "Solicitar Cartão",
					tunnel = "server"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERS
-----------------------------------------------------------------------------------------------------------------------------------------
local Registers = {
	{ 24.49,-1344.99,29.49,265.0,"Sul" },
	{ 24.50,-1347.34,29.49,267.0,"Sul" },
	{ 2554.90,380.94,108.62,349.0,"Sul" },
	{ 2557.23,380.83,108.62,354.0,"Sul" },
	{ 1165.07,-324.50,69.20,127.0,"Sul" },
	{ 1164.67,-322.76,69.20,94.0,"Sul" },
	{ -706.10,-915.43,19.21,116.0,"Sul" },
	{ -706.16,-913.65,19.21,85.0,"Sul" },
	{ -47.96,-1759.34,29.42,74.0,"Sul" },
	{ -46.80,-1757.94,29.42,45.0,"Sul" },
	{ 372.58,326.39,103.56,252.0,"Sul" },
	{ 373.10,328.64,103.56,255.0,"Sul" },
	{ -3242.24,1000.01,12.83,352.0,"Sul" },
	{ -3244.56,1000.20,12.83,354.0,"Sul" },
	{ 1727.88,6415.21,35.03,239.0,"Norte" },
	{ 1728.90,6417.25,35.03,240.0,"Norte" },
	{ 549.03,2671.36,42.15,93.0,"Norte" },
	{ 549.33,2669.04,42.15,93.0,"Norte" },
	{ 1958.96,3742.01,32.34,298.0,"Norte" },
	{ 1960.12,3740.01,32.34,295.0,"Norte" },
	{ 2678.07,3279.42,55.24,327.0,"Norte" },
	{ 2676.03,3280.56,55.24,327.0,"Norte" },
	{ 1696.57,4923.95,42.06,353.0,"Norte" },
	{ 1698.06,4922.96,42.06,323.0,"Norte" },
	{ -1818.89,792.94,138.08,161.0,"Sul" },
	{ -1820.12,794.16,138.08,129.0,"Sul" },
	{ 1392.87,3606.39,34.98,195.0,"Norte" },
	{ -2966.44,390.89,15.04,84.0,"Sul" },
	{ -3038.95,584.55,7.90,16.0,"Sul" },
	{ -3041.19,583.84,7.90,14.0,"Sul" },
	{ 1134.25,-982.47,46.41,273.0,"Sul" },
	{ 1165.93,2710.77,38.15,177.0,"Norte" },
	{ -1486.29,-378.02,40.16,132.0,"Sul" },
	{ -1221.99,-908.29,12.32,28.0,"Sul" },
	{ 73.97,-1392.13,29.37,267.0,"Sul" },
	{ 74.86,-1387.70,29.37,182.0,"Sul" },
	{ 78.02,-1387.69,29.37,177.0,"Sul" },
	{ 426.96,-806.99,29.49,91.0,"Sul" },
	{ 426.08,-811.44,29.49,358.0,"Sul" },
	{ 422.91,-811.44,29.49,358.0,"Sul" },
	{ -816.56,-1073.25,11.32,122.0,"Sul" },
	{ -818.14,-1070.52,11.32,122.0,"Sul" },
	{ -822.41,-1071.94,11.32,206.0,"Sul" },
	{ -1195.24,-768.03,17.31,215.0,"Sul" },
	{ -1193.86,-767.00,17.31,215.0,"Sul" },
	{ -1192.44,-765.93,17.31,215.0,"Sul" },
	{ 5.21,6510.88,31.87,41.0,"Norte" },
	{ 1.34,6508.52,31.87,309.0,"Norte" },
	{ -0.80,6510.80,31.87,309.0,"Norte" },
	{ 1695.38,4822.23,42.06,92.0,"Norte" },
	{ 1695.10,4817.71,42.06,4.0,"Norte" },
	{ 1691.98,4817.31,42.06,4.0,"Norte" },
	{ 127.50,-222.58,54.55,70.0,"Sul" },
	{ 126.93,-224.18,54.55,70.0,"Sul" },
	{ 126.30,-225.88,54.55,70.0,"Sul" },
	{ 613.14,2760.96,42.08,273.0,"Norte" },
	{ 612.99,2762.69,42.08,273.0,"Norte" },
	{ 612.85,2764.46,42.08,273.0,"Norte" },
	{ 1197.42,2711.63,38.22,175.0,"Norte" },
	{ 1201.88,2710.74,38.22,85.0,"Norte" },
	{ 1201.87,2707.60,38.22,85.0,"Norte" },
	{ -3168.76,1044.80,20.86,65.0,"Sul" },
	{ -3169.46,1043.22,20.86,65.0,"Sul" },
	{ -3170.17,1041.60,20.86,65.0,"Sul" },
	{ -1101.80,2712.10,19.10,216.0,"Norte" },
	{ -1097.90,2714.40,19.10,125.0,"Norte" },
	{ -1095.82,2712.08,19.10,125.0,"Norte" },
	{ -821.91,-183.32,37.56,213.0,"Sul" },
	{ 134.39,-1707.83,29.29,136.0,"Sul" },
	{ -1284.26,-1115.05,6.99,89.0,"Sul" },
	{ 1930.56,3727.93,32.84,205.0,"Norte" },
	{ 1211.52,-470.31,66.20,72.0,"Sul" },
	{ -30.42,-151.77,57.07,336.0,"Sul" },
	{ -277.76,6230.73,31.69,38.0,"Norte" },
	{ -1127.19,-1439.41,5.22,303.31,"Sul" },
	{ 1594.88,6454.87,26.02,311.82,"Norte" },
	{ 1588.91,6457.69,26.02,331.66,"Norte" },
	{ 162.19,6643.24,31.69,226.78,"Norte" },
	{ 160.55,6641.6,31.69,223.94,"Norte" },
	{ -161.07,6321.37,31.58,314.65,"Norte" },
	{ 756.32,-767.39,26.34,79.38,"Sul" },
	{ -1658.98,-1061.67,12.15,51.03,"Sul" },
	{ 1951.68,3764.0,32.59,28.35,"Norte" },
	{ 1947.41,3762.53,32.59,300.48,"Norte" },
	{ 1945.81,3765.25,32.59,300.48,"Norte" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Registers) do
		exports["target"]:AddCircleZone("Register:"..Number,vec3(v[1],v[2],v[3]),0.5,{
			name = "Register:"..Number,
			heading = v[4]
		},{
			shop = Number,
			Distance = 1.0,
			options = {
				{
					event = "Register:Init",
					tunnel = "client",
					label = "Roubar"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTER:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Register:Init",function(Number)
	if vSERVER.RegistersTimers(Number) then
		SetEntityHeading(ped,Registers[Number][4])
		SetEntityCoords(ped,Registers[Number][1],Registers[Number][2],Registers[Number][3] - 1,1,0,0,0)

		local safeCraking = exports["safecrack"]:safeCraking(1)
		if safeCraking then
			vSERVER.RegistersPay(Registers[Number][5])
		end
	end
end)