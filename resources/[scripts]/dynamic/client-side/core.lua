-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local animalHash = nil
local spawnAnimal = false
local animalFollow = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,id)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = id })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu",function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true,true)
	menuOpen = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(Data,Callback)
	if Data["trigger"] and Data["trigger"] ~= "" then
		if Data["server"] == "true" then
			TriggerServerEvent(Data["trigger"],Data["param"])
		else
			TriggerEvent(Data["trigger"],Data["param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
	menuOpen = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function()
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and MumbleIsConnected() and LocalPlayer["state"]["Route"] < 900000 and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if GetEntityHealth(Ped) > 100 then
			if animalHash ~= nil then
				exports["dynamic"]:AddButton("Seguir","Seguir o propriet??rio.","dynamic:animalFunctions","seguir","animal",false)
				exports["dynamic"]:AddButton("Colocar no Ve??culo","Colocar o animal no ve??culo.","dynamic:animalFunctions","colocar","animal",false)
				exports["dynamic"]:AddButton("Remover do Ve??culo","Remover o animal no ve??culo.","dynamic:animalFunctions","remover","animal",false)
			end

			exports["dynamic"]:AddButton("Chap??u","Colocar/Retirar o chap??u.","player:Outfit","Hat","clothes",true)
			exports["dynamic"]:AddButton("M??scara","Colocar/Retirar a m??scara.","player:Outfit","Mask","clothes",true)
			exports["dynamic"]:AddButton("??culos","Colocar/Retirar o ??culos.","player:Outfit","Glasses","clothes",true)
			exports["dynamic"]:AddButton("Vestir","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicar","clothes",true)
			exports["dynamic"]:AddButton("Guardar","Salvar suas vestimentas do corpo.","player:Outfit","salvar","clothes",true)

			exports["dynamic"]:AddButton("Propriedades","Marcar/Desmarcar propriedades no mapa.","propertys:Blips","","others",false)
			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:Injuries","","others",false)
			exports["dynamic"]:AddButton("Desbugar","Recarregar o personagem.","barbershop:Debug","","others",true)

			local Vehicle = vRP.ClosestVehicle(7)
			if IsEntityAVehicle(Vehicle) then
				if not IsPedInAnyVehicle(Ped) then
					exports["dynamic"]:AddButton("Rebocar","Colocar ve??culo na prancha do reboque.","towdriver:invokeTow","","vehicle",false)

					if vRP.ClosestPed(3) then
						exports["dynamic"]:AddButton("Colocar no Ve??culo","Colocar no ve??culo mais pr??ximo.","player:cvFunctions","cv","closestpeds",true)
						exports["dynamic"]:AddButton("Remover do Ve??culo","Remover do ve??culo mais pr??ximo.","player:cvFunctions","rv","closestpeds",true)

						exports["dynamic"]:SubMenu("Jogador","Pessoa mais pr??xima de voc??.","closestpeds")
					end
				else
					exports["dynamic"]:AddButton("Sentar no Motorista","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
					exports["dynamic"]:AddButton("Sentar no Passageiro","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
					exports["dynamic"]:AddButton("Sentar em Outros","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
					exports["dynamic"]:AddButton("Mexer nos Vidros","Levantar/Abaixar os vidros.","player:Windows","","vehicle",false)
				end

				exports["dynamic"]:AddButton("Porta do Motorista","Abrir porta do motorista.","player:Doors","1","doors",true)
				exports["dynamic"]:AddButton("Porta do Passageiro","Abrir porta do passageiro.","player:Doors","2","doors",true)
				exports["dynamic"]:AddButton("Porta Traseira Esquerda","Abrir porta traseira esquerda.","player:Doors","3","doors",true)
				exports["dynamic"]:AddButton("Porta Traseira Direita","Abrir porta traseira direita.","player:Doors","4","doors",true)
				exports["dynamic"]:AddButton("Porta-Malas","Abrir porta-malas.","player:Doors","5","doors",true)
				exports["dynamic"]:AddButton("Cap??","Abrir cap??.","player:Doors","6","doors",true)

				exports["dynamic"]:SubMenu("Ve??culo","Fun????es do ve??culo.","vehicle")
				exports["dynamic"]:SubMenu("Portas","Portas do ve??culo.","doors")
			end

			local Experience = vSERVER.Experience()
			for Name,Exp in pairs(Experience) do
				exports["dynamic"]:AddButton(Name,"Voc?? possu?? <yellow>"..Exp.." pontos</yellow> na classe <yellow>"..ClassCategory(Exp).."</yellow>.","","","Experience",false)
			end
			
			if animalHash ~= nil then
				exports["dynamic"]:SubMenu("Dom??sticos","Todas as fun????es dos animais dom??sticos.","animal")
			end

			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","clothes")
			exports["dynamic"]:SubMenu("Experi??ncia","Todas as suas habilidades.","Experience")
			exports["dynamic"]:SubMenu("Outros","Todas as fun????es do personagem.","others")

			exports["dynamic"]:openMenu()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function()
	if (LocalPlayer["state"]["Policia"] or LocalPlayer["state"]["Paramedico"]) and not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and MumbleIsConnected() and LocalPlayer["state"]["Route"] < 900000 then

			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) > 100 then
				if not IsPedInAnyVehicle(Ped) then
					exports["dynamic"]:AddButton("Carregar","Carregar a pessoa mais pr??xima.","player:carryPlayer","","player",true)
					exports["dynamic"]:AddButton("Colocar no Ve??culo","Colocar no ve??culo mais pr??ximo.","player:cvFunctions","cv","player",true)
					exports["dynamic"]:AddButton("Remover do Ve??culo","Remover do ve??culo mais pr??ximo.","player:cvFunctions","rv","player",true)

					exports["dynamic"]:SubMenu("Jogador","Pessoa mais pr??xima de voc??.","player")
				end

				if LocalPlayer["state"]["Policia"] then
					exports["dynamic"]:AddButton("Remover Chap??u","Remover da pessoa mais pr??xima.","skinshop:Remove","Hat","player",true)
					exports["dynamic"]:AddButton("Remover M??scara","Remover da pessoa mais pr??xima.","skinshop:Remove","Mask","player",true)
					exports["dynamic"]:AddButton("Remover ??culos","Remover da pessoa mais pr??xima.","skinshop:Remove","Glasses","player",true)

					exports["dynamic"]:AddButton("Sheriff","Fardamento de oficial.","player:Preset","1","prePolice",true)
					exports["dynamic"]:AddButton("State Police","Fardamento de oficial.","player:Preset","2","prePolice",true)
					exports["dynamic"]:AddButton("Park Ranger","Fardamento de oficial.","player:Preset","3","prePolice",true)
					exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","player:Preset","4","prePolice",true)
					exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","player:Preset","5","prePolice",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
					exports["dynamic"]:AddButton("Computador","Computador de bordo policial.","police:Mdt","",false,false)
				elseif LocalPlayer["state"]["Paramedico"] then
					exports["dynamic"]:AddButton("Medical Center","Fardamento de doutor.","player:Preset","6","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico.","player:Preset","7","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico interno.","player:Preset","8","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de atendimentos.","player:Preset","9","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de mergulhador.","player:Preset","10","preMedic",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos m??dicos.","preMedic")
				end

				exports["dynamic"]:openMenu()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emergencial.","keyboard","F10")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalSpawn")
AddEventHandler("dynamic:animalSpawn",function(model)
	if animalHash == nil then
		if not spawnAnimal then
			spawnAnimal = true

			local Ped = PlayerPedId()
			local heading = GetEntityHeading(Ped)
			local coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,1.0,0.0)
			local myObject,objNet = vRPS.CreatePed(model,coords["x"],coords["y"],coords["z"],heading,28)
			if myObject then
				local spawnAnimal = 0
				animalHash = NetworkGetEntityFromNetworkId(objNet)
				while not DoesEntityExist(animalHash) and spawnAnimal <= 1000 do
					animalHash = NetworkGetEntityFromNetworkId(objNet)
					spawnAnimal = spawnAnimal + 1
					Wait(1)
				end

				spawnAnimal = 0
				local pedControl = NetworkRequestControlOfEntity(animalHash)
				while not pedControl and spawnAnimal <= 1000 do
					pedControl = NetworkRequestControlOfEntity(animalHash)
					spawnAnimal = spawnAnimal + 1
					Wait(1)
				end

				SetPedCanRagdoll(animalHash,false)
				SetEntityInvincible(animalHash,true)
				SetPedFleeAttributes(animalHash,0,0)
				SetEntityAsMissionEntity(animalHash,true,false)
				SetBlockingOfNonTemporaryEvents(animalHash,true)
				SetPedRelationshipGroupHash(animalHash,GetHashKey("k9"))
				GiveWeaponToPed(animalHash,GetHashKey("WEAPON_ANIMAL"),200,true,true)
		
				SetEntityAsNoLongerNeeded(animalHash)

				TriggerEvent("dynamic:animalFunctions","seguir")

				vSERVER.AnimalRegister(objNet)
			end

			spawnAnimal = false
		end
	else
		vSERVER.AnimalCleaner()
		animalFollow = false
		animalHash = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalFunctions")
AddEventHandler("dynamic:animalFunctions",function(functions)
	if animalHash ~= nil then
		local Ped = PlayerPedId()

		if functions == "seguir" then
			if not animalFollow then
				TaskFollowToOffsetOfEntity(animalHash,Ped,1.0,1.0,0.0,5.0,-1,2.5,1)
				SetPedKeepTask(animalHash,true)
				animalFollow = true
			else
				SetPedKeepTask(animalHash,false)
				ClearPedTasks(animalHash)
				animalFollow = false
			end
		elseif functions == "colocar" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				local vehicle = GetVehiclePedIsUsing(Ped)
				if IsVehicleSeatFree(vehicle,0) then
					TaskEnterVehicle(animalHash,vehicle,-1,0,2.0,16,0)
				end
			end
		elseif functions == "remover" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TaskLeaveVehicle(animalHash,GetVehiclePedIsUsing(Ped),256)
				TriggerEvent("dynamic:animalFunctions","seguir")
			end
		elseif functions == "deletar" then
			vSERVER.AnimalCleaner()
			animalFollow = false
			animalHash = nil
		end
	end
end)