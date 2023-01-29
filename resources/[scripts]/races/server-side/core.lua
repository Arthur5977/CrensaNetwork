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
Tunnel.bindInterface("races",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Payments = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Finish(Number,Points)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local vehName = vRPC.VehicleName(source)
		local Consult = vRP.Query("races/Result",{ Race = Number, Passport = Passport })
		if Consult[1] then
			if parseInt(Points) < parseInt(Consult[1]["Points"]) then
				vRP.Query("races/Records",{ Race = Number, Passport = Passport, Vehicle = VehicleName(vehName), Points = parseInt(Points) })
			end
		else
			local Identity = vRP.Identity(Passport)
			vRP.Query("races/Insert",{ Race = Number, Passport = Passport, Name = Identity["name"].." "..Identity["name2"], Vehicle = VehicleName(vehName), Points = parseInt(Points) })
		end

		if Payments[Passport] then
			local Rand = math.random(Races[Number]["Payment"][1],Races[Number]["Payment"][1])
			vRP.GenerateItem(Passport,"dollars",Rand,true)

			local Ranking = vRP.Query("races/TopFive",{ Race = Number })
			if Ranking[1] then
				if parseInt(Ranking[1]["Points"]) > parseInt(Points) then
					vRP.GenerateItem(Passport,"racetrophy",1,true)
				end
			end
			
			local Experience = vRP.GetExperience(Passport,"Runner")
			local Category = ClassCategory(Experience)
			local Valuation = 100

			if Category == "B+" then
				Valuation = Valuation + 20
			elseif Category == "A" then
				Valuation = Valuation + 40
			elseif Category == "A+" then
				Valuation = Valuation + 60
			elseif Category == "S" then
				Valuation = Valuation + 80
			elseif Category == "S+" then
				Valuation = Valuation + 100
			end

			if Buffs["Dexterity"][Passport] then
				if Buffs["Dexterity"][Passport] > os.time() then
					Valuation = Valuation + (Valuation * 0.1)
				end
			end

			vRP.PutExperience(Passport,"Runner",1)

			TriggerEvent("blipsystem:Exit",source)
			Payments[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Start(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Races[Number] then
		if not Races[Number]["Cooldown"][Passport] then
			Races[Number]["Cooldown"][Passport] = os.time()
		end

		if os.time() >= Races[Number]["Cooldown"][Passport] then
			Payments[Passport] = false

			if vRP.TakeItem(Passport,"credential",1) then
				TriggerEvent("blipsystem:Enter",source,"Corredor")
				Races[Number]["Cooldown"][Passport] = os.time() + 3600
				Payments[Passport] = true

				local Service = vRP.NumPermission("Policia")
				for Passports,Sources in pairs(Service) do
					async(function()
						TriggerClientEvent("Notify",Sources,"Aviso","Detectamos um corredor clandestino nas ruas.","amarelo",5000)
						vRPC.PlaySound(Sources,"Beep_Red","DLC_HEIST_HACKING_SNAKE_SOUNDS")
					end)
				end
			end

			return true
		else
			local Cooldown = Races[Number]["Cooldown"][Passport] - os.time()
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Cooldown.."</b> segundos.","azul",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Ranking(Number)
	local Consult = vRP.Query("races/Ranking",{ Race = Number })
	return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Cancel()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Payments[Passport] then
			Payments[Passport] = nil
			TriggerEvent("blipsystem:Exit",source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Payments[Passport] then
		Payments[Passport] = nil
		TriggerEvent("blipsystem:Exit",source)
	end
end)