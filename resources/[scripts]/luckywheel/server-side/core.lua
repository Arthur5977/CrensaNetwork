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
vCLIENT = Tunnel.getInterface("luckywheel")
Tunnel.bindInterface("luckywheel",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Bonus = {}
local Actived = {}
local Payments = {}
local Active = os.time()
local ItemQuantity = 2500
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if os.time() > Active then
			if Bonus[tostring(Passport)] then
				Active = os.time() + 20
				Bonus[tostring(Passport)] = nil
				return true
			end

			if vRP.TakeItem(Passport,"luckywheelpass",1,true) then
				Active = os.time() + 20
				return true
			end

			if vRP.TakeItem(Passport,"cassino",ItemQuantity,true) then
				Active = os.time() + 20
				return true
			else
				TriggerClientEvent("Notify",source,"Aviso","Você não tem <b>"..parseFormat(ItemQuantity).."x "..itemName("cassino").."</b>.","vermelho",5000)
			end
		else
			local Cooldown = Active - os.time()
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Cooldown.."</b> segundos.","azul",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLLING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Rolling()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Payments[Passport] and os.time() < Active then
		local Result = math.random(325)

		if Result <= 10 or Result >= 218 then
			Payments[Passport] = 1
		elseif Result >= 11 and Result <= 50 then
			Payments[Passport] = 2
		elseif Result >= 51 and Result <= 55 then
			Payments[Passport] = 3
		elseif Result >= 56 and Result <= 62 then
			Payments[Passport] = 4
		elseif Result >= 63 and Result <= 75 then
			Payments[Passport] = 5
		elseif Result >= 76 and Result <= 120 then
			Payments[Passport] = 6
		elseif Result >= 121 and Result <= 125 then
			Payments[Passport] = 7
		elseif Result >= 126 and Result <= 130 then
			Payments[Passport] = 8
		elseif Result >= 131 and Result <= 150 then
			Payments[Passport] = 9
		elseif Result >= 151 and Result <= 160 then
			Payments[Passport] = 10
		elseif Result >= 161 and Result <= 165 then
			Payments[Passport] = 11
		elseif Result >= 166 and Result <= 167 then
			Payments[Passport] = 12
		elseif Result >= 167 and Result <= 180 then
			Payments[Passport] = 13
		elseif Result >= 181 and Result <= 186 then
			Payments[Passport] = 14
		elseif Result >= 187 and Result <= 189 then
			Payments[Passport] = 15
		elseif Result >= 190 and Result <= 192 then
			Payments[Passport] = 16
		elseif Result >= 193 and Result <= 210 then
			Payments[Passport] = 17
		elseif Result >= 211 and Result <= 215 then
			Payments[Passport] = 18
		elseif Result == 216 then
			Payments[Passport] = 19
		elseif Result == 217 then
			Payments[Passport] = 20
		end

		vCLIENT.Active(source)

		local Players = vRPC.Players(source)
		for _,v in pairs(Players) do
			async(function()
				vCLIENT.Start(v,Payments[Passport])
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Actived[Passport] and Payments[Passport] then
		Actived[Passport] = true

		if Payments[Passport] == 2 then
			vRP.GiveBank(Passport,2500)
		elseif Payments[Passport] == 3 or Payments[Passport] == 11 then
			vRP.GiveBank(Passport,15000)
		elseif Payments[Passport] == 4 or Payments[Passport] == 14 then
			vRP.GiveBank(Passport,10000)
		elseif Payments[Passport] == 5 then
			Bonus[tostring(Passport)] = true
		elseif Payments[Passport] == 6 then
			vRP.GiveBank(Passport,5000)
		elseif Payments[Passport] == 7 then
			vRP.GiveBank(Passport,20000)
		elseif Payments[Passport] == 8 or Payments[Passport] == 18 then
			vRP.GiveBank(Passport,12500)
		elseif Payments[Passport] == 10 then
			vRP.GiveBank(Passport,7500)
		elseif Payments[Passport] == 12 then
			vRP.UpgradeGemstone(Passport,10)
		elseif Payments[Passport] == 15 then
			vRP.GiveBank(Passport,22500)
		elseif Payments[Passport] == 16 then
			vRP.GiveBank(Passport,17500)
		elseif Payments[Passport] == 19 then
			local vehName = "silvias15"
			local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
			if Vehicle[1] then
				if Vehicle[1]["rental"] <= os.time() then
					vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = vehName })
				else
					vRP.Query("vehicles/rentalVehiclesDays",{ Passport = Passport, vehicle = vehName })
				end
			else
				vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			end
		elseif Payments[Passport] == 20 then
			vRP.GiveBank(Passport,25000)
		end

		Payments[Passport] = nil
		Actived[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Payments[Passport] then
		Payments[Passport] = nil
	end

	if Actived[Passport] then
		Actived[Passport] = nil
	end
end)