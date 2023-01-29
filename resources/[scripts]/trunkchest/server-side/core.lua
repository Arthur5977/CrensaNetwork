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
Tunnel.bindInterface("trunkchest",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.openChest()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Vehicle[Passport] then
		local myInfos = {}
		local Inventory = vRP.Inventory(Passport)
		for k,v in pairs(Inventory) do
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

			myInfos[k] = v
		end

		local vehInfos = {}
		local Result = vRP.GetSrvData(Vehicle[Passport]["Data"])
		for k,v in pairs(Result) do
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

			vehInfos[k] = v
		end

		return myInfos,vehInfos,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Vehicle[Passport]["Weight"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHS
-----------------------------------------------------------------------------------------------------------------------------------------
local storeVehs = {
	["ratloader"] = {
		["woodlog"] = true
	},
	["stockade"] = {
		["pouch"] = true
	},
	["trash"] = {
		["glassbottle"] = true,
		["plasticbottle"] = true,
		["elastic"] = true,
		["metalcan"] = true,
		["battery"] = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end

		if vRP.UpdateChest(Passport,Vehicle[Passport]["Data"],Slot,Target,Amount) then
			TriggerClientEvent("trunkchest:Update",source,"Request")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end
		local vehName = Vehicle[Passport]["Model"]

		if (storeVehs[vehName] and not storeVehs[vehName][Item]) or Item == "dollars" or itemBlock(Item) then
			TriggerClientEvent("trunkchest:Update",source,"Request")
			TriggerClientEvent("Notify",source,"Aviso","Armazenamento proibido.","amarelo",5000)
			goto scapeInventory
		end

		if vRP.StoreChest(Passport,Vehicle[Passport]["Data"],Amount,Vehicle[Passport]["Weight"],Slot,Target) then
			TriggerClientEvent("trunkchest:Update",source,"Request")
		else
			if Vehicle[Passport] then
				local Result = vRP.GetSrvData(Vehicle[Passport]["Data"])
				TriggerClientEvent("trunkchest:UpdateWeight",source,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Vehicle[Passport]["Weight"])
			end
		end
	end

	::scapeInventory::
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end

		if vRP.TakeChest(Passport,Vehicle[Passport]["Data"],Amount,Slot,Target) then
			TriggerClientEvent("trunkchest:Update",source,"Request")
		else
			if Vehicle[Passport] then
				local Result = vRP.GetSrvData(Vehicle[Passport]["Data"])
				TriggerClientEvent("trunkchest:UpdateWeight",source,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Vehicle[Passport]["Weight"])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.chestClose()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Vehicle[Passport] then
		TriggerClientEvent("player:syncDoorsOptions",source,Vehicle[Passport]["Net"],"close")
		Vehicle[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:OPENTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trunkchest:openTrunk")
AddEventHandler("trunkchest:openTrunk",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if VehicleChest(Entity[2]) > 0 then
			local PassportPlate = vRP.PassportPlate(Entity[1])

			if PassportPlate then
				Vehicle[Passport] = {
					["Net"] = Entity[4],
					["Plate"] = Entity[1],
					["Model"] = Entity[2],
					["User"] = PassportPlate["Passport"],
					["Weight"] = VehicleChest(Entity[2]),
					["Data"] = "Chest:"..PassportPlate["Passport"]..":"..Entity[2]
				}

				local Network = NetworkGetEntityFromNetworkId(Vehicle[Passport]["Net"])

				if GetVehicleDoorLockStatus(Network) <= 1 then
					TriggerClientEvent("trunkchest:Open",source)
					TriggerClientEvent("player:syncDoorsOptions",source,Vehicle[Passport]["Net"],"open")
				else
					TriggerClientEvent("Notify",source,"Aviso","Veículo trancado.","amarelo",5000)
					Vehicle[Passport] = nil
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Vehicle[Passport] then
		Vehicle[Passport] = nil
	end
end)