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
Tunnel.bindInterface("garages",Creative)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Signal = {}
local Searched = {}
local Propertys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetCriminal(Passport) > 0 then
			TriggerClientEvent("Notify",source,"Aviso","Você foi denunciado, parece que suas digitais estão no banco de dados do governo como procurado.","amarelo",10000)

			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Service = vRP.NumPermission("Police")
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Digitais Encontrada", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alerta de procurado", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ServerVehicle(Model,x,y,z,Heading,Plate,Nitrox,Doors,Body,Fuel)
	local Vehicle = CreateVehicle(Model,x,y,z,Heading,true,true)

	while not DoesEntityExist(Vehicle) do
		Wait(100)
	end

	if DoesEntityExist(Vehicle) then
		if Plate ~= nil then
			SetVehicleNumberPlateText(Vehicle,Plate)
		else
			Plate = vRP.GeneratePlate()
			SetVehicleNumberPlateText(Vehicle,Plate)
		end

		SetVehicleBodyHealth(Vehicle,Body + 0.0)

		if not Fuel then
			TriggerEvent("engine:tryFuel",Plate,100)
		end

		if Doors then
			local Doors = json.decode(Doors)
			if Doors ~= nil then
				for Number,Status in pairs(Doors) do
					if Status then
						SetVehicleDoorBroken(Vehicle,parseInt(Number),true)
					end
				end
			end
		end

		local Network = NetworkGetNetworkIdFromEntity(Vehicle)

		if Model ~= "wheelchair" then
			local Network = NetworkGetEntityFromNetworkId(Network)
			SetVehicleDoorsLocked(Network,2)

			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = Nitrox or 0
			GlobalState:set("Nitro",Nitro,true)
		end

		return true,Network,Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	["1"] = { name = "Garage", payment = false },
	["2"] = { name = "Garage", payment = true },
	["3"] = { name = "Garage", payment = false },
	["4"] = { name = "Garage", payment = true },
	["5"] = { name = "Garage", payment = true },
	["6"] = { name = "Garage", payment = true },
	["7"] = { name = "Garage", payment = true },
	["8"] = { name = "Garage", payment = true },
	["9"] = { name = "Garage", payment = true },
	["10"] = { name = "Garage", payment = true },
	["11"] = { name = "Garage", payment = true },
	["12"] = { name = "Garage", payment = true },
	["13"] = { name = "Garage", payment = true },
	["14"] = { name = "Garage", payment = true },
	["15"] = { name = "Garage", payment = true },
	["16"] = { name = "Garage", payment = true },
	["17"] = { name = "Garage", payment = true },
	["18"] = { name = "Garage", payment = true },
	["19"] = { name = "Garage", payment = true },
	["20"] = { name = "Garage", payment = true },
	["21"] = { name = "Garage", payment = true },
	["22"] = { name = "Garage", payment = true },
	["23"] = { name = "Garage", payment = false },
	["24"] = { name = "Garage", payment = true },
	["25"] = { name = "Garage", payment = true },

	-- Paramedic
	["41"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["42"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["43"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["44"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["45"] = { name = "Paramedic", payment = false, perm = "Paramedic" },

	-- Police
	["61"] = { name = "Police", payment = false, perm = "Police" },
	["62"] = { name = "heliPolice", payment = false, perm = "Police" },

	["63"] = { name = "Police", payment = false, perm = "Police" },
	["64"] = { name = "heliPolice", payment = false, perm = "Police" },

	["65"] = { name = "Police", payment = false, perm = "Police" },
	["66"] = { name = "heliPolice", payment = false, perm = "Police" },

	["67"] = { name = "Police", payment = false, perm = "Police" },
	["68"] = { name = "busPolice", payment = false, perm = "Police" },

	["69"] = { name = "Police", payment = false, perm = "Police" },

	["70"] = { name = "Police", payment = false, perm = "Police" },
	["71"] = { name = "heliPolice", payment = false, perm = "Police" },
	["72"] = { name = "busPolice", payment = false, perm = "Police" },

	["91"] = { name = "Ballas", payment = true, perm = "Ballas" },
	["92"] = { name = "Families", payment = true, perm = "Families" },
	["93"] = { name = "Vagos", payment = true, perm = "Vagos" },
	["94"] = { name = "Aztecas", payment = true, perm = "Aztecas" },
	["95"] = { name = "Bloods", payment = true, perm = "Bloods" },
	["96"] = { name = "Triads", payment = true, perm = "Triads" },
	["97"] = { name = "Razors", payment = true, perm = "Razors" },

	-- Boats
	["121"] = { name = "Boats", payment = false },
	["122"] = { name = "Boats", payment = false },
	["123"] = { name = "Boats", payment = false },
	["124"] = { name = "Boats", payment = false },
	["125"] = { name = "Boats", payment = false },
	["126"] = { name = "Boats", payment = false },

	-- Works
	["141"] = { name = "Lumberman", payment = false },
	["142"] = { name = "Driver", payment = false },
	["143"] = { name = "Garbageman", payment = false },
	["144"] = { name = "Transporter", payment = false },
	["145"] = { name = "Taxi", payment = false },
	["146"] = { name = "TowDriver", payment = false },
	["147"] = { name = "Garbageman", payment = false },
	["148"] = { name = "Garbageman", payment = false },
	["149"] = { name = "Taxi", payment = false },
	["150"] = { name = "Trucker", payment = false }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("signalRemove",function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateReveryone",function(Plate)
	if GlobalState["Plates"][Plate] then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = nil
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateEveryone",function(Plate)
	local Plates = GlobalState["Plates"]
	Plates[Plate] = true
	GlobalState:set("Plates",Plates,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("platePlayers",function(Plate,Passport)
	if not vRP.PassportPlate(Plate) then
		local Plate = GlobalState["Plates"]
		Plate[Plate] = Passport
		GlobalState:set("Plates",Plate,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
	["Paramedic"] = {
		"lguard",
		"blazer2",
		"ambulance2",
		"firetruk"
	},
	["heliParamedic"] = {
		"maverick2"
	},
	["Police"] = {
		"polvic",
		"komodapol",
		"r1250pol",
		"nc700pol",
		"polchar",
		"ballerpol",
		"elegy2pol",
		"fugitivepol",
		"kurumapol",
		"oracle2pol",
		"police3pol",
		"policepol",
		"policetpol",
		"schafter2pol",
		"sheriff2pol",
		"sultanrspol",
		"tailgater2pol",
		"polcorv",
		"polchall",
		"poltang"
	},
	["heliPolice"] = {
		"maverick2"
	},
	["busPolice"] = {
		"pbus",
		"riot"
	},
	["Driver"] = {
		"bus"
	},
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["TowDriver"] = {
		"flatbed",
		"towtruck",
		"towtruck2"
	},
	["Garbageman"] = {
		"trash"
	},
	["Taxi"] = {
		"taxi"
	},
	["Trucker"] = {
		"hauler",
		"hauler2",
		"packer",
		"phantom"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles(Garage)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport) then
		if Garages[Garage]["perm"] then
			if not vRP.HasGroup(Passport,Garages[Garage]["perm"]) then
				return false
			end
		end

		if string.sub(Garage,1,9) == "Propertys" then
			local Consult = vRP.Query("propertys/Exist",{ name = Garage })
			if Consult[1] then
				if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) then
					if os.time() > Consult[1]["Tax"] then
						TriggerClientEvent("Notify",source,"Aviso","Aluguel atrasado, procure um <b>Corretor de Imóveis</b>.","amarelo",5000)
						return false
					end
				else
					return false
				end
			end
		end

		local Vehicle = {}
		local WorkVehicle = nil
		local Garage = Garages[Garage]["name"]
		if Works[Garage] then
			for _,v in pairs(Works[Garage]) do
				if VehicleExist(v) then
					local Consult = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
					for a,b in pairs(Consult) do
						if v == b["vehicle"] then
							WorkVehicle = b["vehicle"]
							Vehicle[#Vehicle + 1] = { ["Model"] = v, ["name"] = VehicleName(v), ["engine"] = b["engine"], ["body"] = b["body"], ["fuel"] = b["fuel"] }
						end
					end

					if v ~= WorkVehicle then
						Vehicle[#Vehicle + 1] = { ["Model"] = v, ["name"] = VehicleName(v), ["engine"] = 1000, ["body"] = 1000, ["fuel"] = 1000 }
					end
				end
			end
		else
			local Consult = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
			for _,v in pairs(Consult) do
				if VehicleExist(v["vehicle"]) then
					if v["work"] == "false" then
						Vehicle[#Vehicle + 1] = { ["Model"] = v["vehicle"], ["name"] = VehicleName(v["vehicle"]), ["engine"] = v["engine"], ["body"] = v["body"], ["fuel"] = v["fuel"] }
					end
				end
			end
		end

		return Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Impound()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })

		for Number,v in ipairs(Vehicle) do
			if v["arrest"] >= os.time() then
				Vehicles[#Vehicles + 1] = { ["Model"] = Vehicle[Number]["vehicle"], ["name"] = VehicleName(Vehicle[Number]["vehicle"]) }
			end
		end

		return Vehicles
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local VehiclePrice = VehiclePrice(Name)
		TriggerClientEvent("dynamic:closeSystem",source)

		if vRP.Request(source,"A liberação do veículo tem o custo de <b>$"..parseFormat(VehiclePrice * 0.25).."</b> dólares, deseja prosseguir com a liberação do mesmo?","Sim, efetuar o pagamento","Não, decido depois") then
			if vRP.PaymentFull(Passport,VehiclePrice * 0.25) then
				vRP.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = Name })
				TriggerClientEvent("Notify",source,"Aviso","Veículo liberado.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Tax")
AddEventHandler("garages:Tax",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] and Consult[1]["tax"] <= os.time() then
			local Price = VehiclePrice(Name) * 0.10

			if vRP.PaymentFull(Passport,Price) then
				vRP.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = Name })
				TriggerClientEvent("Notify",source,"Aviso","Pagamento concluído.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Sell")
AddEventHandler("garages:Sell",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "rental" or Mode == "work" then
			return
		end

		local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] then
			local Price = VehiclePrice(Name) * 0.5
			if vRP.Request(source,"Vender o veículo <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b>?","Sim, concluír venda","Não, mudei de ideia") then
				local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				if Consult[1] then
					vRP.GiveBank(Passport,Price)
					vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Chest:"..Passport..":"..Name })
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Transfer")
AddEventHandler("garages:Transfer",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local myVehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if myVehicle[1] then
			TriggerClientEvent("dynamic:closeSystem",source)

			local Keyboard = vKEYBOARD.keySingle(source,"Passaporte:")
			if Keyboard then
				local OtherPassport = parseInt(Keyboard[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					if vRP.Request(source,"Transferir o veículo <b>"..VehicleName(Name).."</b> para <b>"..Identity["name"].." "..Identity["name2"].."</b>?","Sim, transferir","Não, mudei de ideia") then
						local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = parseInt(OtherPassport), vehicle = Name })
						if Vehicle[1] then
							TriggerClientEvent("Notify",source,"Aviso","<b>"..Identity["name"].." "..Identity["name2"].."</b> já possui este modelo de veículo.","amarelo",5000)
						else
							vRP.Query("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = parseInt(OtherPassport), vehicle = Name })

							local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
							if parseInt(#Datatable) > 0 then
								vRP.Query("entitydata/SetData",{ dkey = "Mods:"..OtherPassport..":"..Name, dvalue = Datatable[1]["dvalue"] })
								vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
							end

							local Datatable = vRP.GetSrvData("Chest:"..Passport..":"..Name)
							vRP.SetSrvData("Chest:"..OtherPassport..":"..Name,Datatable)
							vRP.RemSrvData("Chest:"..Passport..":"..Name)

							TriggerClientEvent("Notify",source,"Aviso","Transferência concluída.","verde",5000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Spawn")
AddEventHandler("garages:Spawn",function(Table,Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local splitName = splitString(Table,"-")
		local garageName = splitName[2]
		local Name = splitName[1]

		local Gemstone = VehicleGemstone(Name)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })

		if not vehicle[1] then
			if parseInt(Gemstone) > 0 then
				if vRP.Request(source,"Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.."</b> gemas?","Sim, concluír aluguel","Não, mudei de ideia") then
					if vRP.PaymentGems(Passport,Gemstone) then
						vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
						TriggerClientEvent("Notify",source,"Aviso","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.","verde",5000)
						vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					else
						TriggerClientEvent("Notify",source,"Aviso","<b>Gemas</b> insuficientes.","vermelho",5000)
						return
					end
				else
					return
				end
			else
				local VehiclePrice = VehiclePrice(Name)
				if parseInt(VehiclePrice) > 0 then
					if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(VehiclePrice).."</b> dólares?","Sim, concluír pagamento","Não, mudei de ideia") then
						if vRP.PaymentFull(Passport,VehiclePrice) then
							vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
							vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
						else
							TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
						end
					else
						return
					end
				else
					vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
					vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				end
			end
		end

		if vehicle[1] then
			local Plates = GlobalState["Plates"]
			local Plate = vehicle[1]["plate"]

			if Spawn[Plate] then
				if not Signal[Plate] then
					if not Searched[Passport] then
						Searched[Passport] = os.time()
					end

					if os.time() >= parseInt(Searched[Passport]) then
						Searched[Passport] = os.time() + 60

						local Network = Spawn[Plate][3]
						local Network = NetworkGetEntityFromNetworkId(Network)
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							vCLIENT.SearchBlip(source,GetEntityCoords(Network))
							TriggerClientEvent("Notify",source,"Aviso","Rastreador do veículo foi ativado por <b>30</b> segundos, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.","amarelo",10000)
						else
							if Spawn[Plate] then
								Spawn[Plate] = nil
							end

							if Plates[Plate] then
								Plates[Plate] = nil
								GlobalState:set("Plates",Plates,true)
							end

							TriggerClientEvent("Notify",source,"Aviso","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.","verde",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Rastreador só pode ser ativado a cada <b>60</b> segundos.","amarelo",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Rastreador está desativado.","amarelo",5000)
				end
			else
				if vehicle[1]["tax"] <= os.time() then
					TriggerClientEvent("Notify",source,"Aviso","Taxa do veículo atrasada.","amarelo",5000)
				elseif vehicle[1]["arrest"] >= os.time() then
					TriggerClientEvent("Notify",source,"Aviso","Veículo apreendido, dirija-se até o <b>Impound</b> e efetue o pagamento da liberação do mesmo.","amarelo",5000)
				else
					if vehicle[1]["rental"] ~= 0 then
						if vehicle[1]["rental"] <= os.time() then
							if vRP.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.." gemas</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
								if vRP.PaymentGems(Passport,Gemstone) then
									vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
									TriggerClientEvent("Notify",source,"Aviso","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.","verde",5000)
								else
									TriggerClientEvent("Notify",source,"Aviso","<b>Gemas</b> insuficientes.","vermelho",5000)
									return
								end
							else
								return
							end
						end
					end

					local Coords = vCLIENT.SpawnPosition(source,Number)
					if Coords then
						local Mods = nil
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
						if parseInt(#Datatable) > 0 then
							Mods = Datatable[1]["dvalue"]
						end

						if Garages[Number]["payment"] then
							if vRP.UserPremium(Passport) then
								TriggerClientEvent("dynamic:closeSystem",source)
								local Exist,Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

								if Exist then
									vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
									TriggerClientEvent("Notify",source,false,CompleteTimers(vehicle[1]["tax"] - os.time()),"azul",1000)
									TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
									Spawn[Plate] = { Passport,Name,Network }

									Plates[Plate] = Passport
									GlobalState:set("Plates",Plates,true)
								end
							else
								local VehiclePrice = VehiclePrice(Name)
								if vRP.Request(source,"Retirar o veículo por <b>$"..parseFormat(VehiclePrice * 0.05).."</b> dólares?","Sim, efetuar o pagamento","Não, volto depois") then
									if vRP.PaymentCard(Passport,VehiclePrice * 0.05) then
										TriggerClientEvent("dynamic:closeSystem",source)
										local Exist,Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

										if Exist then
											vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
											TriggerClientEvent("Notify",source,false,CompleteTimers(vehicle[1]["tax"] - os.time()),"azul",1000)
											TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
											Spawn[Plate] = { Passport,Name,Network }

											Plates[Plate] = Passport
											GlobalState:set("Plates",Plates,true)
										end
									end
								end
							end
						else
							TriggerClientEvent("dynamic:closeSystem",source)
							local Exist,Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

							if Exist then
								vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
								TriggerClientEvent("Notify",source,false,CompleteTimers(vehicle[1]["tax"] - os.time()),"azul",1000)
								TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
								Spawn[Plate] = { Passport,Name,Network }

								Plates[Plate] = Passport
								GlobalState:set("Plates",Plates,true)
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") and Message[1] then
			local VehicleName = Message[1]
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			local Plate = "VEH"..(10000 + Passport)
			local Exist,Network,Vehicle = Creative.ServerVehicle(VehicleName,Coords["x"],Coords["y"],Coords["z"],Heading,Plate,2000,nil,1000)

			if not Exist then
				return
			end

			vCLIENT.CreateVehicle(-1,VehicleName,Network,1000,1000,nil,false,false)
			Spawn[Plate] = { Passport,VehicleName,Network }
			TriggerEvent("engine:tryFuel",Plate,100)
			SetPedIntoVehicle(Ped,Vehicle,-1)

			local Plates = GlobalState["Plates"]
			Plates[Plate] = Passport
			GlobalState:set("Plates",Plates,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("garages:Delete",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Key")
AddEventHandler("garages:Key",function(entity)
	local source = source
	local Plate = entity[1]
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		vRP.GenerateItem(Passport,"vehkey-"..Plate,1,true,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		TriggerEvent("garages:LockVehicle",source,Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle",function(source,Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	local Doors = GetVehicleDoorLockStatus(Network)

	if parseInt(Doors) <= 1 then
		TriggerClientEvent("Notify",source,"Aviso","Veículo trancado.","verde",5000)
		TriggerClientEvent("sounds:Private",source,"locked",0.7)
		SetVehicleDoorsLocked(Network,2)
	else
		TriggerClientEvent("Notify",source,"Aviso","Veículo destrancado.","amarelo",5000)
		TriggerClientEvent("sounds:Private",source,"unlocked",0.7)
		SetVehicleDoorsLocked(Network,1)
	end

	if not vRPC.InsideVehicle(source) then
		vRPC.PlayAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
		Wait(350)
		vRPC.StopAnim(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Delete(Network,Health,Engine,Body,Fuel,Doors,Windows,Tyres,Plate)
	if Spawn[Plate] then
		local Passport = Spawn[Plate][1]
		local Name = Spawn[Plate][2]

		if parseInt(Engine) <= 100 then
			Engine = 100
		end

		if parseInt(Body) <= 100 then
			Body = 100
		end

		if parseInt(Fuel) >= 100 then
			Fuel = 100
		end

		if parseInt(Fuel) <= 0 then
			Fuel = 0
		end

		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if vehicle[1] ~= nil then
			vRP.Query("vehicles/updateVehicles",{ Passport = Passport, vehicle = Name, nitro = GlobalState["Nitro"][Plate] or 0, engine = parseInt(Engine), body = parseInt(Body), health = parseInt(Health), fuel = parseInt(Fuel), doors = json.encode(Doors), windows = json.encode(Windows), tyres = json.encode(Tyres) })
		end
	end

	TriggerEvent("garages:deleteVehicle",Network,Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(Network,Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates",Plates,true)
		end

		if GlobalState["Nitro"][Plate] then
			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = nil
			GlobalState:set("Nitro",Nitro,true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		if string.sub(Plate,1,4) == "DISM" then
			local Passport = parseInt(string.sub(Plate,5,8)) - 1000
			local source = vRP.Source(Passport)
			if source then
				TriggerClientEvent("inventory:Disreset",source)
				TriggerClientEvent("Notify",source,"Aviso","O veículo do seu contrato foi encaminhado para o <b>Impound</b> e o <b>Lester</b> disse que você pode assinar um novo contrato quando quiser.","amarelo",10000)
			end
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:closeSystem",source)
		TriggerClientEvent("Notify",source,"Aviso","Selecione o local da garagem.","amarelo",5000)

		local Hash = "prop_offroad_tyres02"
		local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
		if Application then
			if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
				TriggerClientEvent("Notify",source,"Aviso","Selecione o local do veículo.","amarelo",5000)

				local Open = Coords
				local Hash = "patriot"
				local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
				if Application then
					if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
						local New = {
							["1"] = { mathLength(Open["x"]),mathLength(Open["y"]),mathLength(Open["z"] + 1) },
							["2"] = { mathLength(Coords["x"]),mathLength(Coords["y"]),mathLength(Coords["z"] + 1),mathLength(Heading) }
						}

						Garages[Name] = { name = "Garage", payment = false }

						Propertys[Name] = {
							["x"] = New["1"][1],
							["y"] = New["1"][2],
							["z"] = New["1"][3],
							["1"] = New["2"]
						}

						vRP.Query("propertys/Garage",{ name = Name, garage = json.encode(New) })
						TriggerClientEvent("garages:Propertys",-1,Propertys)
					else
						TriggerClientEvent("Notify",source,"Aviso","A garagem precisa ser próximo da entrada.","amarelo",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","A garagem precisa ser próximo da entrada.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.Query("propertys/Garages")
	for _,v in pairs(Consult) do
		local Name = v["Name"]
		if not Propertys[Name] and v["Garage"] ~= "{}" then
			local Table = json.decode(v["Garage"])
			Garages[Name] = { name = "Garage", payment = false }

			Propertys[Name] = {
				["x"] = Table["1"][1],
				["y"] = Table["1"][2],
				["z"] = Table["1"][3],
				["1"] = Table["2"]
			}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal",function(Plate)
	return Signal[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("garages:Propertys",source,Propertys)
end)