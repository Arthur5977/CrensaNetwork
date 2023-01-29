-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Pause = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Pause",function()
	if not Pause and not IsPauseMenuActive() then
		Pause = true
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		TriggerScreenblurFadeIn(1)
		SendNUIMessage({ Action = "Open" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Map",function()
	ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"),0,-1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Pause","Abrir as configurações","keyboard","Escape")
RegisterKeyMapping("Map","Abrir o mapa","keyboard","P")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Action",function(Data,Callback)
	if Data["action"] == "Map" then
		SetNuiFocus(false,false)
		ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"),0,-1)
	elseif Data["action"] == "Settings" then
		SetNuiFocus(false,false)
		ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_LANDING_MENU"),0,-1)
	elseif Data["action"] == "Shop" then
		TriggerEvent("shops:Premium")
		
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Pause = false
	SetNuiFocus(false,false)
	TriggerScreenblurFadeOut(1)
end)