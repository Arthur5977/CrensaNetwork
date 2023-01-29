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
Tunnel.bindInterface("target",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Price = 750
local Announces = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetHealth(source) <= 100 then
			if vRP.PaymentFull(Passport,Price * 2) then
				vRP.UpgradeHunger(Passport,30)
				vRP.UpgradeThirst(Passport,30)
				TriggerEvent("Reposed",source,Passport,900)

				return true
			end
		else
			if vRP.UserMedicPlan(Passport) then
				if vRP.Request(source,"Prosseguir o tratamento por <b>$"..parseFormat(Price * 0.50).."</b> dólares?","Sim, iniciar tratamento","Não, volto mais tarde") then
					if vRP.PaymentFull(Passport,Price * 0.50) then
						vRP.UpgradeHunger(Passport,30)
						vRP.UpgradeThirst(Passport,30)
						TriggerEvent("Reposed",source,Passport,900)

						return true
					end
				end
			else
				if vRP.Request(source,"Prosseguir o tratamento por <b>$"..parseFormat(Price).."</b> dólares?","Sim, iniciar tratamento","Não, volto mais tarde") then
					if vRP.PaymentFull(Passport,Price) then
						vRP.UpgradeHunger(Passport,30)
						vRP.UpgradeThirst(Passport,30)
						TriggerEvent("Reposed",source,Passport,900)

						return true
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ANNOUNCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Announces")
AddEventHandler("target:Announces",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Announces[Service] then
			Announces[Service] = os.time()
		end

		if os.time() >= Announces[Service] then
			if Service == "Paramedico" then
				if vRP.HasGroup(Passport,"Paramedico") then
					TriggerClientEvent("Notify",-1,"Atenção","<b>Pillbox Medical:</b> Estamos em busca de doadores de sangue, seja solidário e ajude o próximo, procure um de nossos profissionais.","amarelo",15000)
				else
					TriggerClientEvent("Notify",source,"Aviso","Você não tem permissão para enviar um anúncio.","vermelho",5000)
				end
			else
				if vRP.HasGroup(Passport,Service) then
					TriggerClientEvent("Notify",-1,"Atenção","<b>"..Service..":</b> Estamos em busca de trabalhadores, compareça ao estabelecimento, procure um de nossos funcionários e consulte nosso serviço de entregas.","amarelo",15000)
				else
					TriggerClientEvent("Notify",source,"Aviso","Você não tem permissão para enviar um anúncio.","vermelho",5000)
				end
			end

			Announces[Service] = os.time() + 600
		else
			local Cooldown = parseInt(Announces[Service] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Cooldown.."</b> segundos.","azul",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:MEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Medicplan")
AddEventHandler("target:Medicplan",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.Request(source,"Assinar o plano de saúde por <b>$"..parseFormat(10000).."</b>? Lembrando que a duração do mesmo é de 7 dias.","Sim, efetuar o pagamento","Não, decido depois") then
			if vRP.PaymentFull(Passport,10000) then
				vRP.SetMedicPlan(Passport)
				TriggerClientEvent("Notify",source,false,"Você assinou o plano de saúde por <b>7 dias</b>.","azul",5000)
			end
		end
	end
end)