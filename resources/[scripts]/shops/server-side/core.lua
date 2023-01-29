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
Tunnel.bindInterface("shops",Creative)
vCLIENT = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	["PizzaThis"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "PizzaThis",
		["List"] = {
			["bread"] = 5,
			["cheese"] = 10,
			["pizzamozzarella"] = 125,
			["pizzabanana"] = 125,
			["pizzachocolate"] = 125,
			["calzone"] = 125,
			["chickenfries"] = 100
		}
	},
	["UwuCoffee"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "UwuCoffee",
		["List"] = {
			["bread"] = 5,
			["nigirizushi"] = 50,
			["sushi"] = 50,
			["cupcake"] = 50,
			["applelove"] = 50,
			["milkshake"] = 100,
			["cappuccino"] = 125,
			["cookies"] = 35
		}
	},
	["BeanMachine"] = {
		["perm"] = "BeanMachine",
		["Type"] = "Cash",
		["List"] = {
			["coffeemilk"] = 70,
			["sandwich"] = 15,
			["tacos"] = 25,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15,
			["absolut"] = 15
		}
	},
	["Identity"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["identity"] = 5000
		}
	},
	["Identity2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["fidentity"] = 10000
		}
	},
	["Weeds"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["silk"] = 5
		}
	},
	["Animals"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["rottweiler"] = 25000,
			["husky"] = 25000,
			["shepherd"] = 25000,
			["retriever"] = 25000,
			["poodle"] = 25000,
			["pug"] = 25000,
			["westy"] = 25000,
			["cat"] = 25000
		}
	},
	["Departament"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["sugar"] = 5,
			["postit"] = 20,
			["notepad"] = 10,
			["emptybottle"] = 30,
			["cigarette"] = 10,
			["lighter"] = 175,
			["rose"] = 25,
			["rope"] = 875,
			["firecracker"] = 100,
			["binoculars"] = 275,
			["vape"] = 4750,
			["scanner"] = 6750,
			["cellphone"] = 575,
			["radio"] = 975,
			["camera"] = 275,
			["bait"] = 5,
			["scuba"] = 975,
			["fishingrod"] = 725
		}
	},
	["Clothes"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["teddy"] = 75,
			["WEAPON_BRICK"] = 25,
			["WEAPON_SHOES"] = 25
		}
	},
	["Mecanico"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["tyres"] = 225,
			["toolbox"] = 625,
			["advtoolbox"] = 1525,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725
		}
	},
	["Fuel"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_PETROLCAN"] = 250
		}
	},
	["Weapons"] = {
		["mode"] = "Sell",
		["type"] = "Illegal",
		["List"] = {
			["pistolbody"] = 425,
			["smgbody"] = 525,
			["riflebody"] = 625
		}
	},
	["Oxy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["oxy"] = 35
		}
	},
	["Pharmacy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["medkit"] = 575,
			["bandage"] = 225,
			["gauze"] = 100,
			["analgesic"] = 125
		}
	},
	["Paramedico"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedico",
		["List"] = {
			["badge02"] = 10,
			["syringe"] = 2,
			["bandage"] = 225,
			["gauze"] = 100,
			["gdtkit"] = 20,
			["medkit"] = 575,
			["sinkalmy"] = 375,
			["analgesic"] = 125,
			["ritmoneury"] = 475,
			["wheelchair"] = 2750,
			["medicbag"] = 425,
			["medicbed"] = 725
		}
	},
	["Ammunation"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["GADGET_PARACHUTE"] = 475,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 975,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_KARAMBIT"] = 975,
			["WEAPON_KATANA"] = 975,
			["WEAPON_FLASHLIGHT"] = 975,
			["pickaxe"] = 525
		}
	},
	["Cassino"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cassino"] = 2
		}
	},
	["Premium"] = {
		["mode"] = "Buy",
		["type"] = "Premium",
		["List"] = {
			["gemstone"] = 1,
			["premium"] = 75,
			["premiumplate"] = 50,
			["newchars"] = 75,
			["namechange"] = 50,
			["newlocate"] = 30,
			["backpackpremium"] = 20,
			["chip"] = 25
		}
	},
	["Hunting"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["meat"] = 16,
			["animalpelt"] = 25,
			["tomato"] = 10,
			["banana"] = 10,
			["guarana"] = 10,
			["acerola"] = 10,
			["passion"] = 10,
			["grape"] = 10,
			["tange"] = 10,
			["orange"] = 10,
			["apple"] = 10,
			["strawberry"] = 10,
			["coffee2"] = 10,
			["animalfat"] = 10,
			["leather"] = 20,
			["wheatflour"] = 50
		}
	},
	["Fishing"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["octopus"] = 14,
			["shrimp"] = 14,
			["carp"] = 12,
			["horsefish"] = 12,
			["tilapia"] = 14,
			["codfish"] = 16,
			["catfish"] = 16,
			["goldenfish"] = 30,
			["pirarucu"] = 26,
			["pacu"] = 24,
			["tambaqui"] = 28
		}
	},
	["Hunting2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["switchblade"] = 525,
			["WEAPON_MUSKET"] = 3250,
			["WEAPON_MUSKET_AMMO"] = 7
		}
	},
	["Recycle"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["notepad"] = 5,
			["plastic"] = 10,
			["glass"] = 10,
			["rubber"] = 10,
			["aluminum"] = 15,
			["copper"] = 15,
			["radio"] = 485,
			["rope"] = 435,
			["cellphone"] = 325,
			["binoculars"] = 135,
			["emptybottle"] = 15,
			["switchblade"] = 215,
			["camera"] = 135,
			["vape"] = 2375,
			["rose"] = 15,
			["lighter"] = 75,
			["teddy"] = 35,
			["tyres"] = 100,
			["bait"] = 2,
			["firecracker"] = 50,
			["fishingrod"] = 365,
			["scuba"] = 485,
			["silvercoin"] = 10,
			["goldcoin"] = 20,
			["techtrash"] = 60,
			["tarp"] = 20,
			["sheetmetal"] = 20,
			["roadsigns"] = 20,
			["explosives"] = 30,
			["codeine"] = 15,
			["amphetamine"] = 20,
			["acetone"] = 15,
			["cotton"] = 20,
			["plaster"] = 15,
			["sulfuric"] = 12,
			["saline"] = 20,
			["alcohol"] = 15
		}
	},
	["Miners"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["emerald"] = 85,
			["diamond"] = 75,
			["ruby"] = 55,
			["sapphire"] = 45,
			["amethyst"] = 35,
			["amber"] = 25,
			["turquoise"] = 15
		}
	},
	["Coffee"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["coffee"] = 20
		}
	},
	["Soda"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["Donut"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["donut"] = 15,
			["chocolate"] = 15
		}
	},
	["Hamburger"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hamburger"] = 25
		}
	},
	["Hotdog"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 15
		}
	},
	["Chihuahua"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 15,
			["hamburger"] = 25,
			["coffee"] = 20,
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["Water"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["water"] = 30
		}
	},
	["Policia"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Policia",
		["List"] = {
			["vest"] = 175,
			["gsrkit"] = 20,
			["gdtkit"] = 20,
			["barrier"] = 250,
			["handcuff"] = 425,
			["WEAPON_SMG"] = 775,
			["WEAPON_PUMPSHOTGUN"] = 775,
			["WEAPON_CARBINERIFLE"] = 775,
			["WEAPON_CARBINERIFLE_MK2"] = 925,
			["WEAPON_STUNGUN"] = 525,
			["WEAPON_COMBATPISTOL"] = 625,
			["WEAPON_HEAVYPISTOL"] = 725,
			["WEAPON_NIGHTSTICK"] = 125,
			["WEAPON_PISTOL_AMMO"] = 4,
			["WEAPON_SMG_AMMO"] = 5,
			["WEAPON_RIFLE_AMMO"] = 6,
			["WEAPON_SHOTGUN_AMMO"] = 5,
			["badge01"] = 10,
			["WEAPON_MOLOTOV"] = 75,
			["WEAPON_SMOKEGRENADE"] = 75,
			["attachsFlashlight"] = 1750,
			["attachsCrosshair"] = 1750,
			["attachsSilencer"] = 1750,
			["attachsMagazine"] = 1750,
			["attachsGrip"] = 1750,
			["megaphone"] = 525
		}
	},
	["Criminal"] = {
		["mode"] = "Sell",
		["type"] = "Illegal",
		["List"] = {
			["keyboard"] = 75,
			["mouse"] = 75,
			["playstation"] = 75,
			["xbox"] = 75,
			["dish"] = 75,
			["pan"] = 100,
			["fan"] = 75,
			["blender"] = 75,
			["switch"] = 45,
			["cup"] = 100,
			["lampshade"] = 75
		}
	},
	["Criminal2"] = {
		["mode"] = "Sell",
		["type"] = "Illegal",
		["List"] = {
			["watch"] = 75,
			["bracelet"] = 75,
			["dildo"] = 75,
			["spray01"] = 75,
			["spray02"] = 75,
			["spray03"] = 75,
			["spray04"] = 75,
			["slipper"] = 75,
			["rimel"] = 75,
			["brush"] = 75,
			["soap"] = 75
		}
	},
	["Criminal3"] = {
		["mode"] = "Sell",
		["type"] = "Illegal",
		["List"] = {
			["eraser"] = 75,
			["legos"] = 75,
			["ominitrix"] = 75,
			["dices"] = 45,
			["domino"] = 45,
			["floppy"] = 45,
			["horseshoe"] = 75,
			["deck"] = 75
		}
	},
	["Criminal4"] = {
		["mode"] = "Sell",
		["type"] = "Illegal",
		["List"] = {
			["goldbar"] = 525,
			["pliers"] = 55,
			["pager"] = 125,
			["card01"] = 325,
			["card02"] = 325,
			["card03"] = 375,
			["card04"] = 275,
			["card05"] = 425,
			["pendrive"] = 325
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local nameMale = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio" }
local nameFemale = { "Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local userName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestPerm(Type)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if exports["hud"]:Wanted(Passport,source) then
			return false
		end

		if shops[Type]["perm"] ~= nil then
			if not vRP.HasGroup(Passport,shops[Type]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Perm)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not vRP.HasGroup(Passport,Perm) then
			return false
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Request(name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local shopSlots = 20
		local inventoryShop = {}
		for k,v in pairs(shops[name]["List"]) do
			inventoryShop[#inventoryShop + 1] = { key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), economy = parseFormat(itemEconomy(k)), max = itemMaxAmount(k), desc = itemDescription(k) }
		end

		local inventoryUser = {}
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

			inventoryUser[k] = v
		end

		if parseInt(#inventoryShop) > 20 then
			shopSlots = parseInt(#inventoryShop)
		end

		return inventoryShop,inventoryUser,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),shopSlots
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getShopType(Type)
    return shops[Type]["mode"]
end---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.functionShops(Type,Item,Amount,Slot)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if shops[Type] then
			if Amount <= 0 then Amount = 1 end

			local inventory = vRP.Inventory(Passport)
			if (inventory[tostring(Slot)] and inventory[tostring(Slot)]["item"] == Item) or not inventory[tostring(Slot)] then
				if shops[Type]["mode"] == "Buy" then
					if vRP.MaxItens(Passport,Item,Amount) then
						TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",3000)
						vCLIENT.Update(source,"Request")
						return
					end

					if (vRP.InventoryWeight(Passport) + itemWeight(Item) * Amount) <= vRP.GetWeight(Passport) then
						if shops[Type]["type"] == "Cash" then
							if shops[Type]["List"][Item] then
								if vRP.PaymentFull(Passport,shops[Type]["List"][Item] * Amount) then
									if Item == "identity" or string.sub(Item,1,5) == "badge" then
										vRP.GiveItem(Passport,Item.."-"..Passport,Amount,false,Slot)
									elseif Item == "fidentity" then
										local Identity = vRP.Identity(Passport)
										if Identity then
											if Identity["sex"] == "M" then
												vRP.Query("fidentity/NewIdentity",{ name = nameMale[math.random(#nameMale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											else
												vRP.Query("fidentity/NewIdentity",{ name = nameFemale[math.random(#nameFemale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											end

											local Identity = vRP.Identity(Passport)
											local consult = vRP.Query("fidentity/GetIdentity")
											if consult[1] then
												vRP.GiveItem(Passport,Item.."-"..consult[1]["id"],Amount,false,Slot)
											end
										end
									else
										vRP.GenerateItem(Passport,Item,Amount,false,Slot)

										if Item == "WEAPON_PETROLCAN" then
											vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500,false)
										end
									end

									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,shops[Type]["item"],parseInt(shops[Type]["List"][Item] * Amount)) then
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"Aviso","<b>"..itemName(shops[Type]["item"]).."</b> insuficiente.","vermelho",5000)
							end
						elseif shops[Type]["type"] == "Premium" then
							if vRP.PaymentGems(Passport,shops[Type]["List"][Item] * Amount) then
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("Notify",source,"Aviso","Comprou <b>"..Amount.."x "..itemName(Item).."</b> por <b>"..shops[Type]["List"][Item] * Amount.." Gemas</b>.","verde",5000)
							else
								TriggerClientEvent("Notify",source,"Aviso","<b>Gemas</b> insuficientes.","vermelho",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					end
				elseif shops[Type]["mode"] == "Sell" then
					local splitName = splitString(Item,"-")

					if shops[Type]["List"][splitName[1]] then
						local itemPrice = shops[Type]["List"][splitName[1]]

						if itemPrice > 0 then
							if vRP.CheckDamaged(Item) then
								TriggerClientEvent("Notify",source,"Aviso","Itens danificados não podem ser vendidos.","vermelho",5000)
								vCLIENT.Update(source,"Request")
								return
							end
						end

						if shops[Type]["type"] == "Cash" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,"dollars",parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						elseif shops[Type]["type"] == "Illegal" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,"dollars2",parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,shops[Type]["item"],parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						end
					end
				end
			end
		end

		vCLIENT.Update(source,"Request")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:populateSlot")
AddEventHandler("shops:populateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
			vRP.GiveItem(Passport,Item,Amount,false,Target)
			vCLIENT.Update(source,"Request")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:updateSlot")
AddEventHandler("shops:updateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		local inventory = vRP.Inventory(Passport)
		if inventory[tostring(Slot)] and inventory[tostring(Target)] and inventory[tostring(Slot)]["item"] == inventory[tostring(Target)]["item"] then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GiveItem(Passport,Item,Amount,false,Target)
			end
		else
			vRP.SwapSlot(Passport,Slot,Target)
		end

		vCLIENT.Update(source,"Request")
	end
end)