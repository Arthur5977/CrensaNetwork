-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Frequency = 0
local Timer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIONUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioNui")
AddEventHandler("radio:RadioNui",function()
	SetNuiFocus(true,true)
	SetCursorLocation(0.9,0.9)
	SendNUIMessage({ Action = "Radio", Show = true })

	if not IsPedInAnyVehicle(PlayerPedId()) then
		vRP.createObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioClose",function(Data,Callback)
	SetCursorLocation(0.5,0.5)
	SetNuiFocus(false,false)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioActive",function(Data,Callback)
	if Frequency ~= Data["Frequency"] then
		if vSERVER.Frequency(Data["Frequency"]) then
			if Frequency ~= 0 then
				exports["pma-voice"]:removePlayerFromRadio()
			end

			exports["pma-voice"]:setRadioChannel(Data["Frequency"])
			TriggerEvent("hud:Radio",Data["Frequency"])
			Frequency = Data["Frequency"]
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOINATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioInative",function(Data,Callback)
	TriggerEvent("radio:RadioClean")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIOCLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioClean")
AddEventHandler("radio:RadioClean",function()
	if Frequency ~= 0 then
		exports["pma-voice"]:removePlayerFromRadio()
		TriggerEvent("hud:Radio","Offline")
		Frequency = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADIOEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if GetGameTimer() >= Timer and Frequency ~= 0 and LocalPlayer["state"]["Route"] < 900000 then
			Timer = GetGameTimer() + 60000

			local Ped = PlayerPedId()
			if vSERVER.CheckRadio() or IsPedSwimming(Ped) then
				TriggerEvent("radio:RadioClean")
			end
		end

		Wait(10000)
	end
end)