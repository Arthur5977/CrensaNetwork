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
Tunnel.bindInterface("trunkchest",Creative)
vSERVER = Tunnel.getInterface("trunkchest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
	vSERVER.chestClose()
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:Open")
AddEventHandler("trunkchest:Open",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showMenu" })
	vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data["slot"],Data["amount"],Data["target"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Update(Data["slot"],Data["target"],Data["amount"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	if MumbleIsConnected() then
		local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest()
		if myInventory then
			Callback({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:Update")
AddEventHandler("trunkchest:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:UpdateWeight")
AddEventHandler("trunkchest:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)