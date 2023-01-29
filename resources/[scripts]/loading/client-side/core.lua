-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("onClientResourceStart")
AddEventHandler("onClientResourceStart",function(Resource)
	if (GetCurrentResourceName() ~= Resource) then
		return
	end

	DisplayRadar(false)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	TriggerEvent("spawn:Opened")
end)