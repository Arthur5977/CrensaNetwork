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
Tunnel.bindInterface("bus",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Experience = vRP.GetExperience(Passport,"Driver")
		local Category = ClassCategory(Experience)
		local Valuation = 100

		if Category == "B+" then
			Valuation = Valuation + 40
		elseif Category == "A" then
			Valuation = Valuation + 60
		elseif Category == "A+" then
			Valuation = Valuation + 80
		elseif Category == "S" then
			Valuation = Valuation + 100
		elseif Category == "S+" then
			Valuation = Valuation + 120
		end

		if Buffs["Dexterity"][Passport] then
			if Buffs["Dexterity"][Passport] > os.time() then
				Valuation = Valuation + (Valuation * 0.1)
			end
		end

		vRP.PutExperience(Passport,"Driver",1)
		vRP.GenerateItem(Passport,"dollars",Valuation,true)
		TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",Valuation)
	end
end