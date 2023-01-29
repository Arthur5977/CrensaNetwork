-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("tablet",Creative)
vCLIENT = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Cars"] = {}
GlobalState["Bikes"] = {}
GlobalState["Rental"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Cars = {}
	local Bikes = {}
	local Rental = {}
	local Vehicles = VehicleGlobal()

	for Index,v in pairs(Vehicles) do
		if v["Mode"] == "Cars" then
			Cars[#Cars + 1] = { k = Index, name = v["Name"], price = v["Price"], chest = v["Weight"], tax = v["Price"] * 0.10 }
		elseif v["Mode"] == "Bikes" then
			Bikes[#Bikes + 1] = { k = Index, name = v["Name"], price = v["Price"], chest = v["Weight"], tax = v["Price"] * 0.10 }
		elseif v["Mode"] == "Rental" then
			Rental[#Rental + 1] = { k = Index, name = v["Name"], price = v["Gemstone"], chest = v["Weight"], tax = v["Price"] * 0.10 }
		end
	end

	GlobalState:set("Cars",Cars,true)
	GlobalState:set("Bikes",Bikes,true)
	GlobalState:set("Rental",Rental,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Rental(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			Active[Passport] = true

			local VehiclePrice = VehicleGemstone(Name)
			local Text = "Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..VehiclePrice.."</b> gemas?"

			if vRP.ConsultItem(Passport,"rentalveh",1) then
				Text = "Alugar o veículo <b>"..VehicleName(Name).."</b> usando o vale?"
			end

			if vRP.Request(source,Text,"Sim, concluír pagamento","Não, mudei de ideia") then
				if vRP.TakeItem(Passport,"rentalveh",1,true) or vRP.PaymentGems(Passport,VehiclePrice) then
					local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					if vehicle[1] then
						if vehicle[1]["rental"] <= os.time() then
							vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
							TriggerClientEvent("Notify",source,"Aviso","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.","verde",5000)
						else
							vRP.Query("vehicles/rentalVehiclesDays",{ Passport = Passport, vehicle = Name })
							TriggerClientEvent("Notify",source,"Aviso","Adicionado <b>30 Dias</b> de aluguel no veículo <b>"..VehicleName(Name).."</b>.","verde",5000)
						end
					else
						vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
						TriggerClientEvent("Notify",source,"Aviso","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.","verde",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>Gemas</b> insuficientes.","vermelho",5000)
				end
			end

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Buy(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			Active[Passport] = true

			if VehicleMode(Name) == "rental" or not VehicleMode(Name) then
				Active[Passport] = nil
				return
			end

			local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
			if vehicle[1] then
				TriggerClientEvent("Notify",source,"Aviso","Já possui um <b>"..VehicleName(Name).."</b>.","amarelo",3000)
				Active[Passport] = nil
				return
			else
				if VehicleMode(Name) == "work" then
					if vRP.PaymentFull(Passport,VehiclePrice(Name)) then
						vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
						TriggerClientEvent("Notify",source,"Aviso","Compra concluída.","verde",5000)
					end
				else
					local VehiclePrice = VehiclePrice(Name)
					if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(VehiclePrice).."</b> dólares?","Sim, concluír pagamento","Não, mudei de ideia") then
						if vRP.PaymentFull(Passport,VehiclePrice) then
							vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
							TriggerClientEvent("Notify",source,"Aviso","Compra concluída.","verde",5000)
						end
					end
				end
			end

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Start()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			Active[Passport] = true

			if not exports["hud"]:Wanted(Passport) then
				if vRP.Request(source,"Iniciar o teste por <b>$100</b> Dólares?","Sim, iniciar o teste","Não, volto depois") then
					if vRP.PaymentFull(Passport,100) then
						Player(source)["state"]["Route"] = Passport
						SetPlayerRoutingBucket(source,Passport)
						Active[Passport] = nil

						return true
					end
				end
			end

			Active[Passport] = nil
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.removeDrive()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Player(source)["state"]["Route"] = 0
		SetPlayerRoutingBucket(source,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)