-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("service")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ vec3(441.81,-982.05,30.83),"Policia-1",1.0 },
	{ vec3(1833.75,3678.34,34.27),"Policia-2",1.0 },
	{ vec3(-447.28,6013.01,32.41),"Policia-3",1.0 },
	{ vec3(1840.20,2578.48,46.07),"Policia-4",1.0 },
	{ vec3(385.43,794.42,187.48),"Policia-5",1.0 },
	{ vec3(382.01,-1596.39,29.91),"Policia-6",1.0 },
	{ vec3(310.23,-597.54,43.29),"Paramedico-1",1.0 },
	{ vec3(-254.77,6331.03,32.79),"Paramedico-2",1.5 },
	{ vec3(1188.05,-1468.31,34.66),"Paramedico-3",1.5 },
	{ vec3(835.39,-829.68,26.16),"Mecanico-1",1.0 },
	{ vec3(835.13,-827.38,26.16),"Mecanico-2",1.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number = 1,#List do
		exports["target"]:AddCircleZone("Service:"..List[Number][2],List[Number][1],0.10,{
			name = "Service:"..List[Number][2],
			heading = 3374176
		},{
			shop = Number,
			Distance = List[Number][3],
			options = {
				{
					label = "Entrar em Serviço",
					event = "service:Toggle",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	if LocalPlayer["state"]["Route"] < 900000 then
		TriggerServerEvent("service:Toggle",List[Service][2])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:LABEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Label")
AddEventHandler("service:Label",function(Service,Text)
	if Service == "Policia" then
		exports["target"]:LabelText("Service:Policia-1",Text)
		exports["target"]:LabelText("Service:Policia-2",Text)
		exports["target"]:LabelText("Service:Policia-3",Text)
		exports["target"]:LabelText("Service:Policia-4",Text)
		exports["target"]:LabelText("Service:Policia-5",Text)
		exports["target"]:LabelText("Service:Policia-6",Text)
	elseif Service == "Paramedico" then
		exports["target"]:LabelText("Service:Paramedico-1",Text)
		exports["target"]:LabelText("Service:Paramedico-2",Text)
		exports["target"]:LabelText("Service:Paramedico-3",Text)
	elseif Service == "Mecanico" then
		exports["target"]:LabelText("Service:Mecanico-1",Text)
		exports["target"]:LabelText("Service:Mecanico-2",Text)
	else
		exports["target"]:LabelText("Service:"..Service,Text)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Open")
AddEventHandler("service:Open",function(Title)
	SetNuiFocus(true,true)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "openSystem", title = Title })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(Data,Callback)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	Callback({ Result = vSERVER.Request() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Remove",function(Data,Callback)
	TriggerServerEvent("service:Remove",Data["passport"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Add",function(Data,Callback)
	TriggerServerEvent("service:Add",Data["passport"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Update")
AddEventHandler("service:Update",function()
	SendNUIMessage({ action = "Update" })
end)