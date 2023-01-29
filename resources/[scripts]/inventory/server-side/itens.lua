-----------------------------------------------------------------------------------------------------------------------------------------
-- GEOGES
-----------------------------------------------------------------------------------------------------------------------------------------
Geodes = {
	{ ["item"] = "emerald", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "diamond", ["min"] = 2, ["max"] = 2 },
	{ ["item"] = "ruby", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "sapphire", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "amethyst", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "amber", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "turquoise", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "aluminum", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "copper", ["min"] = 1, ["max"] = 2 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- USE
-----------------------------------------------------------------------------------------------------------------------------------------
Use = {
	["packagebox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vCLIENT.CheckPackage()
	end,

	["bandage"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 5
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Passando",5000)
				vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							TriggerClientEvent("sounds:Private",source,"bandage",0.5)
							Healths[Passport] = os.time() + 30
							vRP.UpgradeStress(Passport,2)
							vRPC.UpgradeHealth(source,15)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"Aviso","Não pode utilizar de vida cheia ou nocauteado.","amarelo",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timer.."</b> segundos.","azul",5000)
		end
	end,

	["sulfuric"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",3000)
		vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRPC.DowngradeHealth(source,100)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["analgesic"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 3
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Tomando",3000)
				vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 15
							vRP.UpgradeStress(Passport,1)
							vRPC.UpgradeHealth(source,8)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,false,"Não pode utilizar de vida cheia ou nocauteado.","azul",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timer.."</b> segundos.","azul",5000)
		end
	end,

	["oxy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 3
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Tomando",3000)
				vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 15
							vRP.UpgradeStress(Passport,1)
							vRPC.UpgradeHealth(source,8)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,false,"Não pode utilizar de vida cheia ou nocauteado.","azul",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timer.."</b> segundos.","azul",5000)
		end
	end,

	["vehkey"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Vehicle,Network,Plate = vRPC.VehicleList(source,5)
		if Vehicle then
			if Plate == Split[2] then
				TriggerEvent("garages:LockVehicle",source,Network)
			end
		end
	end,

	["newchars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.TakeItem(Passport,Full,1,false,Slot) then
			vRP.UpgradeChars(source)
			TriggerClientEvent("inventory:Update",source,"Backpack")
			TriggerClientEvent("Notify",source,"Aviso","Personagem liberado.","verde",5000)
		end
	end,

	["wheelchair"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Plate = "WCH"..math.random(10000,99999)
		TriggerEvent("plateEveryone",Plate)
		vCLIENT.wheelChair(source,Plate)
	end,

	["backpack"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.GetWeight(Passport) <= 115 then
			if vRP.TakeItem(Passport,Full,1,false,Slot) then
				vRP.SetWeight(Passport,5)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerClientEvent("Notify",source,"Sucesso","<b>"..itemName(Item).."</b> usada.","verde",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Você atingiu o limite máximo de uso da <b>"..itemName(Item).."</b>.","vermelho",10000)
		end
	end,

	["backpackpremium"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.UserPremium(Passport) then
			if vRP.GetWeight(Passport) <= 115 then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					vRP.SetWeight(Passport,10)
					TriggerClientEvent("inventory:Update",source,"Backpack")
					TriggerClientEvent("Notify",source,"Sucesso","<b>"..itemName(Item).."</b> usada.","verde",5000)
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Você atingiu o limite máximo de uso da <b>"..itemName(Item).."</b>.","vermelho",10000)
			end
		else
			TriggerClientEvent("Notify",source,"Atenção","Você não pode usar a <b>"..itemName(Item).."</b>.","amarelo",5000)
		end
	end,

	["gemstone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.TakeItem(Passport,Full,Amount,false,Slot) then
			TriggerClientEvent("inventory:Update",source,"Backpack")
			vRP.UpgradeGemstone(Passport,Amount)
		end
	end,

	["badge01"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.createObjects(source,"paper_1_rcm_alt1-8","player_one_dual-8","prop_police_badge",49,28422,0.065,0.029,-0.035,80.0,-1.90,75.0)
	end,

	["badge02"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.createObjects(source,"paper_1_rcm_alt1-8","player_one_dual-8","prop_medic_badge",49,28422,0.065,0.029,-0.035,80.0,-1.90,75.0)
	end,

	["namechange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local Keyboard = vKEYBOARD.keyDouble(source,"Nome:","Sobrenome:")
		if Keyboard then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"Aviso","Passaporte atualizado.","verde",5000)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				vRP.UpgradeNames(Passport,Keyboard[1],Keyboard[2])
			end
		end
	end,

	["chip"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local Keyboard = vKEYBOARD.keyDouble(source,"Três primeiros digitos:","Três ultimos digitos:")
		if Keyboard then
			local Fir = sanitizeString(Keyboard[1],"0123456789",true)
			local Sec = sanitizeString(Keyboard[2],"0123456789",true)
			if string.len(Fir) == 3 and string.len(Sec) == 3 then
				if not vRP.UserPhone(Keyboard[1].."-"..Keyboard[2]) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("Notify",source,"Aviso","Telefone atualizado.","verde",5000)
						TriggerClientEvent("inventory:Update",source,"Backpack")
						vRP.UpgradePhone(Passport,Keyboard[1].."-"..Keyboard[2])
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","O número escolhido já possui um proprietário.","amarelo",5000)
				end
			else
				TriggerClientEvent("Notify",source,"Atenção","O número telefônico deve conter 6 dígitos e somente números.","amarelo",5000)
			end
		end
	end,

	["newlocate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local Identity = vRP.Identity(Passport)
		if Identity["locate"] == "Sul" then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"Aviso","Nacionalidade atualizada para <b>Norte</b>.","verde",5000)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				vRP.UpgradeLocate(Passport,"Norte")
			end
		elseif Identity["locate"] == "Norte" then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"Aviso","Nacionalidade atualizada para <b>Sul</b>.","verde",5000)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				vRP.UpgradeLocate(Passport,"Sul")
			end
		end
	end,

	["dices"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Dice = math.random(6)
		local Players = vRPC.Players(source)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("showme:pressMe",v,source,"<img src='images/"..Dice..".png'>",10,true)
			end)
		end
	end,

	["deck"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local card = math.random(13)
		local cards = { "A","2","3","4","5","6","7","8","9","10","J","Q","K" }

		local naipe = math.random(4)
		local naipes = { "<black>♣</black>","<red>♠</red>","<black>♦</black>","<red>♥</red>" }

		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],"Tirou "..cards[card]..naipes[naipe].." do baralho.")
			end)
		end
	end,

	["silvercoin"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Coins = math.random(2)
		local Sides = { "Cara","Coroa" }
		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],Sides[Coins])
			end)
		end
	end,

	["goldcoin"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Coins = math.random(2)
		local Sides = { "Cara","Coroa" }
		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],Sides[Coins])
			end)
		end
	end,

	["soap"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vPLAYER.checkSoap(source) ~= nil then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Usando",10000)
			vRPC.playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("player:Residuals",source)
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["geode"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"WEAPON_HAMMER",1) then
			local Selected = math.random(#Geodes)
			local Rand = math.random(Geodes[Selected]["min"],Geodes[Selected]["max"])

			if (vRP.InventoryWeight(Passport) + (itemWeight(Geodes[Selected]["item"]) * Rand)) <= vRP.GetWeight(Passport) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,Geodes[Selected]["item"],Rand,false)
					TriggerClientEvent("inventory:Update",source,"Backpack")
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","<b>Martelo</b> não encontrado.","amarelo",5000)
		end
	end,

	["joint"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"lighter",1) then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Fumando",10000)
			vRPC.createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Points = 0
						if Split[2] ~= nil then
							Points = parseInt(Split[2])
						end

						vRP.WeedTimer(Passport,1)
						vRP.DowngradeHunger(Passport,5 + (0.1 * Points))
						vRP.DowngradeThirst(Passport,5 + (0.1 * Points))
						vRP.DowngradeStress(Passport,5 + (0.1 * Points))
						vPLAYER.movementClip(source,"move_m@shadyped@a")
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["cocaine"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Cheirando",5000)
		vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.ChemicalTimer(Passport,10)
					TriggerClientEvent("setCocaine",source)
					TriggerClientEvent("setEnergetic",source,15,1.20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["meth"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify",source,false,"Aguarde <b>"..armorTimers.."</b> segundos.","azul",5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Inalando",10000)
		vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setMeth",source)
					Armors[Passport] = os.time() + 60
					vRP.ChemicalTimer(Passport,10)
					vRP.SetArmour(source,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cigarette"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"lighter",1) then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Fumando",10000)
			vRPC.createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						vRP.DowngradeStress(Passport,5)
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["rottweiler"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_rottweiler")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["husky"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_husky")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["shepherd"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_shepherd")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["retriever"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_retriever")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["poodle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_poodle")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pug"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_pug")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["westy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_westy")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cat"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 2
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Assobiando",2000)
		vRPC.playAnim(source,true,{"rcmnigel1c","hailing_whistle_waive_a"},false)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("dynamic:animalSpawn",source,"a_c_cat_01")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["vape"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 15
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Fumando",15000)
		vRPC.createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","ba_prop_battle_vape_01",49,18905,0.08,-0.00,0.03,-150.0,90.0,-10.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRP.DowngradeStress(Passport,10)
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["medkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 10
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Passando",10000)
				vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 60
							vRPC.UpgradeHealth(source,40)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"Aviso","Não pode utilizar de vida cheia ou nocauteado.","amarelo",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,false,"Aguarde <b>"..Timer.."</b> segundos.","azul",5000)
		end
	end,

	["adrenaline"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Distance = vCLIENT.AdreDistance(source)
		if Distance then
			local ClosestPed = vRPC.ClosestPed(source,2)
			if ClosestPed then
				local OtherPassport = vRP.Passport(ClosestPed)
				local Identity = vRP.Identity(OtherPassport)
				if OtherPassport and Identity then
					Active[Passport] = os.time() + 60
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("Progress",source,"Aplicando Adrenalina",60000)
					TriggerClientEvent("Progress",OtherPassport,"Recebendo Adrenalina",60000)
					vRPC.playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

					repeat
						if os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.stopAnim(source,false)
							vRPC.stopAnim(OtherPassport,false)
							Player(source)["state"]["Buttons"] = false

							if vRP.TakeItem(Passport,Full,1,true,Slot) then
								vRPC.Revive(OtherPassport,115)
								TriggerClientEvent("Notify",OtherPassport,"Aviso","Você precisa de um tratamento médico.","vermelho",5000)
							end
						end

						Wait(100)
					until not Active[Passport]
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Não existem pessoas por perto.","vermelho",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Atenção","Você não pode fazer isso nesse lugar.","amarelo",5000)
		end
	end,

	["gauze"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vPARAMEDIC.Bleeding(source) > 0 then
			Active[Passport] = os.time() + 3
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Passando",3000)
			vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source,false)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						vPARAMEDIC.Bandage(source)
					end
				end

				Wait(100)
			until not Active[Passport]
		else
			TriggerClientEvent("Notify",source,"Aviso","Nenhum ferimento encontrado.","amarelo",5000)
		end
	end,

	["binoculars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Ped = GetPlayerPed(source)
		if GetSelectedPedWeapon(Ped) ~= GetHashKey("WEAPON_UNARMED") then
			return
		end

		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Usando",3000)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("inventory:Camera",source,true)
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["camera"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Ped = GetPlayerPed(source)
		if GetSelectedPedWeapon(Ped) ~= GetHashKey("WEAPON_UNARMED") then
			return
		end

		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Usando",3000)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				TriggerClientEvent("inventory:Camera",source)
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["evidence01"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Microscope = {
			{ 482.95,-988.61,30.68 },
			{ 312.47,-562.1,43.29 },
			{ 368.33,-1592.01,25.44 },
			{ 1772.18,2577.82,45.73 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= 1 then
				local Identity = vRP.Identity(Split[2])
				if Identity then
					TriggerClientEvent("Notify",source,"Aviso","Evidência de <b>"..Identity["name2"].."</b>.","amarelo",5000)
					break
				end
			end
		end
	end,

	["evidence02"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Microscope = {
			{ 482.95,-988.61,30.68 },
			{ 312.47,-562.1,43.29 },
			{ 368.33,-1592.01,25.44 },
			{ 1772.18,2577.82,45.73 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= 1 then
				local Identity = vRP.Identity(Split[2])
				if Identity then
					TriggerClientEvent("Notify",source,"Aviso","Evidência de <b>"..Identity["name2"].."</b>.","amarelo",5000)
					break
				end
			end
		end
	end,

	["evidence03"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Microscope = {
			{ 482.95,-988.61,30.68 },
			{ 312.47,-562.1,43.29 },
			{ 368.33,-1592.01,25.44 },
			{ 1772.18,2577.82,45.73 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= 1 then
				local Identity = vRP.Identity(Split[2])
				if Identity then
					TriggerClientEvent("Notify",source,"Aviso","Evidência de <b>"..Identity["name2"].."</b>.","amarelo",5000)
					break
				end
			end
		end
	end,

	["evidence04"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Microscope = {
			{ 482.95,-988.61,30.68 },
			{ 312.47,-562.1,43.29 },
			{ 368.33,-1592.01,25.44 },
			{ 1772.18,2577.82,45.73 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= 1 then
				local Identity = vRP.Identity(Split[2])
				if Identity then
					TriggerClientEvent("Notify",source,"Aviso","Evidência de <b>"..Identity["name2"].."</b>.","amarelo",5000)
					break
				end
			end
		end
	end,

	["teddy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.createObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
	end,

	["rose"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
	end,

	["watch"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Notify",source,"Aviso","Agora são: <b>"..parseInt(GlobalState["Hours"])..":"..parseInt(GlobalState["Minutes"]).."</b>.","amarelo",5000)
	end,

	["firecracker"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRP.InsideVehicle(source) and not vCLIENT.checkCracker(source) then
			Active[Passport] = os.time() + 3
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Acendendo",3000)
			vRPC.playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source,false)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("inventory:Firecracker",source)
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["gsrkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			Active[Passport] = os.time() + 5
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Usando",5000)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Informations = vPLAYER.checkSoap(ClosestPed)
						if Informations then
							local Number = 0
							local Message = ""

							for Value,v in pairs(Informations) do
								Number = Number + 1
								Message = Message.."<b>"..Number.."</b>: "..Value.."<br>"
							end

							TriggerClientEvent("Notify",source,"Aviso",Message,"amarelo",10000)
						else
							TriggerClientEvent("Notify",source,"Aviso","Nenhum resultado encontrado.","amarelo",3000)
						end
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["gdtkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			local OtherPassport = vRP.Passport(ClosestPed)
			local Identity = vRP.Identity(OtherPassport)
			if OtherPassport and Identity then
				Active[Passport] = os.time() + 5
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Usando",5000)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local weed = vRP.WeedReturn(OtherPassport)
							local chemical = vRP.ChemicalReturn(OtherPassport)
							local alcohol = vRP.AlcoholReturn(OtherPassport)

							local chemStr = ""
							local alcoholStr = ""
							local weedStr = ""

							if chemical == 0 then
								chemStr = "Nenhum"
							elseif chemical == 1 then
								chemStr = "Baixo"
							elseif chemical == 2 then
								chemStr = "Médio"
							elseif chemical >= 3 then
								chemStr = "Alto"
							end

							if alcohol == 0 then
								alcoholStr = "Nenhum"
							elseif alcohol == 1 then
								alcoholStr = "Baixo"
							elseif alcohol == 2 then
								alcoholStr = "Médio"
							elseif alcohol >= 3 then
								alcoholStr = "Alto"
							end

							if weed == 0 then
								weedStr = "Nenhum"
							elseif weed == 1 then
								weedStr = "Baixo"
							elseif weed == 2 then
								weedStr = "Médio"
							elseif weed >= 3 then
								weedStr = "Alto"
							end

							TriggerClientEvent("Notify",source,false,"<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,"azul",8000)
						end
					end

					Wait(100)
				until not Active[Passport]
			end
		end
	end,

	["nitro"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle then
				vRPC.stopActived(source)
				Active[Passport] = os.time() + 10
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Trocando",10000)
				TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
				vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local Nitro = GlobalState["Nitro"]
							Nitro[Plate] = 2000
							GlobalState:set("Nitro",Nitro,true)
						end
					end

					Wait(100)
				until not Active[Passport]

				TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
			end
		end
	end,

	["vest"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify",source,false,"Aguarde <b>"..armorTimers.."</b> segundos.","azul",5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Vestindo",10000)
		vRPC.playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					Armors[Passport] = os.time() + 1800
					vRP.SetArmour(source,99)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["GADGET_PARACHUTE"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Usando",3000)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vCLIENT.Parachute(source)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["advtoolbox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Split then
			if not vRPC.InsideVehicle(source) then
				local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
				if Vehicle then
					vRPC.stopActived(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
					vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

					if vTASKBAR.Task(source,4,20500) then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local Players = vRPC.Players(source)
							for _,v in pairs(Players) do
								async(function()
									TriggerClientEvent("inventory:repairVehicle",v,Network,Plate)
								end)
							end

							local Number = parseInt(Split[2]) - 1

							if Number >= 1 then
								vRP.GiveItem(Passport,"advtoolbox-"..Number,1,false)
							end
						end
					end

					TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
					Player(source)["state"]["Buttons"] = false
					vRPC.stopAnim(source,false)
					Active[Passport] = nil
				end
			end
		end
	end,

	["enginea"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["11"] then
							Datatable["mods"]["11"] = -1
						end

						if Datatable["mods"]["11"] == -1 then
							if Datatable["mods"]["11"] >= vCLIENT.CheckMods(source,Vehicle,11) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Motor</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["11"] = Datatable["mods"]["11"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,11,Datatable["mods"]["11"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Motor</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["engineb"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["11"] then
							Datatable["mods"]["11"] = -1
						end

						if Datatable["mods"]["11"] == 0 then
							if Datatable["mods"]["11"] >= vCLIENT.CheckMods(source,Vehicle,11) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Motor</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["11"] = Datatable["mods"]["11"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,11,Datatable["mods"]["11"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Motor</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["enginec"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["11"] then
							Datatable["mods"]["11"] = -1
						end

						if Datatable["mods"]["11"] == 1 then
							if Datatable["mods"]["11"] >= vCLIENT.CheckMods(source,Vehicle,11) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Motor</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["11"] = Datatable["mods"]["11"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,11,Datatable["mods"]["11"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Motor</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["engined"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["11"] then
							Datatable["mods"]["11"] = -1
						end

						if Datatable["mods"]["11"] == 2 then
							if Datatable["mods"]["11"] >= vCLIENT.CheckMods(source,Vehicle,11) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Motor</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["11"] = Datatable["mods"]["11"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,11,Datatable["mods"]["11"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Motor</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["enginee"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["11"] then
							Datatable["mods"]["11"] = -1
						end

						if Datatable["mods"]["11"] == 3 then
							if Datatable["mods"]["11"] >= vCLIENT.CheckMods(source,Vehicle,11) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Motor</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["11"] = Datatable["mods"]["11"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,11,Datatable["mods"]["11"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Motor</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["brakea"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["12"] then
							Datatable["mods"]["12"] = -1
						end

						if Datatable["mods"]["12"] == -1 then
							if Datatable["mods"]["12"] >= vCLIENT.CheckMods(source,Vehicle,12) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Freio</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["12"] = Datatable["mods"]["12"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,12,Datatable["mods"]["12"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Freio</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["brakeb"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["12"] then
							Datatable["mods"]["12"] = -1
						end

						if Datatable["mods"]["12"] == 0 then
							if Datatable["mods"]["12"] >= vCLIENT.CheckMods(source,Vehicle,12) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Freio</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["12"] = Datatable["mods"]["12"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,12,Datatable["mods"]["12"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Freio</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["brakec"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["12"] then
							Datatable["mods"]["12"] = -1
						end

						if Datatable["mods"]["12"] == 1 then
							if Datatable["mods"]["12"] >= vCLIENT.CheckMods(source,Vehicle,12) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Freio</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["12"] = Datatable["mods"]["12"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,12,Datatable["mods"]["12"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Freio</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["braked"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["12"] then
							Datatable["mods"]["12"] = -1
						end

						if Datatable["mods"]["12"] == 2 then
							if Datatable["mods"]["12"] >= vCLIENT.CheckMods(source,Vehicle,12) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Freio</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["12"] = Datatable["mods"]["12"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,12,Datatable["mods"]["12"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Freio</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["brakee"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["12"] then
							Datatable["mods"]["12"] = -1
						end

						if Datatable["mods"]["12"] == 3 then
							if Datatable["mods"]["12"] >= vCLIENT.CheckMods(source,Vehicle,12) then
								TriggerClientEvent("Notify",source,"Aviso","Limite do <b>Freio</b> atingido.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["12"] = Datatable["mods"]["12"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,12,Datatable["mods"]["12"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo do <b>Freio</b> incorreto.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["transmissiona"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["13"] then
							Datatable["mods"]["13"] = -1
						end

						if Datatable["mods"]["13"] == -1 then
							if Datatable["mods"]["13"] >= vCLIENT.CheckMods(source,Vehicle,13) then
								TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Transmissão</b> atingida.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["13"] = Datatable["mods"]["13"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,13,Datatable["mods"]["13"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Transmissão</b> incorreta.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["transmissionb"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["13"] then
							Datatable["mods"]["13"] = -1
						end

						if Datatable["mods"]["13"] == 0 then
							if Datatable["mods"]["13"] >= vCLIENT.CheckMods(source,Vehicle,13) then
								TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Transmissão</b> atingida.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["13"] = Datatable["mods"]["13"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,13,Datatable["mods"]["13"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Transmissão</b> incorreta.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["transmissionc"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["13"] then
							Datatable["mods"]["13"] = -1
						end

						if Datatable["mods"]["13"] == 1 then
							if Datatable["mods"]["13"] >= vCLIENT.CheckMods(source,Vehicle,13) then
								TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Transmissão</b> atingida.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["13"] = Datatable["mods"]["13"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,13,Datatable["mods"]["13"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Transmissão</b> incorreta.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["transmissiond"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["13"] then
							Datatable["mods"]["13"] = -1
						end

						if Datatable["mods"]["13"] == 2 then
							if Datatable["mods"]["13"] >= vCLIENT.CheckMods(source,Vehicle,13) then
								TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Transmissão</b> atingida.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["13"] = Datatable["mods"]["13"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,13,Datatable["mods"]["13"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Transmissão</b> incorreta.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["transmissione"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				local PassportPlate = vRP.PassportPlate(Plate)
				if PassportPlate then
					local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
					if parseInt(#Datatable) > 0 then
						Datatable = json.decode(Datatable[1]["dvalue"])

						if not Datatable["mods"]["13"] then
							Datatable["mods"]["13"] = -1
						end

						if Datatable["mods"]["13"] == 3 then
							if Datatable["mods"]["13"] >= vCLIENT.CheckMods(source,Vehicle,13) then
								TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Transmissão</b> atingida.","amarelo",5000)
							else
								vRPC.stopActived(source)
								Active[Passport] = os.time() + 1000
								Player(source)["state"]["Buttons"] = true
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								if vTASKBAR.Task(source,8,10500) then
									Active[Passport] = os.time() + 120
									TriggerClientEvent("Progress",source,"Aplicando",120000)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											vRPC.Destroy(source)
											Player(source)["state"]["Buttons"] = false

											if vRP.TakeItem(Passport,Full,1,false,Slot) then
												Datatable["mods"]["13"] = Datatable["mods"]["13"] + 1
												vCLIENT.ActiveMods(source,Network,Plate,13,Datatable["mods"]["13"])
												vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
											end
										end

										Wait(100)
									until not Active[Passport]
								end

								TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
								Player(source)["state"]["Buttons"] = false
								vRPC.stopAnim(source,false)
								Active[Passport] = nil
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Transmissão</b> incorreta.","amarelo",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
					end
				end
			end
		end
	end,

	["suspensiona"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				if vCLIENT.CheckCar(source,Vehicle) then
					local PassportPlate = vRP.PassportPlate(Plate)
					if PassportPlate then
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
						if parseInt(#Datatable) > 0 then
							Datatable = json.decode(Datatable[1]["dvalue"])

							if not Datatable["mods"]["15"] then
								Datatable["mods"]["15"] = -1
							end

							if Datatable["mods"]["15"] == -1 then
								if Datatable["mods"]["15"] >= vCLIENT.CheckMods(source,Vehicle,15) then
									TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Suspensão</b> atingida.","amarelo",5000)
								else
									vRPC.stopActived(source)
									Active[Passport] = os.time() + 1000
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
									vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

									if vTASKBAR.Task(source,8,10500) then
										Active[Passport] = os.time() + 120
										TriggerClientEvent("Progress",source,"Aplicando",120000)

										repeat
											if os.time() >= parseInt(Active[Passport]) then
												Active[Passport] = nil
												vRPC.Destroy(source)
												Player(source)["state"]["Buttons"] = false

												if vRP.TakeItem(Passport,Full,1,false,Slot) then
													Datatable["mods"]["15"] = Datatable["mods"]["15"] + 1
													vCLIENT.ActiveMods(source,Network,Plate,15,Datatable["mods"]["15"])
													vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
												end
											end

											Wait(100)
										until not Active[Passport]
									end

									TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
									Player(source)["state"]["Buttons"] = false
									vRPC.stopAnim(source,false)
									Active[Passport] = nil
								end
							else
								TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Suspensão</b> incorreta.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","O veículo <b>"..VehicleName(vehName).."</b> não possui suspensão.","amarelo",5000)
				end
			end
		end
	end,

	["suspensionb"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				if vCLIENT.CheckCar(source,Vehicle) then
					local PassportPlate = vRP.PassportPlate(Plate)
					if PassportPlate then
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
						if parseInt(#Datatable) > 0 then
							Datatable = json.decode(Datatable[1]["dvalue"])

							if not Datatable["mods"]["15"] then
								Datatable["mods"]["15"] = -1
							end

							if Datatable["mods"]["15"] == 0 then
								if Datatable["mods"]["15"] >= vCLIENT.CheckMods(source,Vehicle,15) then
									TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Suspensão</b> atingida.","amarelo",5000)
								else
									vRPC.stopActived(source)
									Active[Passport] = os.time() + 1000
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
									vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

									if vTASKBAR.Task(source,8,10500) then
										Active[Passport] = os.time() + 120
										TriggerClientEvent("Progress",source,"Aplicando",120000)

										repeat
											if os.time() >= parseInt(Active[Passport]) then
												Active[Passport] = nil
												vRPC.Destroy(source)
												Player(source)["state"]["Buttons"] = false

												if vRP.TakeItem(Passport,Full,1,false,Slot) then
													Datatable["mods"]["15"] = Datatable["mods"]["15"] + 1
													vCLIENT.ActiveMods(source,Network,Plate,15,Datatable["mods"]["15"])
													vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
												end
											end

											Wait(100)
										until not Active[Passport]
									end

									TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
									Player(source)["state"]["Buttons"] = false
									vRPC.stopAnim(source,false)
									Active[Passport] = nil
								end
							else
								TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Suspensão</b> incorreta.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","O veículo <b>"..VehicleName(vehName).."</b> não possui suspensão.","amarelo",5000)
				end
			end
		end
	end,

	["suspensionc"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				if vCLIENT.CheckCar(source,Vehicle) then
					local PassportPlate = vRP.PassportPlate(Plate)
					if PassportPlate then
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
						if parseInt(#Datatable) > 0 then
							Datatable = json.decode(Datatable[1]["dvalue"])

							if not Datatable["mods"]["15"] then
								Datatable["mods"]["15"] = -1
							end

							if Datatable["mods"]["15"] == 1 then
								if Datatable["mods"]["15"] >= vCLIENT.CheckMods(source,Vehicle,15) then
									TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Suspensão</b> atingida.","amarelo",5000)
								else
									vRPC.stopActived(source)
									Active[Passport] = os.time() + 1000
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
									vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

									if vTASKBAR.Task(source,8,10500) then
										Active[Passport] = os.time() + 120
										TriggerClientEvent("Progress",source,"Aplicando",120000)

										repeat
											if os.time() >= parseInt(Active[Passport]) then
												Active[Passport] = nil
												vRPC.Destroy(source)
												Player(source)["state"]["Buttons"] = false

												if vRP.TakeItem(Passport,Full,1,false,Slot) then
													Datatable["mods"]["15"] = Datatable["mods"]["15"] + 1
													vCLIENT.ActiveMods(source,Network,Plate,15,Datatable["mods"]["15"])
													vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
												end
											end

											Wait(100)
										until not Active[Passport]
									end

									TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
									Player(source)["state"]["Buttons"] = false
									vRPC.stopAnim(source,false)
									Active[Passport] = nil
								end
							else
								TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Suspensão</b> incorreta.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","O veículo <b>"..VehicleName(vehName).."</b> não possui suspensão.","amarelo",5000)
				end
			end
		end
	end,

	["suspensiond"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				if vCLIENT.CheckCar(source,Vehicle) then
					local PassportPlate = vRP.PassportPlate(Plate)
					if PassportPlate then
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
						if parseInt(#Datatable) > 0 then
							Datatable = json.decode(Datatable[1]["dvalue"])

							if not Datatable["mods"]["15"] then
								Datatable["mods"]["15"] = -1
							end

							if Datatable["mods"]["15"] == 2 then
								if Datatable["mods"]["15"] >= vCLIENT.CheckMods(source,Vehicle,15) then
									TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Suspensão</b> atingida.","amarelo",5000)
								else
									vRPC.stopActived(source)
									Active[Passport] = os.time() + 1000
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
									vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

									if vTASKBAR.Task(source,8,10500) then
										Active[Passport] = os.time() + 120
										TriggerClientEvent("Progress",source,"Aplicando",120000)

										repeat
											if os.time() >= parseInt(Active[Passport]) then
												Active[Passport] = nil
												vRPC.Destroy(source)
												Player(source)["state"]["Buttons"] = false

												if vRP.TakeItem(Passport,Full,1,false,Slot) then
													Datatable["mods"]["15"] = Datatable["mods"]["15"] + 1
													vCLIENT.ActiveMods(source,Network,Plate,15,Datatable["mods"]["15"])
													vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
												end
											end

											Wait(100)
										until not Active[Passport]
									end

									TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
									Player(source)["state"]["Buttons"] = false
									vRPC.stopAnim(source,false)
									Active[Passport] = nil
								end
							else
								TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Suspensão</b> incorreta.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","O veículo <b>"..VehicleName(vehName).."</b> não possui suspensão.","amarelo",5000)
				end
			end
		end
	end,

	["suspensione"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate,vehName = vRPC.VehicleList(source,4)
			if Vehicle then
				if vCLIENT.CheckCar(source,Vehicle) then
					local PassportPlate = vRP.PassportPlate(Plate)
					if PassportPlate then
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName })
						if parseInt(#Datatable) > 0 then
							Datatable = json.decode(Datatable[1]["dvalue"])

							if not Datatable["mods"]["15"] then
								Datatable["mods"]["15"] = -1
							end

							if Datatable["mods"]["15"] == 3 then
								if Datatable["mods"]["15"] >= vCLIENT.CheckMods(source,Vehicle,15) then
									TriggerClientEvent("Notify",source,"Aviso","Limite da <b>Suspensão</b> atingida.","amarelo",5000)
								else
									vRPC.stopActived(source)
									Active[Passport] = os.time() + 1000
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
									vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

									if vTASKBAR.Task(source,8,10500) then
										Active[Passport] = os.time() + 120
										TriggerClientEvent("Progress",source,"Aplicando",120000)

										repeat
											if os.time() >= parseInt(Active[Passport]) then
												Active[Passport] = nil
												vRPC.Destroy(source)
												Player(source)["state"]["Buttons"] = false

												if vRP.TakeItem(Passport,Full,1,false,Slot) then
													Datatable["mods"]["15"] = Datatable["mods"]["15"] + 1
													vCLIENT.ActiveMods(source,Network,Plate,15,Datatable["mods"]["15"])
													vRP.Query("entitydata/SetData",{ dkey = "Mods:"..PassportPlate["Passport"]..":"..vehName, dvalue = json.encode(Datatable) })
												end
											end

											Wait(100)
										until not Active[Passport]
									end

									TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
									Player(source)["state"]["Buttons"] = false
									vRPC.stopAnim(source,false)
									Active[Passport] = nil
								end
							else
								TriggerClientEvent("Notify",source,"Aviso","Modelo da <b>Suspensão</b> incorreta.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Dirija-se até uma mecânica e efetue uma revisão.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","O veículo <b>"..VehicleName(vehName).."</b> não possui suspensão.","amarelo",5000)
				end
			end
		end
	end,

	["toolbox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle then
				vRPC.stopActived(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
				vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

				if vTASKBAR.Task(source,4,20500) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _,v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:repairVehicle",v,Network,Plate)
							end)
						end
					end
				end

				TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source,false)
				Active[Passport] = nil
			end
		end
	end,

	["lockpick"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not Player(source)["state"]["Handcuff"] then
			local Vehicle,Network,Plate,vehName,vehClass = vRPC.VehicleList(source,4)
			if Vehicle then
				local Brokenpick = 950
				if vehClass == 15 or vehClass == 16 or vehClass == 19 then
					return
				end

				if vRPC.InsideVehicle(source) then
					vRPC.stopActived(source)
					vGARAGE.StartHotwired(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)

					if vTASKBAR.Task(source,3,10000) then
						if math.random(100) >= 20 then
							Brokenpick = 900
							TriggerEvent("plateEveryone",Plate)
							TriggerEvent("platePlayers",Plate,Passport)
							TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)

							local Network = NetworkGetEntityFromNetworkId(Network)
							if GetVehicleDoorLockStatus(Network) == 2 then
								SetVehicleDoorsLocked(Network,1)
							end
						end

						if math.random(100) >= 75 then
							local Coords = vRP.GetEntityCoords(Passport)
							local Service = vRP.NumPermission("Policia")
							for Passports,Sources in pairs(Service) do
								async(function()
									TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
								end)
							end
						end
					end

					if math.random(1000) >= Brokenpick then
						if vRP.TakeItem(Passport,Full,1,false) then
							vRP.GiveItem(Passport,"lockpick-0",1,false)
							TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick de Alumínio" })
						end
					end

					Player(source)["state"]["Buttons"] = false
					vGARAGE.StopHotwired(source,vehicle)
					Active[Passport] = nil
				else
					vRPC.stopActived(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)

					if string.sub(Plate,1,4) == "DISM" then
						if vTASKBAR.Task(source,8,10500) then
							Brokenpick = 900
							Active[Passport] = os.time() + 30
							TriggerClientEvent("inventory:DisPed",source)
							TriggerClientEvent("Progress",source,"Usando",30000)

							if math.random(100) >= 25 then
								local Coords = vRP.GetEntityCoords(source)
								local Service = vRP.NumPermission("Policia")
								for Passports,Sources in pairs(Service) do
									async(function()
										TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
									end)
								end
							end

							repeat
								if os.time() >= parseInt(Active[Passport]) then
									Active[Passport] = nil

									TriggerEvent("plateEveryone",Plate)
									TriggerClientEvent("target:Dismantles",source)
									TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)

									local Network = NetworkGetEntityFromNetworkId(Network)
									if GetVehicleDoorLockStatus(Network) == 2 then
										SetVehicleDoorsLocked(Network,1)
									end
								end

								Wait(100)
							until not Active[Passport]
						end
					else
						if vTASKBAR.Task(source,3,20000) then
							Brokenpick = 900

							if math.random(100) >= 75 then
								TriggerEvent("plateEveryone",Plate)
								TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)

								local Network = NetworkGetEntityFromNetworkId(Network)
								if GetVehicleDoorLockStatus(Network) == 2 then
									SetVehicleDoorsLocked(Network,1)
								end
							end

							if math.random(100) >= 25 then
								local Coords = vRP.GetEntityCoords(source)
								local Service = vRP.NumPermission("Policia")
								for Passports,Sources in pairs(Service) do
									async(function()
										TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
									end)
								end
							end
						end
					end

					if math.random(1000) >= Brokenpick then
						if vRP.TakeItem(Passport,Full,1,false) then
							vRP.GiveItem(Passport,"lockpick-0",1,false)
							TriggerClientEvent("itensNotify",source,{ "quebrou","lockpick",1,"Lockpick de Alumínio" })
						end
					end

					Player(source)["state"]["Buttons"] = false
					vRPC.Destroy(source)
					Active[Passport] = nil
				end
			end
		end
	end,

	["blocksignal"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not Player(source)["state"]["Handcuff"] then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle and vRPC.InsideVehicle(source) then
				if not exports["garages"]:Signal(Plate) then
					vRPC.stopActived(source)
					vGARAGE.StartHotwired(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)

					if vTASKBAR.Task(source,3,20000) then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							TriggerClientEvent("Notify",source,"Aviso","<b>Bloqueador de Sinal</b> instalado.","verde",5000)
							TriggerEvent("signalRemove",Plate)
						end
					end

					Player(source)["state"]["Buttons"] = false
					vGARAGE.StopHotwired(source)
					Active[Passport] = nil
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>Bloqueador de Sinal</b> já instalado.","amarelo",5000)
				end
			end
		end
	end,

	["postit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("postit:initPostit",source)
	end,

	["dismantle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vCLIENT.DismantleStatus(source) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Close",source)

				Dismantle[Passport] = vRP.GetExperience(Passport,"Dismantle")
				if math.random(100) <= 15 then
					Dismantle[Passport] = math.random(1000)
				end

				vCLIENT.Dismantle(source,Dismantle[Passport])
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Você possui um contrato ativo.","amarelo",5000)
		end
	end,

	["absolut"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hennessy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chandon"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["dewars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["scanner"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Scanners[Passport] = true
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("inventory:updateScanner",source,true)
		vRPC.createObjects(source,"mini@golfai","wood_idle_a","w_am_digiscanner",49,18905,0.15,0.1,0.0,-270.0,-180.0,-170.0)
	end,

	["orangejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["passionjuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.DowngradeStress(Passport,5)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tangejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["grapejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["strawberryjuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["bananajuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["acerolajuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["orange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["apple"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["strawberry"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["coffee2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["grape"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["banana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["acerola"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["passion"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tomato"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["guarana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["wheat"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,Item,5) then
			if (vRP.InventoryWeight(Passport) + (itemWeight("wheatflour"))) <= vRP.GetWeight(Passport) then
				if vRP.TakeItem(Passport,Full,5,true,Slot) then
					vRP.GenerateItem(Passport,"wheatflour",1,false)
					TriggerClientEvent("inventory:Update",source,"Backpack")
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Você precisa de <b>5x "..itemName(Item).."</b>.","amarelo",5000)
		end
	end,

	["water"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					vRP.UpgradeThirst(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["dirtywater"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					TriggerClientEvent("resetDrugs",source)
					vRPC.DowngradeHealth(Passport,5)
					vRP.UpgradeThirst(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["emptybottle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Status,Style = vCLIENT.checkFountain(source)
		if Status then
			if Style == "fountain" then
				if vRP.MaxItens(Passport,"water",Amount) then
					TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",3000)
					return
				end
				
				vRPC.playAnim(source,true,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			elseif Style == "floor" then
				if vRP.MaxItens(Passport,"dirtywater",Amount) then
					TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",3000)
					return
				end

				vRPC.playAnim(source,true,{"amb@world_human_bum_wash@male@high@base","base"},true)
			end

			vRPC.stopActived(source)
			Active[Passport] = os.time() + 30
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Coletando",30000)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source,"one")
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						if Style == "floor" then
							vRP.GenerateItem(Passport,"dirtywater",Amount,true)
						else
							vRP.GenerateItem(Passport,"water",Amount,true)
						end
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["milkbottle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					vRP.UpgradeThirst(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["guarananatural"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.createObjects(source,"amb@world_human_drinking@coffee@male@idle_a","idle_c","prop_food_bs_juice02",49,28422,0.0,-0.01,-0.15,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,10,1.10)
					vRP.UpgradeThirst(Passport,25)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["sinkalmy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,5)
					vRP.ChemicalTimer(Passport,3)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["ritmoneury"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,5)
					vRP.ChemicalTimer(Passport,3)
					vRP.DowngradeStress(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cola"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309,0.01,0.01,0.05,0.0,0.0,90.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["soda"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309,0.0,0.0,-0.04,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["fishingrod"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vCLIENT.Fishing(source) then
			vRPC.stopActived(source)
			Active[Passport] = os.time() + 100
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)

			vRPC.createObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)

			if vTASKBAR.Task(source,3,90000) then
				local fishList = { "octopus","shrimp","carp","horsefish","tilapia","codfish","catfish","goldenfish","pirarucu","pacu","tambaqui" }
				local fishRandom = math.random(#fishList)
				local fishSelects = fishList[fishRandom]

				if (vRP.InventoryWeight(Passport) + itemWeight(fishSelects)) <= vRP.GetWeight(Passport) then
					if vRP.TakeItem(Passport,"bait",1,false) then
						local Experience = vRP.GetExperience(Passport,"Fishing")
						local Category = ClassCategory(Experience)
						local Valuation = 100

						if Category == "B+" then
							Valuation = Valuation + 20
						elseif Category == "A" then
							Valuation = Valuation + 40
						elseif Category == "A+" then
							Valuation = Valuation + 60
						elseif Category == "S" then
							Valuation = Valuation + 80
						elseif Category == "S+" then
							Valuation = Valuation + 100
						end

						if Buffs["Dexterity"][Passport] then
							if Buffs["Dexterity"][Passport] > os.time() then
								Valuation = Valuation + (Valuation * 0.1)
							end
						end

						vRP.PutExperience(Passport,"Fishing",1)
						vRP.GenerateItem(Passport,fishSelects,1,true)
					else
						TriggerClientEvent("Notify",source,"Aviso","Precisa de <b>1x "..itemName("bait").."</b>.","amarelo",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
				end
			end

			Player(source)["state"]["Buttons"] = false
			vRPC.Destroy(source,"one")
			Active[Passport] = nil
		end
	end,

	["coffeemilk"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,10,1.10)
					vRP.UpgradeThirst(Passport,20)
					vRP.UpgradeHunger(Passport,8)

					if vCLIENT.Restaurant(source,"BeanMachine") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzamozzarella"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,40)

					if vCLIENT.Restaurant(source,"PizzaThis") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzabanana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,40)

					if vCLIENT.Restaurant(source,"PizzaThis") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzachocolate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)

					if vCLIENT.Restaurant(source,"PizzaThis") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["sushi"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["nigirizushi"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,25)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["calzone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)

					if vCLIENT.Restaurant(source,"PizzaThis") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chickenfries"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)

					if vCLIENT.Restaurant(source,"PizzaThis") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cookies"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,20,1.10)
					vRP.UpgradeHunger(Passport,30)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Luck",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["onionrings"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cannedsoup"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["canofbeans"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tablecoke"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_coke_table01a"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = heading, object = Hash, item = Full, Distance = 50, mode = "1" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["tablemeth"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_meth_table01a"
		local Application,Coords,heading = vRPC.objectCoords(source,Hash)
		if Application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "1" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["tableweed"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_weed_table_01a"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "1" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["sprays01"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "spray_01"
		local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
		if Application then
			vRPC.stopActived(source)
			Active[Passport] = os.time() + 5
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Pichando",5000)
			vRPC.createObjects(source,"switch@franklin@lamar_tagging_wall","lamar_tagging_exit_loop_lamar","prop_cs_spray_can",1,28422,0.0,0.0,0.0,0.0,0.0,0.0)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Number = 0

						repeat
							Number = Number + 1
						until not Objects[tostring(Number)]

						Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(Heading), object = Hash, item = Full, Distance = 100, mode = "Spray" }
						TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
					end
				end

				Wait(100)
			until not Active[Passport]
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["campfire"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_beach_fire"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) + 0.10, h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "2" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barrier"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_mp_barrier_02b"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["medicbag"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "xm_prop_x17_bag_med_01a"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "4" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["weedclone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_weed_med_01a"
		local Application,Coords = vRPC.objectCoords(source,Hash)
		if Application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)

					if vTASKBAR.Task(source,4,10500) then
						local Points = 0
						local Route = GetPlayerRoutingBucket(source)

						if Split[2] ~= nil then
							Points = parseInt(Split[2])
						end

						exports["plants"]:Plants(Coords,Route,Points)
					end

					vRPC.Destroy(source)
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["medicbed"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_ld_binbag_01"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				local mHash = GetHashKey(Hash)
				local Object = CreateObject(mHash,Coords["x"],Coords["y"],Coords["z"] - 0.86,true,true,false)

				while not DoesEntityExist(Object) do
					Wait(100)
				end

				if DoesEntityExist(Object) then
					SetEntityHeading(Object,heading)
					FreezeEntityPosition(Object,true)
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["c4"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "ch_prop_ch_ld_bomb_01a"
		local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
		if Application then
			local CoordsAtm,NumberAtm = vCLIENT.checkAtm(source,Coords)

			if CoordsAtm then
				if not AtmTimers[NumberAtm] then
					AtmTimers[NumberAtm] = os.time()
				end

				if os.time() < AtmTimers[NumberAtm] then
					local Cooldown = parseInt(AtmTimers[NumberAtm] - os.time())
					TriggerClientEvent("Notify",source,false,"Caixa vazio, aguarde <b>"..Cooldown.."</b> segundos até que um transportador venha até o local efetuar reabastecimento do mesmo.","azul",5000)
					Player(source)["state"]["Buttons"] = false

					return
				end

				local Service = vRP.NumPermission("Policia")
				if parseInt(GlobalState["Policia"]) >= 2 then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Number = 0

						repeat
							Number = Number + 1
						until not Objects[tostring(Number)]

						Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(Heading), object = Hash, item = Full, Distance = 100 }
						TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
						TriggerClientEvent("Progress",source,"Plantando",25000)
						AtmTimers[NumberAtm] = os.time() + 10800
						local explosionProgress = 25

						for Passports,Sources in pairs(Service) do
							async(function()
								vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
								TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Caixa Eletrônico", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
							end)
						end

						repeat
							Wait(1000)
							explosionProgress = explosionProgress - 1
						until explosionProgress <= 0

						TriggerClientEvent("player:Residuals",source,"Resíduo de Explosivo.")
						TriggerClientEvent("objects:Remover",-1,tostring(Number))
						TriggerClientEvent("vRP:Explosion",source,Coords)
						TriggerEvent("Wanted",source,Passport,600)

						if GlobalState["Blackout"] == 1 then
							Creative.DropServer(CoordsAtm,"dollars",math.random(2500 * 5,5000 * 5))
						else
							Creative.DropServer(CoordsAtm,"dollars",math.random(2500,5000))
						end
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Contingente indisponível.","vermelho",5000)
					Player(source)["state"]["Buttons"] = false
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["carp"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["codfish"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["catfish"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["goldenfish"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["horsefish"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["tilapia"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["pacu"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["pirarucu"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["tambaqui"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight("fishfillet") * 2) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"fishfillet",2)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
		end
	end,

	["cookedfishfillet"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cookedmeat"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hotdog"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["sandwich"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)

					if vCLIENT.Restaurant(source,"BeanMachine") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tacos"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_taco_01",49,18905,0.16,0.06,0.02,-50.0,220.0,60.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["fries"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["milkshake"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cappuccino"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["applelove"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,20,1.10)
					vRP.UpgradeHunger(Passport,10)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cupcake"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,20,1.10)
					vRP.UpgradeHunger(Passport,10)

					if vCLIENT.Restaurant(source,"UwuCoffee") then
						TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",600)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["marshmallow"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",3000)
		vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,5)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chocolate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,8)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["donut"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.stopActived(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_amb_donut",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("setEnergetic",source,20,1.10)
					vRP.UpgradeHunger(Passport,8)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["notepad"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 100
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Keyboard = vKEYBOARD.keySingle(source,"Mensagem:")
		if Keyboard then
			if vRP.TakeItem(Passport,Full,1,false,Slot) then
				if Split[2] then
					vRP.SetSrvData(Full,Keyboard[1])
					vRP.GenerateItem(Passport,Full,1,false)
				else
					local Time = os.time()
					vRP.SetSrvData("notepad-"..Time,Keyboard[1])
					vRP.GenerateItem(Passport,"notepad-"..Time,1,false)
				end
			end

			TriggerClientEvent("inventory:Update",source,"Backpack")
		end

		Player(source)["state"]["Buttons"] = false
		Active[Passport] = nil
	end,

	["megaphone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("player:Megaphone",source)
		TriggerClientEvent("pma-voice:Megaphone",source,true)
		TriggerEvent("pma-voice:Megaserver",source,true)
		TriggerClientEvent("emotes",source,"megaphone")
	end,

	["notebook"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("notebook:openSystem",source)
	end,

	["tyres"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			if not vCLIENT.checkWeapon(source,"WEAPON_WRENCH") then
				TriggerClientEvent("Notify",source,"Aviso","<b>Chave Inglesa</b> não encontrada.","amarelo",5000)
				return
			end

			local tyreStatus,Tyre,Network,Plate = vCLIENT.tyreStatus(source)
			if tyreStatus then
				local Vehicle = NetworkGetEntityFromNetworkId(Network)
				if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
					if vCLIENT.tyreHealth(source,Network,Tyre) ~= 1000.0 then
						vRPC.stopActived(source)
						Active[Passport] = os.time() + 100
						Player(source)["state"]["Buttons"] = true
						TriggerClientEvent("inventory:Close",source)
						vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

						if vTASKBAR.Task(source,3,70500) then
							if vRP.TakeItem(Passport,Full,1,true,Slot) then
								local Players = vRPC.Players(source)
								for _,v in pairs(Players) do
									async(function()
										TriggerClientEvent("inventory:repairTyre",v,Network,Tyre,Plate)
									end)
								end
							end
						end

						Player(source)["state"]["Buttons"] = false
						vRPC.stopAnim(source,false)
						Active[Passport] = nil
					end
				end
			end
		end
	end,

	["premiumplate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRPC.InsideVehicle(source) then
			TriggerClientEvent("inventory:Close",source)

			local vehModel = vRPC.VehicleName(source)
			local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehModel })
			if vehicle[1] then
				local Keyboard = vKEYBOARD.keySingle(source,"Placa: (8 Caracteres)")
				if Keyboard then
					local namePlate = string.sub(Keyboard[1],1,8)
					local plateCheck = sanitizeString(namePlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)

					if string.len(plateCheck) ~= 8 then
						TriggerClientEvent("Notify",source,"Aviso","O nome de definição para a placa inválida.","amarelo",5000)
						return
					else
						if vRP.PassportPlate(namePlate) then
							TriggerClientEvent("Notify",source,"Aviso","A placa escolhida já possui em outro veículo.","vermelho",5000)
							return
						else
							if vRP.TakeItem(Passport,Full,1,true,Slot) then
								vRP.Query("vehicles/plateVehiclesUpdate",{ Passport = Passport, vehicle = vehModel, plate = string.upper(namePlate) })
								TriggerClientEvent("Notify",source,"Aviso","Placa atualizada.","verde",5000)
							end
						end
					end
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Modelo de veículo não encontrado.","vermelho",5000)
			end
		end
	end,

	["radio"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("radio:RadioNui",source)
		vRPC.stopActived(source)
	end,

	["scuba"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("hud:Scuba",source)
	end,

	["handcuff"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local ClosestPed = vRPC.ClosestPed(source,1)
			if ClosestPed then
				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true

				if Player(ClosestPed)["state"]["Handcuff"] then
					Player(ClosestPed)["state"]["Handcuff"] = false
					Player(ClosestPed)["state"]["Commands"] = false
					TriggerClientEvent("sounds:Private",source,"uncuff",0.5)
					TriggerClientEvent("sounds:Private",ClosestPed,"uncuff",0.5)

					vRPC.Destroy(ClosestPed)
				else
					TriggerClientEvent("hud:RadioClean",ClosestPed)
					TriggerClientEvent("player:Carry",ClosestPed,source,"handcuff")
					vRPC.playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
					vRPC.playAnim(ClosestPed,false,{"mp_arrest_paired","crook_p2_back_left"},false)

					Wait(3500)

					vRPC.Destroy(source)
					Player(ClosestPed)["state"]["Handcuff"] = true
					Player(ClosestPed)["state"]["Commands"] = true
					TriggerClientEvent("inventory:Close",ClosestPed)
					TriggerClientEvent("sounds:Private",source,"cuff",0.5)
					TriggerClientEvent("sounds:Private",ClosestPed,"cuff",0.5)
					TriggerClientEvent("player:Carry",ClosestPed,source)
				end

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
			end
		end
	end,

	["hood"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if Player(ClosestPed)["state"]["Handcuff"] then
				TriggerClientEvent("hud:Hood",source,true)
				TriggerClientEvent("inventory:Close",ClosestPed)
			end
		end
	end,

	["rope"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			if Carry[Passport] then
				TriggerClientEvent("player:Rope",Carry[Passport],source)
				TriggerClientEvent("player:Commands",Carry[Passport],false)
				vRPC.Destroy(Carry[Passport])
				vRPC.Destroy(source)
				Carry[Passport] = nil
			else
				local ClosestPed = vRPC.ClosestPed(source,2)
				if ClosestPed then
					if vRP.GetHealth(ClosestPed) <= 100 or Player(ClosestPed)["state"]["Handcuff"] then
						Carry[Passport] = ClosestPed

						TriggerClientEvent("player:Rope",Carry[Passport],source)
						TriggerClientEvent("player:Commands",Carry[Passport],true)
						TriggerClientEvent("inventory:Close",Carry[Passport])

						vRPC.playAnim(source,true,{"missfinale_c2mcs_1","fin_c2_mcs_1_camman"},true)
						vRPC.playAnim(ClosestPed,false,{"nm","firemans_carry"},true)
					end
				end
			end
		end
	end,

	["premium"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRP.UserPremium(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"Sucesso","<b>Premium</b> ativado.","verde",5000)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerEvent("Salary:Add",Passport,"Premium")
				vRP.SetPremium(Passport)
			end
		else
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"Atenção","<b>Premium</b> renovado.","amarelo",5000)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerEvent("Salary:Add",Passport,"Premium")
				vRP.UpgradePremium(Passport)
			end
		end
	end,

	["creator"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		if vRP.TakeItem(Passport,Full,1,false,Slot) then
			TriggerClientEvent("barbershop:Open",source,"open",true)
		end
	end,

	["pager"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if Player(ClosestPed)["state"]["Handcuff"] then
				local OtherPassport = vRP.Passport(ClosestPed)
				if OtherPassport then
					if vRP.HasGroup(OtherPassport,"Policia") then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							vRP.ServiceLeave(ClosestPed,OtherPassport,"Policia")
							TriggerClientEvent("Notify",source,"Aviso","Todas as comunicações foram retiradas.","amarelo",5000)
						end
					end

					if vRP.HasGroup(OtherPassport,"Paramedico") then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							vRP.ServiceLeave(ClosestPed,OtherPassport,"Paramedico")
							TriggerClientEvent("Notify",source,"Aviso","Todas as comunicações foram retiradas.","amarelo",5000)
						end
					end
				end
			end
		end
	end
}