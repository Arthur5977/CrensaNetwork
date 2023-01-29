-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDDEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedDeitar")
AddEventHandler("target:BedDeitar",function()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Object = GetClosestObjectOfType(Coords,1.0,-935625561,0,0,0)
	if DoesEntityExist(Object) then
		Coords = GetEntityCoords(Object)
		SetEntityCoords(Ped,Coords,false,false,false,false)
		SetEntityHeading(Ped,GetEntityHeading(Object) - 180.0)
		vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
		AttachEntityToEntity(Ped,Object,11816,0.0,0.0,1.0,0.0,0.0,0.0,false,false,false,false,2,true)
		LocalPlayer["state"]:set("Bed",Object,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedPickup")
AddEventHandler("target:BedPickup",function(Selected)
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] then
		local Ped = PlayerPedId()
		if GetEntityHealth(Ped) > 100 then
			local spawnObjects = 0
			local uObject = NetworkGetEntityFromNetworkId(Selected[3])
			local objectControl = NetworkRequestControlOfEntity(uObject)
			while not objectControl and spawnObjects <= 1000 do
				objectControl = NetworkRequestControlOfEntity(uObject)
				spawnObjects = spawnObjects + 1
				Wait(1)
			end

			AttachEntityToEntity(uObject,Ped,11816,0.0,1.25,-0.15,0.0,0.0,0.0,false,false,false,false,2,true)
			LocalPlayer["state"]:set("Bed",Selected[1],true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpBed")
AddEventHandler("target:UpBed",function()
	if LocalPlayer["state"]["Bed"] then
		DetachEntity(PlayerPedId(),false,false)
		FreezeEntityPosition(LocalPlayer["state"]["Bed"],true)
		DetachEntity(LocalPlayer["state"]["Bed"],false,false)
		LocalPlayer["state"]:set("Bed",false,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedDestroy")
AddEventHandler("target:BedDestroy",function(Selected)
	if not LocalPlayer["state"]["Commands"] and LocalPlayer["state"]["Paramedico"] then
		TriggerServerEvent("DeleteObject",Selected[3])
	else
		TriggerEvent("Notify",false,"Atenção","Você não pode fazer isso.","amarelo",5000)
	end
end)