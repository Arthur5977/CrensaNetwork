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
Tunnel.bindInterface("towdriver",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local userList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.toggleService()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if userList[Passport] then
			userList[Passport] = nil
		else
			userList[Passport] = source
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWDRIVER:CALL
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("towdriver:Call",function(source,vehName,Plate)
	local Ped = GetPlayerPed(source)
	if DoesEntityExist(Ped) then
		local Coords = GetEntityCoords(Ped)

		for k,v in pairs(userList) do
			async(function()
				TriggerClientEvent("NotifyPush",v,{ code = 51, title = "Registro de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 33 })
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.paymentMethod(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		TriggerEvent("garages:deleteVehicle",Network,Plate)

		if (vRP.InventoryWeight(Passport) + 3) <= vRP.GetWeight(Passport) then
			local VehParts = math.random(4)
			local VehSelected = "suspension"
			local AmountItens = math.random(4,5)
			local Tow = vRP.GetExperience(Passport,"Tows")
			local Class = ClassCategory(Tow)
			local VehRandom = 1000

			if Class == "B" or Class == "B+" then
				VehRandom = math.random(4500)
			elseif Class == "A" or Class == "A+" then
				VehRandom = math.random(3500)
			elseif Class == "S" or Class == "S+" then
				VehRandom = math.random(2500)
			end

			if VehParts <= 1 then
				VehSelected = "engine"
			elseif VehParts == 2 then
				VehSelected = "transmission"
			elseif VehParts == 3 then
				VehSelected = "brake"
			end

			if VehRandom <= 10 then
				vRP.GenerateItem(Passport,VehSelected.."e",1,true)
			elseif VehRandom >= 10 and VehRandom <= 30 then
				vRP.GenerateItem(Passport,VehSelected.."d",1,true)
			elseif VehRandom >= 31 and VehRandom <= 60 then
				vRP.GenerateItem(Passport,VehSelected.."c",1,true)
			elseif VehRandom >= 61 and VehRandom <= 100 then
				vRP.GenerateItem(Passport,VehSelected.."b",1,true)
			elseif VehRandom >= 101 and VehRandom <= 150 then
				vRP.GenerateItem(Passport,VehSelected.."a",1,true)
			end

			vRP.GenerateItem(Passport,"plastic",AmountItens,true)
			vRP.GenerateItem(Passport,"glass",AmountItens,true)
			vRP.GenerateItem(Passport,"rubber",AmountItens,true)
			vRP.GenerateItem(Passport,"copper",AmountItens,true)
			vRP.GenerateItem(Passport,"aluminum",AmountItens,true)

			vRP.PutExperience(Passport,"Tows",math.random(2,3))
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end

		Active[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWDRIVER:SERVERTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("towdriver:ServerTow")
AddEventHandler("towdriver:ServerTow",function(veh01,veh02,mode)
	local source = source
	local Players = vRPC.Players(source)
	for _,v in pairs(Players) do
		async(function()
			TriggerClientEvent("towdriver:ClientTow",v,veh01,veh02,mode)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if userList[Passport] then
		userList[Passport] = nil
	end

	if Active[Passport] then
		Active[Passport] = nil
	end
end)