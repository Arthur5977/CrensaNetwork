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
Tunnel.bindInterface("dynamic",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Experience()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Experiences = {
			["Caçador"] = vRP.GetExperience(Passport,"Hunter"),
			["Lenhador"] = vRP.GetExperience(Passport,"Lumberman"),
			["Transportador"] = vRP.GetExperience(Passport,"Transporter"),
			["Caminhoneiro"] = vRP.GetExperience(Passport,"Trucker"),
			["Pescador"] = vRP.GetExperience(Passport,"Fishing"),
			["Motorista"] = vRP.GetExperience(Passport,"Driver"),
			["Reboque"] = vRP.GetExperience(Passport,"Tows"),
			["Desmanche"] = vRP.GetExperience(Passport,"Dismantle"),
			["Entregador"] = vRP.GetExperience(Passport,"Delivery"),
			["Corredor"] = vRP.GetExperience(Passport,"Runner")
		}

		return Experiences
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUSIVAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Exclusivas()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Clothes = {}
		local Consult = vRP.GetSrvData("Exclusivas:"..Passport)

		for Index,v in pairs(Consult) do
			Clothes[#Clothes + 1] = { ["name"] = Index, ["id"] = v["id"], ["texture"] = v["texture"] or 0, ["type"] = v["type"] }
		end

		return Clothes
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Animal = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALREGISTER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AnimalRegister(netId)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Animal[Passport] = netId
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALCLEANER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AnimalCleaner()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("DeletePed",Animal[Passport])
		Animal[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Animal[Passport] then
		TriggerEvent("DeletePed",Animal[Passport])
		Animal[Passport] = nil
	end
end)