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
Tunnel.bindInterface("propertys",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lock = {}
local Inside = {}
local Markers = {}
local RoutePropertys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Propertys(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) or Lock[Name] then
				if os.time() > Consult[1]["Tax"] then
					if vRP.Request(source,"Hipoteca atrasada, deseja efetuar o pagamento?","Sim, concluir pagamento","Não, pago depois") then
						if vRP.PaymentFull(Passport,Informations[Consult[1]["Interior"]]["Price"] * 0.1) then
							vRP.Query("propertys/Tax",{ name = Name })
							TriggerClientEvent("Notify",source,"Aviso","Pagamento concluído.","amarelo",5000)
						end
					end
				else
					Consult[1]["Tax"] = MinimalTimers(Consult[1]["Tax"] - os.time())
					return "Player",Consult[1]
				end
			end
		else
			return "Corretor",Informations
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Toggle")
AddEventHandler("propertys:Toggle",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Inside[Passport] then
			Inside[Passport] = nil
			SetPlayerRoutingBucket(source,0)
			Player(source)["state"]["Route"] = 0
		else
			Inside[Passport] = Name
			SetPlayerRoutingBucket(source,RoutePropertys[Name])
			Player(source)["state"]["Route"] = RoutePropertys[Name]
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Buy")
AddEventHandler("propertys:Buy",function(Name)
	local source = source
	local Split = splitString(Name,"-")
	local Passport = vRP.Passport(source)
	if Passport then
		local Name = Split[1]
		local Interior = Split[2]
		local BuyMethod = Split[3]
		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if not Consult[1] then
			TriggerClientEvent("dynamic:closeSystem",source)

			if BuyMethod == "Gemstone" then
				if vRP.Request(source,"Deseja comprar a propriedade com <b>Gemas</b>?","Sim, assinar papelada","Não, mudeia de ideia") then
					if vRP.PaymentGems(Passport,Informations[Interior]["Gemstone"]) then
						Markers[Name] = true
						local Serial = PropertysSerials()
						vRP.GiveItem(Passport,"propertys-"..Serial,3,true)
						TriggerClientEvent("propertys:Markers",-1,Markers)
						vRP.Query("propertys/Buy",{ name = Name, interior = Interior, passport = Passport, serial = Serial, vault = Informations[Interior]["Vault"], fridge = Informations[Interior]["Fridge"], tax = os.time() + 2592000 })
					else
						TriggerClientEvent("Notify",source,"Aviso","<b>Gemas</b> insuficientes.","vermelho",5000)
					end
				end
			elseif BuyMethod == "Dollars" then
				if vRP.Request(source,"Deseja comprar a propriedade com <b>Dólares</b>?","Sim, assinar papelada","Não, mudeia de ideia") then
					if vRP.PaymentFull(Passport,Informations[Interior]["Price"]) then
						Markers[Name] = true
						local Serial = PropertysSerials()
						vRP.GiveItem(Passport,"propertys-"..Serial,3,true)
						TriggerClientEvent("propertys:Markers",-1,Markers)
						vRP.Query("propertys/Buy",{ name = Name, interior = Interior, passport = Passport, serial = Serial, vault = Informations[Interior]["Vault"], fridge = Informations[Interior]["Fridge"], tax = os.time() + 2592000 })
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Lock")
AddEventHandler("propertys:Lock",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) then
				if Lock[Name] then
					Lock[Name] = nil
					TriggerClientEvent("Notify",source,"Aviso","Propriedade trancada.","amarelo",5000)
				else
					Lock[Name] = true
					TriggerClientEvent("Notify",source,"Aviso","Propriedade destrancada.","amarelo",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Sell")
AddEventHandler("propertys:Sell",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport then
				TriggerClientEvent("dynamic:closeSystem",source)

				if vRP.Request(source,"Deseja vender a propriedade?","Sim, concluir a venda","Não, mudeia de ideia") then
					if Markers[Name] then
						Markers[Name] = nil
						TriggerClientEvent("propertys:Markers",-1,Markers)
					end

					vRP.RemSrvData("Vault:"..Name)
					vRP.RemSrvData("Fridge:"..Name)

					vRP.Query("propertys/Sell",{ name = Name })
					TriggerClientEvent("Notify",source,"Aviso","Venda concluída.","amarelo",5000)
					vRP.GiveBank(Passport,Informations[Consult[1]["Interior"]]["Price"] * 0.75)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CREDENTIALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Credentials")
AddEventHandler("propertys:Credentials",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport then
				TriggerClientEvent("dynamic:closeSystem",source)

				if vRP.Request(source,"Você escolheu reconfigurar todos os cartões de segurança, lembrando que ao prosseguir todos os cartões vão deixar de funcionar, deseja prosseguir?","Sim, prosseguir","Não, outra hora") then
					local Serial = PropertysSerials()
					vRP.Query("propertys/Credentials",{ name = Name, serial = Serial })
					vRP.GiveItem(Passport,"propertys-"..Serial,Consult[1]["Keys"],true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Clothes()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Clothes = {}
		local Consult = vRP.GetSrvData("Wardrobe:"..Passport)

		for Table,_ in pairs(Consult) do
			Clothes[#Clothes + 1] = { ["name"] = Table }
		end

		return Clothes
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Clothes")
AddEventHandler("propertys:Clothes",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Split = splitString(Mode,"-")
		local Consult = vRP.GetSrvData("Wardrobe:"..Passport)
		local Name = Split[2]

		if Split[1] == "save" then
			local Keyboard = vKEYBOARD.keySingle(source,"Salvar como:")
			if Keyboard then
				local Name = Keyboard[1]

				if not Consult[Name] then
					Consult[Name] = vSKINSHOP.Customization(source)
					vRP.SetSrvData("Wardrobe:"..Passport,Consult)
					TriggerClientEvent("propertys:ClothesReset",source)
					TriggerClientEvent("Notify",source,"Aviso","<b>"..Name.."</b> adicionado.","verde",5000)
				else
					TriggerClientEvent("Notify",source,"Aviso","Nome escolhido já existe em seu armário.","amarelo",5000)
				end
			end
		elseif Split[1] == "delete" then
			if Consult[Name] ~= nil then
				Consult[Name] = nil
				vRP.SetSrvData("Wardrobe:"..Passport,Consult)
				TriggerClientEvent("propertys:ClothesReset",source)
				TriggerClientEvent("Notify",source,"Aviso","<b>"..Name.."</b> removido.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","A vestimenta salva não se encontra mais em seu armário.","amarelo",5000)
			end
		elseif Split[1] == "apply" then
			if Consult[Name] ~= nil then
				TriggerClientEvent("updateRoupas",source,Consult[Name])
				TriggerClientEvent("Notify",source,"Aviso","<b>"..Name.."</b> aplicado.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","A vestimenta salva não se encontra mais em seu armário.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYSSERIALS
-----------------------------------------------------------------------------------------------------------------------------------------
function PropertysSerials()
	local Serial = vRP.GenerateString("LDLDLDLDLD")
	local Consult = vRP.Query("propertys/Serial",{ serial = Serial })
	if Consult[1] then
		PropertysSerials()
	end

	return Serial
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenChest(Name,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Chest = {}
		local Inventory = {}
		local Inv = vRP.Inventory(Passport)
		local Consult = vRP.GetSrvData(Mode..":"..Name)

		for k,v in pairs(Inv) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Inventory[k] = v
		end

		for k,v in pairs(Consult) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Chest[k] = v
		end

		local Exist = vRP.Query("propertys/Exist",{ name = Name })
		if Exist[1] then
			return Inventory,Chest,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Consult),Exist[1][Mode]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if itemBlock(Item) or (Mode == "Vault" and BlockChest(Item)) or (Mode == "Fridge" and not BlockChest(Item)) then
			TriggerClientEvent("propertys:Update",source)
			return
		end

		local Consult = vRP.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if Item == "diagram" then
				if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
					vRP.Query("propertys/"..Mode,{ name = Name, weight = 10 * Amount })
					TriggerClientEvent("propertys:Update",source)
				end
			else
				if vRP.StoreChest(Passport,Mode..":"..Name,Amount,Consult[1][Mode],Slot,Target) then
					TriggerClientEvent("propertys:Update",source)
				else
					local Result = vRP.GetSrvData(Mode..":"..Name)
					TriggerClientEvent("propertys:Weight",source,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Consult[1][Mode])
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if vRP.TakeChest(Passport,Mode..":"..Name,Amount,Slot,Target) then
			TriggerClientEvent("propertys:Update",source)
		else
			local Consult = vRP.Query("propertys/Exist",{ name = Name })
			if Consult[1] then
				local Result = vRP.GetSrvData(Mode..":"..Name)
				TriggerClientEvent("propertys:Weight",source,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Consult[1][Mode])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if vRP.UpdateChest(Passport,Mode..":"..Name,Slot,Target,Amount) then
			TriggerClientEvent("propertys:Update",source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("propertys:Table",source,Propertys,Interiors,Markers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Inside[Passport] then
		vRP.InsidePropertys(Passport,Propertys[Inside[Passport]])
		Inside[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	local Consult = vRP.Query("propertys/All")

	for Index,v in pairs(Consult) do
		Markers[v["Name"]] = true
	end
	
	local RouteSelect = 0
	for k,v in pairs(Propertys) do
		RouteSelect = RouteSelect + 1
		RoutePropertys[k] = RouteSelect
	end

	TriggerClientEvent("propertys:Table",-1,Propertys,Interiors,Markers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen",function(Passport,source)
	local Consult = vRP.Query("propertys/AllUser",{ Passport = Passport })
	if Consult[1] then
		local Tables = {}

		for _,v in pairs(Consult) do
			local Name = v["Name"]
			if Propertys[Name] then
				Tables[#Tables + 1] = { ["Coords"] = Propertys[Name] }
			end
		end

		TriggerClientEvent("spawn:Increment",source,Tables)
	end
end)