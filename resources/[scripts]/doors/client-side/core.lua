-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Display = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(GlobalState["Doors"]) do
		if IsDoorRegisteredWithSystem(Number) then
			RemoveDoorFromSystem(Number)
		end

		AddDoorToSystem(Number,v["Hash"],v["Coords"],false,false,true)

		DoorSystemSetOpenRatio(Number,0.0,false,false)
		DoorSystemSetAutomaticRate(Number,1.0,false,false)
		DoorSystemSetDoorState(Number,v["Lock"] and 1 or 0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Doors",nil,function(Name,Key,Value)
	for Number,v in pairs(Value) do
		DoorSystemSetOpenRatio(Number,0.0,false,false)
		DoorSystemSetAutomaticRate(Number,1.0,false,false)
		DoorSystemSetDoorState(Number,v["Lock"] and 1 or 0,true)

		if v["Other"] then
			DoorSystemSetDoorState(v["Other"],v["Lock"] and 1 or 0,true)
																				  
		end

		if Display[Number] then
			SendNUIMessage({ Action = "Doors", Status = true, Text = v["Lock"] and "Trancado" or "Destrancado" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for Number,v in pairs(GlobalState["Doors"]) do
				if #(Coords - v["Coords"]) <= v["Distance"] then
									 
					TimeDistance = 1

					if not Display[Number] then
						SendNUIMessage({ Action = "Doors", Status = true, Text = v["Lock"] and "Trancado" or "Destrancado" })
						Display[Number] = true
					end

					if IsControlJustPressed(1,38) then
						vSERVER.Permission(Number)
					end
				else
					if Display[Number] then
						SendNUIMessage({ Action = "Doors", Status = false })
						Display[Number] = nil
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)