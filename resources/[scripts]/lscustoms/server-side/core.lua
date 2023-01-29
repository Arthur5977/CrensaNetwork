-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("lscustoms",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPermission(Permission)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetCriminal(Passport) > 0 then
			TriggerClientEvent("Notify",source,"Aviso","Você foi denunciado, parece que suas digitais estão no banco de dados do governo como procurado.","amarelo",10000)

			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Service = vRP.NumPermission("Policia")
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Digitais Encontrada", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alerta de procurado", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end
		end

		if exports["hud"]:Wanted(Passport,source) then
			return false
		end

		if not Permission then
			return true
		else
			if vRP.HasGroup(Passport,Permission) then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:attemptPurchase")
AddEventHandler("lscustoms:attemptPurchase",function(type,mod)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
			local Price = vehicleCustomisationPrices[type][mod]

			if vRP.PaymentFull(Passport,Price) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		else
			if vRP.PaymentFull(Passport,vehicleCustomisationPrices[type]) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:updateVehicle")
AddEventHandler("lscustoms:updateVehicle",function(Mods,Plate,vehName)
	local Passport = vRP.PassportPlate(Plate)
	if Passport then
		vRP.Query("entitydata/SetData",{ dkey = "Mods:"..Passport["Passport"]..":"..vehName, dvalue = json.encode(Mods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local inVehicle = {}
RegisterServerEvent("lscustoms:inVehicle")
AddEventHandler("lscustoms:inVehicle",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Network then
			if inVehicle[Passport] then
				inVehicle[Passport] = nil
			end
		else
			inVehicle[Passport] = { Network,Plate }
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if inVehicle[Passport] then
		Wait(1000)
		TriggerEvent("garages:deleteVehicle",inVehicle[Passport][1],inVehicle[Passport][2])
		inVehicle[Passport] = nil
	end
end)