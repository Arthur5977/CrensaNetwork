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
Tunnel.bindInterface("inspect",Creative)
vCLIENT = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local openPlayer = {}
local openSource = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runInspect")
AddEventHandler("police:runInspect",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		openSource[Passport] = Entity[1]
		openPlayer[Passport] = vRP.Passport(Entity[1])

		TriggerClientEvent("player:Carry",Entity[1],source,"handcuff")
		TriggerClientEvent("player:Commands",Entity[1],true)
		TriggerClientEvent("inventory:Close",Entity[1])
		TriggerClientEvent("inspect:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Request()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local myInventory = {}
		local inventory = vRP.Inventory(Passport)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myInventory[k] = v
		end

		local otherInventory = {}
		local inventory = vRP.Inventory(openPlayer[Passport])
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			otherInventory[k] = v
		end

		return myInventory,otherInventory,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.InventoryWeight(openPlayer[Passport]),vRP.GetWeight(openPlayer[Passport])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Reset()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			TriggerClientEvent("player:Commands",openSource[Passport],false)
			TriggerClientEvent("player:Carry",openSource[Passport],source)
			openSource[Passport] = nil
		end

		if openPlayer[Passport] then
			openPlayer[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if vRP.MaxItens(openPlayer[Passport],Item,Amount) then
					TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",3000)
					TriggerClientEvent("inspect:Update",source,"Request")
					return
				end

				if (vRP.InventoryWeight(openPlayer[Passport]) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(openPlayer[Passport]) then
					if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
						vRP.GiveItem(openPlayer[Passport],Item,Amount,true,Target)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					TriggerClientEvent("inspect:Update",source,"Request")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			if DoesEntityExist(GetPlayerPed(openSource[Passport])) then
				if vRP.MaxItens(Passport,Item,Amount) then
					TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",3000)
					TriggerClientEvent("inspect:Update",source,"Request")
					return
				end

				if (vRP.InventoryWeight(Passport) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(Passport) then
					if vRP.TakeItem(openPlayer[Passport],Item,Amount,true,Slot) then
						vRP.GiveItem(Passport,Item,Amount,false,Target)
						TriggerClientEvent("inspect:Update",source,"Request")
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					TriggerClientEvent("inspect:Update",source,"Request")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if vRP.invUpdate(openPlayer[Passport],Slot,Target,Amount) then
					TriggerClientEvent("inspect:Update",source,"Request")
				end
			end
		end
	end
end