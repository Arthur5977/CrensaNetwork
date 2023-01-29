-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Actived = {}
local srvData = {}
local selfReturn = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ConsultItem(Passport,Item,Amount)
	if vRP.Source(Passport) then
		if Amount > vRP.InventoryItemAmount(Passport,Item)[1] then
			return false
		elseif vRP.CheckDamaged(vRP.InventoryItemAmount(Passport,Item)[2]) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.GetWeight(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["weight"] == nil then
			Datatable["weight"] = BackpackWeightDefault
		end

		return Datatable["weight"]
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.SetWeight(Passport,Amount)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["weight"] == nil then
			Datatable["weight"] = BackpackWeightDefault
		end

		Datatable["weight"] = Datatable["weight"] + parseInt(Amount)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.RemWeight(Passport,Amount)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["weight"] == nil then
			Datatable["weight"] = BackpackWeightDefault
		end

		Datatable["weight"] = Datatable["weight"] - parseInt(Amount)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPSLOT	
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.SwapSlot(Passport,Slot,Target)
	local inventory = vRP.Inventory(Passport)
	if inventory then
		local temporary = inventory[tostring(Slot)]
		inventory[tostring(Slot)] = inventory[tostring(Target)]
		inventory[tostring(Target)] = temporary
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryWeight(Passport)
	local totalWeight = 0
	local inventory = vRP.Inventory(Passport)

	for k,v in pairs(inventory) do
		if itemBody(v["item"]) then
			totalWeight = totalWeight + itemWeight(v["item"]) * parseInt(v["amount"])
		end
	end

	return totalWeight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKBROKEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CheckDamaged(nameItem)
	local splitName = splitString(nameItem,"-")
	if splitName[2] ~= nil then
		if itemDurability(nameItem) then
			local maxDurability = 86400 * itemDurability(nameItem)
			local actualDurability = parseInt(os.time() - splitName[2])
			local newDurability = (maxDurability - actualDurability) / maxDurability
			local actualPercent = parseInt(newDurability * 100)

			if actualPercent <= 1 then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ChestWeight(chestData)
	local totalWeight = 0

	for k,v in pairs(chestData) do
		if itemBody(v["item"]) then
			totalWeight = totalWeight + itemWeight(v["item"]) * parseInt(v["amount"])
		end
	end

	return totalWeight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryItemAmount(Passport,nameItem)
	local inventory = vRP.Inventory(Passport)

	for k,v in pairs(inventory) do
		local splitName01 = splitString(nameItem,"-")
		local splitName02 = splitString(v["item"],"-")
		if splitName01[1] == splitName02[1] then
			return { parseInt(v["amount"]),v["item"] }
		end
	end

	return { 0,"" }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryFull(Passport,Item)
	if vRP.Source(Passport) then
		for k,v in pairs(vRP.Inventory(Passport)) do
			if v.item == Item then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ItemAmount(Passport,nameItem)
	local totalAmount = 0
	local splitName = splitString(nameItem,"-")
	local inventory = vRP.Inventory(Passport)

	for k,v in pairs(inventory) do
		local splitItem = splitString(v["item"],"-")
		if splitItem[1] == splitName[1] then
			totalAmount = totalAmount + v["amount"]
		end
	end

	return parseInt(totalAmount)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveItem(Passport,nameItem,amount,notify,slot)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local source = vRP.Source(Passport)
		local inventory = vRP.Inventory(Passport)

		if not slot then
			local initial = 0

			repeat
				initial = initial + 1
			until inventory[tostring(initial)] == nil or (inventory[tostring(initial)] and inventory[tostring(initial)]["item"] == nameItem) or initial > vRP.GetWeight(Passport)

			if initial <= vRP.GetWeight(Passport) then
				initial = tostring(initial)

				if inventory[initial] == nil then
					inventory[initial] = { item = nameItem, amount = amount }
				elseif inventory[initial] and inventory[initial]["item"] == nameItem then
					inventory[initial]["amount"] = parseInt(inventory[initial]["amount"]) + amount
				end

				if notify and itemBody(nameItem) then
					TriggerClientEvent("itensNotify",source,{ "recebeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
				end
			end
		else
			local selectSlot = tostring(slot)

			if inventory[selectSlot] then
				if inventory[selectSlot]["item"] == nameItem then
					inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) + amount
				end
			else
				inventory[selectSlot] = { item = nameItem, amount = amount }
			end

			if notify and itemBody(nameItem) then
				TriggerClientEvent("itensNotify",source,{ "recebeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateItem(Passport,nameItem,amount,notify,slot)
	if parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local source = vRP.Source(Passport)

		if itemDurability(nameItem) then
			if itemType(nameItem) == "Armamento" then
				local identity = vRP.Identity(Passport)
				nameItem = tostring(nameItem.."-"..os.time().."-"..identity["serial"])
			else
				nameItem = tostring(nameItem.."-"..os.time())
			end
		elseif itemCharges(nameItem) then
			nameItem = tostring(nameItem.."-"..itemCharges(nameItem))
		end

		local inventory = vRP.Inventory(Passport)

		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until inventory[tostring(initial)] == nil or (inventory[tostring(initial)] and inventory[tostring(initial)]["item"] == nameItem) or initial > vRP.GetWeight(Passport)

			if initial <= vRP.GetWeight(Passport) then
				initial = tostring(initial)

				if inventory[initial] == nil then
					inventory[initial] = { item = nameItem, amount = amount }
				elseif inventory[initial] and inventory[initial]["item"] == nameItem then
					inventory[initial]["amount"] = parseInt(inventory[initial]["amount"]) + amount
				end

				if notify and itemBody(nameItem) then
					TriggerClientEvent("itensNotify",source,{ "recebeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
				end
			end
		else
			local selectSlot = tostring(slot)

			if inventory[selectSlot] then
				if inventory[selectSlot]["item"] == nameItem then
					inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) + amount
				end
			else
				inventory[selectSlot] = { item = nameItem, amount = amount }
			end

			if notify and itemBody(nameItem) then
				TriggerClientEvent("itensNotify",source,{ "recebeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.MaxItens(Passport,nameItem,Amount)
	if itemBody(nameItem) and vRP.Source(Passport) and nil ~= itemMaxAmount(nameItem) then
		if vRP.HasGroup(Passport,"Restaurants") then
			if itemScape(nameItem) and vRP.ItemAmount(Passport,nameItem) + parseInt(Amount) > itemMaxAmount(nameItem) * 5 then
				return true
			end
		elseif vRP.ItemAmount(Passport,nameItem) + parseInt(Amount) > itemMaxAmount(nameItem) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function verifyItens(Passport,nameItem)
	local source = vRP.Source(Passport)
	local splitName = splitString(nameItem,"-")
	local midName = splitName[1]

	if itemType(nameItem) == "Armamento" then
		TriggerClientEvent("inventory:verifyWeapon",source,midName)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYGETINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.TakeItem(Passport,nameItem,amount,notify,slot)
	selfReturn[Passport] = false
	local amount = parseInt(amount)
	local source = vRP.Source(Passport)
	local inventory = vRP.Inventory(Passport)

	if not slot then
		for k,v in pairs(inventory) do
			if v["item"] == nameItem and v["amount"] >= amount then
				v["amount"] = parseInt(v["amount"]) - amount

				if parseInt(v["amount"]) <= 0 then
					inventory[k] = nil
				end

				if notify and itemBody(nameItem) then
					TriggerClientEvent("itensNotify",source,{ "removeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
				end

				selfReturn[Passport] = true

				break
			end
		end
	else
		local selectSlot = tostring(slot)
		if inventory[selectSlot] and inventory[selectSlot]["item"] == nameItem and parseInt(inventory[selectSlot]["amount"]) >= amount then
			inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) - amount

			if parseInt(inventory[selectSlot]["amount"]) <= 0 then
				inventory[selectSlot] = nil
			end

			if notify and itemBody(nameItem) then
				TriggerClientEvent("itensNotify",source,{ "removeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
			end

			selfReturn[Passport] = true
		end
	end

	local splitName = splitString(nameItem,"-")
	if itemType(splitName[1]) == "Animal" then
		TriggerClientEvent("dynamic:animalFunctions",source,"deletar")
	end

	verifyItens(Passport,nameItem)

	return selfReturn[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveItem(Passport,nameItem,amount,notify)
	local amount = parseInt(amount)
	local source = vRP.Source(Passport)
	local inventory = vRP.Inventory(Passport)

	for k,v in pairs(inventory) do
		if v["item"] == nameItem and parseInt(v["amount"]) >= amount then
			v["amount"] = parseInt(v["amount"]) - amount

			if parseInt(v["amount"]) <= 0 then
				inventory[k] = nil
			end

			if notify and itemBody(nameItem) then
				TriggerClientEvent("itensNotify",source,{ "removeu",itemIndex(nameItem),parseFormat(amount),itemName(nameItem) })
			end

			break
		end
	end

	verifyItens(Passport,nameItem)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetSrvData(key)
	if srvData[key] == nil then
		local rows = vRP.Query("entitydata/GetData",{ dkey = key })
		if parseInt(#rows) > 0 then
			srvData[key] = { data = json.decode(rows[1]["dvalue"]), timer = 180 }
		else
			srvData[key] = { data = {}, timer = 180 }
		end
	end

	return srvData[key]["data"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetSrvData(key,data)
	srvData[key] = { data = data, timer = 180 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemSrvData(key)
	srvData[key] = { data = {}, timer = 180 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SRVSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(srvData) do
			if v["timer"] > 0 then
				v["timer"] = v["timer"] - 1

				if v["timer"] <= 0 then
					vRP.Query("entitydata/SetData",{ dkey = k, dvalue = json.encode(v["data"]) })
					srvData[k] = nil
				end
			end
		end

		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SaveServer")
AddEventHandler("SaveServer",function(Silenced)
	for k,v in pairs(srvData) do
		if json.encode(v["data"]) == "[]" or json.encode(v["data"]) == "{}" then
			vRP.Query("entitydata/RemoveData",{ dkey = k })
		else
			vRP.Query("entitydata/SetData",{ dkey = k, dvalue = json.encode(v["data"]) })
		end
	end

	if not Silenced then
		print("Obrigado por fazer parte do grupo Hensa.")
		print("Save no banco de dados terminou, ja pode reiniciar o servidor.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.invUpdate(Passport,slot,target,amount)
	selfReturn[Passport] = true

	if Actived[Passport] == nil and parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local selectSlot = tostring(slot)
		local targetSlot = tostring(target)
		local inventory = vRP.Inventory(Passport)

		if inventory[selectSlot] then
			Actived[Passport] = true
			local nameItem = inventory[selectSlot]["item"]

			if inventory[targetSlot] then
				if inventory[selectSlot] and inventory[targetSlot] then
					if nameItem == inventory[targetSlot]["item"] then
						if parseInt(inventory[selectSlot]["amount"]) >= amount then
							inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) - amount
							inventory[targetSlot]["amount"] = parseInt(inventory[targetSlot]["amount"]) + amount

							if parseInt(inventory[selectSlot]["amount"]) <= 0 then
								inventory[selectSlot] = nil
							end

							selfReturn[Passport] = false
						end
					else
						local temporary = inventory[selectSlot]
						inventory[selectSlot] = inventory[targetSlot]
						inventory[targetSlot] = temporary

						selfReturn[Passport] = false
					end
				end
			else
				if inventory[selectSlot] then
					if parseInt(inventory[selectSlot]["amount"]) >= amount then
						inventory[targetSlot] = { item = nameItem, amount = amount }
						inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) - amount

						if parseInt(inventory[selectSlot]["amount"]) <= 0 then
							inventory[selectSlot] = nil
						end

						selfReturn[Passport] = false
					end
				end
			end

			Actived[Passport] = nil
		end
	end

	return selfReturn[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.TakeChest(Passport,chestData,amount,slot,target)
	selfReturn[Passport] = true

	if Actived[Passport] == nil and parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local selectSlot = tostring(slot)
		local targetSlot = tostring(target)
		local source = vRP.Source(Passport)
		local consult = vRP.GetSrvData(chestData)

		if consult[selectSlot] then
			local nameItem = consult[selectSlot]["item"]
			local inventory = vRP.Inventory(Passport)
			Actived[Passport] = true

			if vRP.MaxItens(Passport,nameItem,amount) then
				TriggerClientEvent("Notify",source,"Atenção","Limite atingido.","amarelo",3000)
				Actived[Passport] = nil

				return selfReturn[Passport]
			end

			if (vRP.InventoryWeight(Passport) + (itemWeight(nameItem) * amount)) <= vRP.GetWeight(Passport) then
				if inventory[targetSlot] and consult[selectSlot] then
					if inventory[targetSlot]["item"] == nameItem then
						if parseInt(consult[selectSlot]["amount"]) >= amount then
							inventory[targetSlot]["amount"] = parseInt(inventory[targetSlot]["amount"]) + amount
							consult[selectSlot]["amount"] = parseInt(consult[selectSlot]["amount"]) - amount

							if parseInt(consult[selectSlot]["amount"]) <= 0 then
								consult[selectSlot] = nil
							end

							selfReturn[Passport] = false
						end
					end
				else
					if consult[selectSlot] then
						if parseInt(consult[selectSlot]["amount"]) >= amount then
							inventory[targetSlot] = { item = nameItem, amount = amount }
							consult[selectSlot]["amount"] = parseInt(consult[selectSlot]["amount"]) - amount

							if parseInt(consult[selectSlot]["amount"]) <= 0 then
								consult[selectSlot] = nil
							end

							selfReturn[Passport] = false
						end
					end
				end
			end

			Actived[Passport] = nil
		end
	end

	return selfReturn[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.StoreChest(Passport,chestData,amount,dataWeight,slot,target)
	selfReturn[Passport] = true

	if Actived[Passport] == nil and parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local selectSlot = tostring(slot)
		local targetSlot = tostring(target)
		local inventory = vRP.Inventory(Passport)

		if inventory[selectSlot] then
			Actived[Passport] = true
			local consult = vRP.GetSrvData(chestData)
			local nameItem = inventory[selectSlot]["item"]

			if (vRP.ChestWeight(consult) + (itemWeight(nameItem) * amount)) <= dataWeight then
				if consult[targetSlot] and inventory[selectSlot] then
					if nameItem == consult[targetSlot]["item"] then
						if parseInt(inventory[selectSlot]["amount"]) >= amount then
							consult[targetSlot]["amount"] = parseInt(consult[targetSlot]["amount"]) + amount
							inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) - amount

							if parseInt(inventory[selectSlot]["amount"]) <= 0 then
								inventory[selectSlot] = nil
							end

							selfReturn[Passport] = false
						end
					end
				else
					if inventory[selectSlot] then
						if parseInt(inventory[selectSlot]["amount"]) >= amount then
							consult[targetSlot] = { item = nameItem, amount = amount }
							inventory[selectSlot]["amount"] = parseInt(inventory[selectSlot]["amount"]) - amount

							if parseInt(inventory[selectSlot]["amount"]) <= 0 then
								inventory[selectSlot] = nil
							end

							selfReturn[Passport] = false
						end
					end
				end
			end

			verifyItens(Passport,nameItem)

			Actived[Passport] = nil
		end
	end

	return selfReturn[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Update(Passport,chestData,slot,target,amount)
	selfReturn[Passport] = true

	if Actived[Passport] == nil and parseInt(amount) > 0 then
		local amount = parseInt(amount)
		local selectSlot = tostring(slot)
		local targetSlot = tostring(target)
		local consult = vRP.GetSrvData(chestData)

		if consult[selectSlot] then
			Actived[Passport] = true

			if consult[targetSlot] and consult[selectSlot] then
				if consult[selectSlot]["item"] == consult[targetSlot]["item"] then
					if parseInt(consult[selectSlot]["amount"]) >= amount then
						consult[selectSlot]["amount"] = parseInt(consult[selectSlot]["amount"]) - amount

						if parseInt(consult[selectSlot]["amount"]) <= 0 then
							consult[selectSlot] = nil
						end

						consult[targetSlot]["amount"] = parseInt(consult[targetSlot]["amount"]) + amount
						selfReturn[Passport] = false
					end
				else
					local temporary = consult[selectSlot]
					consult[selectSlot] = consult[targetSlot]
					consult[targetSlot] = temporary

					selfReturn[Passport] = false
				end
			else
				if consult[selectSlot] then
					if parseInt(consult[selectSlot]["amount"]) >= amount then
						consult[selectSlot]["amount"] = parseInt(consult[selectSlot]["amount"]) - amount
						consult[targetSlot] = { item = consult[selectSlot]["item"], amount = amount }

						if parseInt(consult[selectSlot]["amount"]) <= 0 then
							consult[selectSlot] = nil
						end

						selfReturn[Passport] = false
					end
				end
			end

			Actived[Passport] = nil
		end
	end

	return selfReturn[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIRECTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DirectChest(Chest,Amount)
	local Amount = parseInt(Amount)
	local Consult = vRP.GetSrvData("stackChest:"..Chest)
	if Consult["100"] then
		if Consult["100"]["item"] == "dollars" then
			Consult["100"]["amount"] = parseInt(Consult["100"]["amount"]) + Amount
		else
			Consult["100"] = { item = "dollars", amount = Amount }
		end
	else
		Consult["100"] = { item = "dollars", amount = Amount }
	end
end