-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("shops",Creative)
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	if MumbleIsConnected() then
		local inventoryShop,inventoryUser,invPeso,invMaxpeso,shopSlots = vSERVER.Request(Data["shop"])
		if inventoryShop then
			Callback({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso, shopSlots = shopSlots })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.functionShops(Data["shop"],Data["item"],Data["amount"],Data["slot"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(Data,Callback)
	TriggerServerEvent("shops:populateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(Data,Callback)
	TriggerServerEvent("shops:updateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Action)
	SendNUIMessage({ Action = Action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ -542.87,-198.35,38.23,"Identity",false,2.75,true },
	{ -551.27,-203.09,38.23,"Identity",false,2.75,true },
	{ -544.76,-185.81,52.2,"Identity2",false,2.0,false },
	{ 24.9,-1346.8,29.49,"Departament",true,2.0,false },
	{ 2556.74,381.24,108.61,"Departament",true,2.0,false },
	{ 1164.82,-323.65,69.2,"Departament",true,2.0,false },
	{ -706.15,-914.53,19.21,"Departament",true,2.0,false },
	{ -47.38,-1758.68,29.42,"Departament",true,2.0,false },
	{ 373.1,326.81,103.56,"Departament",true,2.0,false },
	{ -3242.75,1000.46,12.82,"Departament",true,2.0,false },
	{ 1728.47,6415.46,35.03,"Departament",true,2.0,false },
	{ 1960.2,3740.68,32.33,"Departament",true,2.0,false },
	{ 2677.8,3280.04,55.23,"Departament",true,2.0,false },
	{ 1697.31,4923.49,42.06,"Departament",true,2.0,false },
	{ -1819.52,793.48,138.08,"Departament",true,2.0,false },
	{ 1391.69,3605.97,34.98,"Departament",true,2.0,false },
	{ -2966.41,391.55,15.05,"Departament",true,2.0,false },
	{ -3039.54,584.79,7.9,"Departament",true,2.0,false },
	{ 1134.33,-983.11,46.4,"Departament",true,2.0,false },
	{ 1165.28,2710.77,38.15,"Departament",true,2.0,false },
	{ -1486.72,-377.55,40.15,"Departament",true,2.0,false },
	{ -1221.45,-907.92,12.32,"Departament",true,2.0,false },
	{ 161.2,6641.66,31.69,"Departament",true,2.0,false },
	{ -160.62,6320.93,31.58,"Departament",true,2.0,false },
	{ 548.7,2670.73,42.16,"Departament",true,2.0,false },
	{ 812.88,-782.08,26.17,"DepartamentMechanic",true,2.0,false },
	{ 1696.88,3758.39,34.69,"Ammunation",false,2.0,true },
	{ 248.17,-51.78,69.94,"Ammunation",false,2.0,true },
	{ 841.18,-1030.12,28.19,"Ammunation",false,2.0,true },
	{ -327.07,6082.22,31.46,"Ammunation",false,2.0,true },
	{ -659.18,-938.47,21.82,"Ammunation",false,2.0,true },
	{ -1309.43,-394.56,36.7,"Ammunation",false,2.0,true },
	{ -1113.41,2698.19,18.55,"Ammunation",false,2.0,true },
	{ 2564.83,297.46,108.73,"Ammunation",false,2.0,true },
	{ -3168.32,1087.46,20.84,"Ammunation",false,2.0,true },
	{ 16.91,-1107.56,29.79,"Ammunation",false,2.0,true },
	{ 814.84,-2155.14,29.62,"Ammunation",false,2.0,true },
	{ -695.56,5802.12,17.32,"Hunting",false,2.0,true },
	{ -679.13,5839.52,17.32,"Hunting2",false,2.0,true },
	{ -172.89,6381.32,31.48,"Pharmacy",false,2.0,true },
	{ 1690.07,3581.68,35.62,"Pharmacy",false,2.0,true },
	{ 326.5,-1074.43,29.47,"Pharmacy",false,2.0,true },
	{ 114.39,-4.85,67.82,"Pharmacy",false,2.0,false },
	{ 311.97,-597.66,43.29,"Paramedico",false,2.0,false },
	{ -254.64,6326.95,32.82,"Paramedico",false,2.0,false },
	{ -428.54,-1728.29,19.78,"Recycle",false,2.0,true },
	{ 180.07,2793.29,45.65,"Recycle",false,2.0,true },
	{ -195.42,6264.62,31.49,"Recycle",false,2.0,true },
	{ 488.01,-996.95,30.5,"Policia",false,2.0,false },
	{ 1839.01,3686.68,33.98,"Policia",false,2.0,false },
	{ -447.67,6016.95,36.8,"Policia",false,2.0,false },
	{ 385.48,800.36,190.14,"Policia",false,2.0,false },
	{ 361.94,-1603.71,25.26,"Policia",false,2.0,false },
	{ -628.79,-238.7,38.05,"Miners",false,2.0,true },
	{ 475.1,3555.28,33.23,"Criminal",false,2.0,false },
	{ 112.41,3373.68,35.25,"Criminal2",false,2.0,false },
	{ 2013.95,4990.88,41.21,"Criminal3",false,2.0,false },
	{ 186.9,6374.75,32.33,"Criminal4",false,2.0,false },
	{ -653.12,-1502.67,5.22,"Criminal",false,2.0,false },
	{ 389.71,-942.61,29.42,"Criminal2",false,2.0,false },
	{ 154.98,-1472.47,29.35,"Criminal3",false,2.0,false },
	{ 488.1,-1456.11,29.28,"Criminal4",false,2.0,false },
	{ 169.76,-1535.88,29.25,"Weapons",false,2.0,false },
	{ 301.14,-195.75,61.57,"Weapons",false,2.0,false },
	{ 836.58,-808.25,26.35,"Mecanico",false,2.0,false },
	{ -1636.74,-1092.17,13.08,"Oxy",false,2.0,true },
	{ 806.22,-761.68,26.77,"PizzaThis",false,2.0,false },
	{ -588.5,-1066.23,22.34,"UwuCoffee",false,2.0,false },
	{ 124.01,-1036.72,29.27,"BeanMachine",false,2.0,false },
	{ -1127.26,-1439.35,5.22,"Clothes",false,2.0,true },
	{ 78.26,-1388.91,29.37,"Clothes",false,2.0,true },
	{ -706.73,-151.38,37.41,"Clothes",false,2.0,true },
	{ -166.69,-301.55,39.73,"Clothes",false,2.0,true },
	{ -817.5,-1074.03,11.32,"Clothes",false,2.0,true },
	{ -1197.33,-778.98,17.32,"Clothes",false,2.0,true },
	{ -1447.84,-240.03,49.81,"Clothes",false,2.0,true },
	{ -0.07,6511.8,31.88,"Clothes",false,2.0,true },
	{ 1691.6,4818.47,42.06,"Clothes",false,2.0,true },
	{ 123.21,-212.34,54.56,"Clothes",false,2.0,true },
	{ 621.24,2753.37,42.09,"Clothes",false,2.0,true },
	{ 1200.68,2707.35,38.22,"Clothes",false,2.0,true },
	{ -3172.39,1055.31,20.86,"Clothes",false,2.0,true },
	{ -1096.53,2711.1,19.11,"Clothes",false,2.0,true },
	{ 422.7,-810.25,29.49,"Clothes",false,2.0,true },
	{ 989.98,32.58,71.46,"Cassino",false,2.0,true },
	{ 988.95,30.88,71.46,"Cassino",false,2.0,true },
	{ 562.3,2741.61,42.87,"Animals",false,2.0,true },
	{ -1174.54,-1571.4,4.35,"Weeds",false,2.0,true }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Open",function(Number)
	if MumbleIsConnected() and LocalPlayer["state"]["Route"] < 900000 then
		if vSERVER.requestPerm(List[Number][4]) then
			if List[Number][7] then
				if GetClockHours() >= 08 and GetClockHours() <= 23 then
					SetNuiFocus(true,true)
					SendNUIMessage({ Action = "Open", name = List[Number][4], type = vSERVER.getShopType(List[Number][4]) })

					if List[Number][5] then
						TriggerEvent("sounds:Private","shop",0.5)
					end
				else
					TriggerEvent("Notify","Inoperável","Horário de funcionamento é das <b>08</b> ás <b>23</b> Horas.","azul",5000)
				end
			else
				SetNuiFocus(true,true)
				SendNUIMessage({ Action = "Open", name = List[Number][4], type = vSERVER.getShopType(List[Number][4]) })

				if List[Number][5] then
					TriggerEvent("sounds:Private","shop",0.5)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COFFEE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Coffee",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Coffee", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:SODA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Soda",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Soda", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DONUT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Donut",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Donut", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HAMBURGER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Hamburger",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Hamburger", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HOTDOG
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Hotdog",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Hotdog", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CHIHUAHUA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Chihuahua",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Chihuahua", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:WATER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Water",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Water", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CIGARETTE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Cigarette",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ Action = "Open", name = "Cigarette", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:MEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Medic",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		if vSERVER.Permission("Paramedico") then
			SetNuiFocus(true,true)
			SendNUIMessage({ Action = "Open", name = "Paramedico", type = "Buy" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Fuel",function()
	SendNUIMessage({ Action = "Open", name = "Fuel", type = "Buy" })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Premium",function()
	SendNUIMessage({ Action = "Open", name = "Premium", type = "Buy" })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(List) do
		exports["target"]:AddCircleZone("Shops:"..Number,vec3(v[1],v[2],v[3]),0.50,{
			name = "Shops:"..Number,
			heading = 3374176
		},{
			shop = Number,
			Distance = v[6],
			options = {
				{
					event = "shops:Open",
					label = "Abrir",
					tunnel = "shop"
				}
			}
		})
	end
end)