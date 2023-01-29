-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("bank",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Timer = {}
local Actived = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetCriminal(Passport) > 0 then
			TriggerClientEvent("Notify",source,"Aviso","Você foi denunciado, parece que suas digitais estão no banco de dados do governo como procurado.","amarelo",10000)

			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Service = vRP.NumPermission("Policia")
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Digitais Encontrada", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alerta de procurado", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end
		end

		if exports["hud"]:Wanted(Passport,source) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Deposit
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deposit(amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Actived[Passport] == nil then
		Actived[Passport] = true

		if Timer[Passport] then
			if GetGameTimer() < Timer[Passport] then
				local Timers = parseInt((Timer[Passport] - GetGameTimer()) / 1000)
				TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timers.." segundos</b>.","azul",5000)
				Actived[Passport] = nil

				return false
			end
		end

		if parseInt(amount) > 0 then
			if vRP.TakeItem(Passport,"dollars",amount,true) then
				Timer[Passport] = GetGameTimer() + 60000
				vRP.GiveBank(Passport,amount)
			else
				TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
			end
		end

		Actived[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Withdraw(amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Actived[Passport] == nil then
		Actived[Passport] = true

		if Timer[Passport] then
			if GetGameTimer() < Timer[Passport] then
				local Timers = parseInt((Timer[Passport] - GetGameTimer()) / 1000)
				TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timers.." segundos</b>.","azul",5000)
				Actived[Passport] = nil

				return false
			end
		end

		local value = parseInt(amount)
		if (vRP.InventoryWeight(Passport) + itemWeight("dollars") * value) <= vRP.GetWeight(Passport) then
			Timer[Passport] = GetGameTimer() + 60000

			if not vRP.WithdrawCash(Passport,value) then
				TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end

		Actived[Passport] = nil
	end
end