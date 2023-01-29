-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chests = {
	{ ["Name"] = "Policia", ["Coords"] = vec3(360.43,-1600.48,25.83), ["Mode"] = "1" },
	{ ["Name"] = "Policia", ["Coords"] = vec3(486.46,-994.94,31.07), ["Mode"] = "1" },
	{ ["Name"] = "Policia", ["Coords"] = vec3(1836.96,3685.16,34.80), ["Mode"] = "1" },
	{ ["Name"] = "Policia", ["Coords"] = vec3(-445.38,6019.65,37.38), ["Mode"] = "1" },
	{ ["Name"] = "Policia", ["Coords"] = vec3(386.72,800.09,187.47), ["Mode"] = "1" },
	{ ["Name"] = "Policia", ["Coords"] = vec3(1844.31,2573.84,46.26), ["Mode"] = "1" },
	{ ["Name"] = "Paramedico", ["Coords"] = vec3(306.17,-601.98,43.25), ["Mode"] = "2" },
	{ ["Name"] = "Paramedico", ["Coords"] = vec3(-258.00,6332.62,32.72), ["Mode"] = "2" },
	{ ["Name"] = "Mecanico", ["Coords"] = vec3(836.56,-813.67,26.35), ["Mode"] = "2" },
	{ ["Name"] = "PizzaThis", ["Coords"] = vec3(803.33,-756.87,26.93), ["Mode"] = "2" },
	{ ["Name"] = "UwuCoffee", ["Coords"] = vec3(-572.65,-1049.74,26.61), ["Mode"] = "2" },
	{ ["Name"] = "BeanMachine", ["Coords"] = vec3(123.57,-1038.68,29.0), ["Mode"] = "2" },
	{ ["Name"] = "Ballas", ["Coords"] = vec3(-1.92,-1811.96,29.32), ["Mode"] = "2" },
	{ ["Name"] = "Families", ["Coords"] = vec3(-163.85,-1619.42,33.81), ["Mode"] = "2" },
	{ ["Name"] = "Vagos", ["Coords"] = vec3(325.13,-1999.77,24.35), ["Mode"] = "2" },
	{ ["Name"] = "Aztecas", ["Coords"] = vec3(484.6,-1533.28,29.44), ["Mode"] = "2" },
	{ ["Name"] = "Altruists", ["Coords"] = vec3(-1103.8,4938.9,218.3), ["Mode"] = "2" },
	{ ["Name"] = "Triads", ["Coords"] = vec3(-644.33,-1244.56,11.82), ["Mode"] = "2" },
	{ ["Name"] = "Marabunta", ["Coords"] = vec3(1251.1,-1580.8,58.53), ["Mode"] = "2" },
	{ ["Name"] = "TheSouth", ["Coords"] = vec3(977.37,-104.37,74.8), ["Mode"] = "2" },
	{ ["Name"] = "TheNorth", ["Coords"] = vec3(101.38,3619.46,40.45), ["Mode"] = "2" },
	{ ["Name"] = "Records", ["Coords"] = vec3(-816.5,-695.9,31.94), ["Mode"] = "2" },
	{ ["Name"] = "Arcade", ["Coords"] = vec3(-1648.57,-1073.02,13.85), ["Mode"] = "2" },
	{ ["Name"] = "Bobcats", ["Coords"] = vec3(908.14,-2110.31,31.49), ["Mode"] = "2" },
	{ ["Name"] = "Highways", ["Coords"] = vec3(946.4,-1744.59,21.03), ["Mode"] = "2" },
	{ ["Name"] = "PizzaThisTray", ["Coords"] = vec3(810.85,-752.92,27.04), ["Mode"] = "3" },
	{ ["Name"] = "UwuCoffeeTray", ["Coords"] = vec3(-584.02,-1059.29,22.42), ["Mode"] = "3" },
	{ ["Name"] = "BeanMachineTray", ["Coords"] = vec3(121.87,-1037.08,29.25), ["Mode"] = "3" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "chest:Open",
			label = "Compartimento Geral",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Open",
			label = "Compartimento Pessoal",
			tunnel = "shop",
			service = "Personal"
		},{
			event = "chest:Open",
			label = "Compartimento Evidências",
			tunnel = "shop",
			service = "Evidences"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["3"] = {
		{
			event = "chest:Open",
			label = "Bandeja",
			tunnel = "shop",
			service = "Normal"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(Chests) do
		exports["target"]:AddCircleZone("Chest:"..Name,v["Coords"],0.1,{
			name = "Chest:"..Name,
			heading = 3374176
		},{
			Distance = 1.25,
			shop = v["Name"],
			options = Labels[v["Mode"]]
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Open",function(Name,Init)
	if LocalPlayer["state"]["Route"] < 900000 and MumbleIsConnected() then
		if vSERVER.Permissions(Name,Init) then
			SetNuiFocus(true,true)
			SendNUIMessage({ Action = "Open" })
			vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data["item"],Data["slot"],Data["amount"],Data["target"])
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
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Chest",function(Data,Callback)
	if MumbleIsConnected() then
		local Inventory,Chest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.Chest()
		if Inventory then
			Callback({ Inventory = Inventory, Chest = Chest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Update")
AddEventHandler("chest:Update",function(Action,invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ Action = Action, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Close")
AddEventHandler("chest:Close",function(Action)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
	vRP.Destroy()
end)