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
Tunnel.bindInterface("barbershop",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport,source) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Barbers)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Tables = json.encode(Barbers)
		if Tables ~= "[]" then
			vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Barbershop", dvalue = Tables })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOMORENEWBIE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.NoMoreNewbie(Status)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Status then
			vRP.Query("characters/updateNewbie",{ newbie = 0, id = Passport })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ChangeSkin(Skin)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Skin == "mp_m_freemode_01" then
			vRP.Query("characters/updateSex",{ sex = "M", id = Passport })
			vRP.SkinCharacter(Passport,"mp_m_freemode_01")
			vRPC.Skin(Passport,"mp_m_freemode_01")
		elseif Skin == "mp_f_freemode_01" then
			vRP.Query("characters/updateSex",{ sex = "F", id = Passport })
			vRP.SkinCharacter(Passport,"mp_f_freemode_01")
			vRPC.Skin(Passport,"mp_f_freemode_01")
		end
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
-- PRIVATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Private(Value,Permission)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.Request(source,"Usar barbearia por <b>$"..parseFormat(Value).."</b> Dólares, deseja prosseguir?","Sim, efetuar o pagamento","Não, decido depois") then
			if Permission then
				if vRP.PaymentFull(Passport,Value) then
					vRP.GiveBank(0,parseInt(Value),Permission)
					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
					return false
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("barbershop:Debug")
AddEventHandler("barbershop:Debug",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("barbershop:Apply",source,vRP.UserData(Passport,"Barbershop"))
		TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))
		TriggerClientEvent("tattoos:Apply",source,vRP.UserData(Passport,"Tatuagens"))
		TriggerClientEvent("target:Debug",source)

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		TriggerClientEvent("syncarea",source,Coords["x"],Coords["y"],Coords["z"],1)
	end
end)