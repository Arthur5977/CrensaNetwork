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
Tunnel.bindInterface("trucker",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Trucker = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Exist()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Trucker[Passport] == nil then
			Trucker[Passport] = os.time()
		end

		if os.time() >= Trucker[Passport] then
			return true
		else
			local TruckerTimer = parseInt(Trucker[Passport] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..MinimalTimers(TruckerTimer).."</b> para trabalhar novamente.","azul",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Trucker[Passport] = os.time() + 21600

		local Experience = vRP.GetExperience(Passport,"Trucker")
		local Category = ClassCategory(Experience)
		local Valuation = 3500

		if Category == "B+" then
			Valuation = Valuation + 100
		elseif Category == "A" then
			Valuation = Valuation + 200
		elseif Category == "A+" then
			Valuation = Valuation + 300
		elseif Category == "S" then
			Valuation = Valuation + 400
		elseif Category == "S+" then
			Valuation = Valuation + 500
		end

		if Buffs["Dexterity"][Passport] then
			if Buffs["Dexterity"][Passport] > os.time() then
				Valuation = Valuation + (Valuation * 0.1)
			end
		end

		vRP.PutExperience(Passport,"Trucker",1)
		vRP.GenerateItem(Passport,"dollars",Valuation,true)
		TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",Valuation)
	end
end