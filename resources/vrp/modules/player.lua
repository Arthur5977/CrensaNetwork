-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["position"] then
			if Datatable["position"]["x"] == nil or Datatable["position"]["y"] == nil or Datatable["position"]["z"] == nil then
				Datatable["position"] = { x = SpawnCoords[1], y = SpawnCoords[2], z = SpawnCoords[3] }
			end
		else
			Datatable["position"] = { x = SpawnCoords[1], y = SpawnCoords[2], z = SpawnCoords[3] }
		end

		vRP.Teleport(source,Datatable["position"]["x"],Datatable["position"]["y"],Datatable["position"]["z"])

		if Datatable["skin"] == nil then
			Datatable["skin"] = GetHashKey("mp_m_freemode_01")
		end

		if Datatable["weight"] == nil then
			Datatable["weight"] = BackpackWeightDefault
		end

		if Datatable["inventory"] == nil then
			Datatable["inventory"] = {}
		end

		if Datatable["health"] == nil then
			Datatable["health"] = 200
		end

		if Datatable["armour"] == nil then
			Datatable["armour"] = 0
		end

		if Datatable["stress"] == nil then
			Datatable["stress"] = 0
		end

		if Datatable["hunger"] == nil then
			Datatable["hunger"] = 100
		end

		if Datatable["thirst"] == nil then
			Datatable["thirst"] = 100
		end

		if Datatable["oxigen"] == nil then
			Datatable["oxigen"] = 100
		end

		if Datatable["experience"] == nil then
			Datatable["experience"] = 0
		end

		if Datatable["permission"] then
			Datatable["permission"] = nil
		end

		vRPC.Skin(source,Datatable["skin"])
		vRP.SetArmour(source,Datatable["armour"])
		vRPC.SetHealth(source,Datatable["health"])

		TriggerClientEvent("barbershop:Apply",source,vRP.UserData(Passport,"Barbershop"))
		TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))

		if NewTattooShop then
			TriggerClientEvent("tattooshop:Apply",source,vRP.UserData(Passport,"Tatuagens"))
		else
			TriggerClientEvent("tattoos:Apply",source,vRP.UserData(Passport,"Tatuagens"))
		end

		TriggerClientEvent("hud:Stress",source,Datatable["stress"])
		TriggerClientEvent("hud:Hunger",source,Datatable["hunger"])
		TriggerClientEvent("hud:Thirst",source,Datatable["thirst"])
		TriggerClientEvent("hud:Oxigen",source,Datatable["oxigen"])

		local Identity = vRP.Identity(Passport)
		if Identity then
			TriggerClientEvent("vRP:Active",source,Passport,Identity["name"].." "..Identity["name2"])

			if NewBarberShop then
				if Identity["newbie"] == 1 then
					TriggerClientEvent("spawn:justSpawn",source,false,true)
				else
					TriggerClientEvent("spawn:justSpawn",source,{},true,false)
				end
			else
				TriggerClientEvent("spawn:justSpawn",source,{},true,false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEPEDADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryDeletePedAdmin")
AddEventHandler("tryDeletePedAdmin",function(entIndex)
	local idNetwork = NetworkGetEntityFromNetworkId(entIndex[1])
	if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 1 then
		DeleteEntity(idNetwork)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeleteObject")
AddEventHandler("DeleteObject",function(entIndex)
	local idNetwork = NetworkGetEntityFromNetworkId(entIndex)
	if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 3 then
		DeleteEntity(idNetwork)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeletePed")
AddEventHandler("DeletePed",function(entIndex)
	local idNetwork = NetworkGetEntityFromNetworkId(entIndex)
	if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 1 then
		DeleteEntity(idNetwork)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gg",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRPC.CheckDeath(source) then
		if vRP.UserPremium(Passport) then
			if ClearInventoryPremium then
				local Datatable = vRP.Datatable(Passport)
				if Datatable["inventory"] then
					Datatable["inventory"] = {}
				end

				TriggerEvent("inventory:CleanWeapons",Passport)
			else
				TriggerClientEvent("Notify",source,"Atenção","Você é <b>Premium</b> e não perdeu seus itens.","amarelo",5000)
			end
		else
			if CleanDeathInventory then
				local Datatable = vRP.Datatable(Passport)
				if Datatable["inventory"] then
					Datatable["inventory"] = {}
				end

				TriggerEvent("inventory:CleanWeapons",Passport)
			end
		end

		vRPC.Respawn(source)
		vRP.UpgradeThirst(Passport,100)
		vRP.UpgradeHunger(Passport,100)
		vRP.DowngradeStress(Passport,100)

		TriggerEvent("Discord","Airport","**Passaporte:** "..parseFormat(Passport).."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ClearInventory(Passport)
    if vRP.Source(Passport) then
        local Datatable = vRP.Datatable(Passport)
		if Datatable["inventory"] then
			Datatable["inventory"] = {}
		end

        TriggerEvent("inventory:CleanWeapons",Passport)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDAGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeThirst(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["thirst"] == nil then
			Datatable["thirst"] = 0
		end

		Datatable["thirst"] = Datatable["thirst"] + amount

		if Datatable["thirst"] > 100 then
			Datatable["thirst"] = 100
		end

		TriggerClientEvent("hud:Thirst",userSource,Datatable["thirst"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeHunger(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["hunger"] == nil then
			Datatable["hunger"] = 0
		end

		Datatable["hunger"] = Datatable["hunger"] + amount

		if Datatable["hunger"] > 100 then
			Datatable["hunger"] = 100
		end

		TriggerClientEvent("hud:Hunger",userSource,Datatable["hunger"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeStress(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["stress"] == nil then
			Datatable["stress"] = 0
		end

		Datatable["stress"] = Datatable["stress"] + amount

		if Datatable["stress"] > 100 then
			Datatable["stress"] = 100
		end

		TriggerClientEvent("hud:Stress",userSource,Datatable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeThirst(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["thirst"] == nil then
			Datatable["thirst"] = 100
		end

		Datatable["thirst"] = Datatable["thirst"] - amount

		if Datatable["thirst"] < 0 then
			Datatable["thirst"] = 0
		end

		TriggerClientEvent("hud:Thirst",userSource,Datatable["thirst"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeHunger(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["hunger"] == nil then
			Datatable["hunger"] = 100
		end

		Datatable["hunger"] = Datatable["hunger"] - amount

		if Datatable["hunger"] < 0 then
			Datatable["hunger"] = 0
		end

		TriggerClientEvent("hud:Hunger",userSource,Datatable["hunger"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeStress(Passport,amount)
	local userSource = vRP.Source(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable and userSource then
		if Datatable["stress"] == nil then
			Datatable["stress"] = 0
		end

		Datatable["stress"] = Datatable["stress"] - amount

		if Datatable["stress"] < 0 then
			Datatable["stress"] = 0
		end

		TriggerClientEvent("hud:Stress",userSource,Datatable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOODS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Foods()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			if Datatable["thirst"] == nil then
				Datatable["thirst"] = 100
			end

			if Datatable["hunger"] == nil then
				Datatable["hunger"] = 100
			end

			Datatable["hunger"] = Datatable["hunger"] - 1
			Datatable["thirst"] = Datatable["thirst"] - 1

			if Datatable["thirst"] < 0 then
				Datatable["thirst"] = 0
			end

			if Datatable["hunger"] < 0 then
				Datatable["hunger"] = 0
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Oxigen()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			if Datatable["oxigen"] == nil then
				Datatable["oxigen"] = 100
			end

			Datatable["oxigen"] = Datatable["oxigen"] - 1
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.rechargeOxigen()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			Datatable["oxigen"] = 100
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetHealth(source)
	local Ped = GetPlayerPed(source)
	return GetEntityHealth(Ped)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ModelPlayer(source)
	local Ped = GetPlayerPed(source)
	if GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01") then
		return "mp_m_freemode_01"
	elseif GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
		return "mp_f_freemode_01"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:Experience")
AddEventHandler("vRP:Experience",function(source,Passport,amount)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["experience"] ~= nil then
			Datatable["experience"] = Datatable["experience"] + parseInt(amount)
		else
			Datatable["experience"] = parseInt(amount)
		end

		TriggerClientEvent("hud:Exp",source,Datatable["experience"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetArmour(source,amount)
	local Ped = GetPlayerPed(source)
	local armour = GetPedArmour(Ped)

	SetPedArmour(Ped,parseInt(armour + amount))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Teleport(source,x,y,z)
	local Ped = GetPlayerPed(source)
	SetEntityCoords(Ped,x + 0.0001,y + 0.0001,z + 0.0001,false,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreateObject(model,x,y,z)
	local spawnObjects = 0
	local mHash = GetHashKey(model)
	local Object = CreateObject(mHash,x,y,z,true,true,false)

	while not DoesEntityExist(Object) and spawnObjects <= 1000 do
		spawnObjects = spawnObjects + 1
		Wait(1)
	end

	if DoesEntityExist(Object) then
		return true,NetworkGetNetworkIdFromEntity(Object)
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreatePed(model,x,y,z,heading,typ)
	local spawnPeds = 0
	local mHash = GetHashKey(model)
	local Ped = CreatePed(typ,mHash,x,y,z,heading,true,false)

	while not DoesEntityExist(Ped) and spawnPeds <= 1000 do
		spawnPeds = spawnPeds + 1
		Wait(1)
	end

	if DoesEntityExist(Ped) then
		return true,NetworkGetNetworkIdFromEntity(Ped)
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if AutoSave then
		while true do
			TriggerEvent("SaveServer",AutoSaveSilenced)

			Wait(AutoSaveTime)
		end
	end
end)