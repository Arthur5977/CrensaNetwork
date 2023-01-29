-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("skinshop",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Reposed(Passport) and not exports["hud"]:Wanted(Passport,source) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Clothes)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Clothings", dvalue = json.encode(Clothes) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKET
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bucket(Status)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Status then
			Player(source)["state"]["Route"] = Passport
			SetPlayerRoutingBucket(source,Passport)
		else
			Player(source)["state"]["Route"] = 0
			SetPlayerRoutingBucket(source,0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		if vRP.HasGroup(Passport,"Admin") then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				vRPC.Skin(ClosestPed,Message[2])
				vRP.SkinCharacter(parseInt(Message[1]),Message[2])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source,3)
		if ClosestPed then
			if vRP.HasGroup(Passport,"Police") then
				TriggerClientEvent("skinshop:set"..Mode,ClosestPed)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:BACKPACKWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:BackpackWeight")
AddEventHandler("vRP:BackpackWeight",function(Status)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Status then
			vRP.SetWeight(Passport,50)
		else
			vRP.RemWeight(Passport,50)
		end
	end
end)