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
Tunnel.bindInterface("damage",Creative)
vSERVER = Tunnel.getInterface("damage")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDAMAGEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsEntityInWater(Ped) then
			if IsPedSwimming(Ped) and not IsPedSwimmingUnderWater(Ped) then
				vSERVER.damageItem()
			elseif IsPedSwimming(Ped) and IsPedSwimmingUnderWater(Ped) then
				vSERVER.damageItem()
			end
		end

		Wait(1000)
	end
end)