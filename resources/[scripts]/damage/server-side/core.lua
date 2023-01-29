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
Tunnel.bindInterface("damage",Creative)
vCLIENT = Tunnel.getInterface("damage")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.damageItem()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		for k,v in pairs(Damageable) do
			local consultItem = vRP.InventoryItemAmount(Passport,v["Item"])
			if consultItem[1] > 0 then
				vRP.RemoveItem(Passport,v["Item"],parseInt(consultItem[1]),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		end
	end
end