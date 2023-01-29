-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("propertys",Creative)
vSERVER = Tunnel.getInterface("propertys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = ""
local Blips = {}
local Chest = ""
local Markers = {}
local Interior = ""
local Propertys = {}
local Informations = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			if Init == "" then
				for Name,v in pairs(Propertys) do
					if #(Coords - v) <= 1.0 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) then
							local Option,Table = vSERVER.Propertys(Name)

							if Option == "Corretor" then
								for Line,v in pairs(Table) do
									exports["dynamic"]:AddButton("Baú","Total de <yellow>"..v["Vault"].."Kg</yellow> no compartimento.","","",Line,false)
									exports["dynamic"]:AddButton("Geladeira","Total de <yellow>"..v["Fridge"].."Kg</yellow> no compartimento.","","",Line,false)
									exports["dynamic"]:AddButton("Credenciais","Máximo de <yellow>1</yellow> proprietário e <yellow>3</yellow> moradores.","","",Line,false)
									exports["dynamic"]:AddButton("Comprar com Gemas","Custo de <yellow>"..parseFormat(v["Gemstone"]).."</yellow> gemas.","propertys:Buy",Name.."-"..Line.."-Gemstone",Line,true)
									exports["dynamic"]:AddButton("Comprar com Dólares","Custo de <yellow>$"..parseFormat(v["Price"]).."</yellow> dólares.","propertys:Buy",Name.."-"..Line.."-Dollars",Line,true)
									exports["dynamic"]:SubMenu(Line,"Informações sobre o interior.",Line)
								end

								exports["dynamic"]:openMenu()
							elseif Option == "Player" then
								Interior = Table["Interior"]

								if string.sub(Name,1,9) == "Propertys" then
									exports["dynamic"]:AddButton("Entrar","Adentrar a propriedade.","propertys:Enter",Name,false,false)
									exports["dynamic"]:AddButton("Credenciais","Reconfigurar os cartões de acesso.","propertys:Credentials",Name,false,true)
									exports["dynamic"]:AddButton("Fechadura","Trancar/Destrancar a propriedade.","propertys:Lock",Name,false,true)
									exports["dynamic"]:AddButton("Garagem","Adicionar/Reajustar a garagem.","garages:Propertys",Name,false,true)
									exports["dynamic"]:AddButton("Hipoteca","Próximo pagamento em "..Table["Tax"]..".","","",false,false)
									exports["dynamic"]:AddButton("Vender","Se desfazer da propriedade.","propertys:Sell",Name,false,true)

									exports["dynamic"]:openMenu()
								else
									TriggerEvent("propertys:Enter",Name)
								end
							end
						end
					end
				end
			else
				if Informations[Interior] then
					SetPlayerBlipPositionThisFrame(Propertys[Init]["x"],Propertys[Init]["y"])

					if Coords["z"] < (Informations[Interior]["Exit"]["z"] - 25.0) then
						SetEntityCoords(Ped,Informations[Interior]["Exit"],false,false,false,false)
					end

					for Line,v in pairs(Informations[Interior]) do
						if #(Coords - v) <= 1.0 then
							TimeDistance = 1

							if Line == "Exit" and IsControlJustPressed(1,38) then
								SetEntityCoords(Ped,Propertys[Init],false,false,false,false)
								TriggerServerEvent("propertys:Toggle",Init)
								Interior = ""
								Chest = ""
								Init = ""
							elseif (Line == "Vault" or Line == "Fridge") and IsControlJustPressed(1,38) then
								SendNUIMessage({ Action = "Show" })
								SetNuiFocus(true,true)
								Chest = Line
							elseif Line == "Clothes" and IsControlJustPressed(1,38) then
								ClothesMenu()
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHESMENU
-----------------------------------------------------------------------------------------------------------------------------------------
function ClothesMenu()
	exports["dynamic"]:AddButton("Guardar","Salvar suas vestimentas do corpo.","propertys:Clothes","save",false,true)
	exports["dynamic"]:AddButton("Shopping","Abrir a loja de vestimentas.","skinshop:Propertys","",false,false)
	exports["dynamic"]:SubMenu("Vestir","Abrir lista com todas as vestimentas.","apply")
	exports["dynamic"]:SubMenu("Remover","Abrir lista com todas as vestimentas.","delete")

	local Clothes = vSERVER.Clothes()
	if parseInt(#Clothes) > 0 then
		for _,v in pairs(Clothes) do
			exports["dynamic"]:AddButton(v["name"],"Vestir-se com as vestimentas.","propertys:Clothes","apply-"..v["name"],"apply",true)
			exports["dynamic"]:AddButton(v["name"],"Remover a vestimenta salva.","propertys:Clothes","delete-"..v["name"],"delete",true)
		end
	end

	exports["dynamic"]:openMenu()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CLOTHESRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:ClothesReset")
AddEventHandler("propertys:ClothesReset",function()
	TriggerEvent("dynamic:closeSystem")
	ClothesMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Enter")
AddEventHandler("propertys:Enter",function(Name)
	Init = Name

	local Ped = PlayerPedId()
	TriggerEvent("dynamic:closeSystem")
	TriggerServerEvent("propertys:Toggle",Init)
	SetEntityCoords(Ped,Informations[Interior]["Exit"],false,false,false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	local Inventory,Chest,InvPeso,InvMax,ChestPeso,ChestMax = vSERVER.OpenChest(Init,Chest)
	if Inventory then
		Callback({ Inventory = Inventory, Chest = Chest, InvPeso = InvPeso, InvMax = InvMax, ChestPeso = ChestPeso, ChestMax = ChestMax })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ Action = "Hide" })
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	vSERVER.Take(Data["slot"],Data["amount"],Data["target"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"],Init,Chest)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Update")
AddEventHandler("propertys:Update",function()
	SendNUIMessage({ Action = "Request" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:WEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Weight")
AddEventHandler("propertys:Weight",function(InvPeso,InvMax,ChestPeso,ChestMax)
	SendNUIMessage({ Action = "Weight", InvPeso = InvPeso, InvMax = InvMax, ChestPeso = ChestPeso, ChestMax = ChestMax })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Table")
AddEventHandler("propertys:Table",function(PropTable,PropInfos,PropMarkers)
	Markers = PropMarkers
	Propertys = PropTable
	Informations = PropInfos

	local Tables = {}
	for _,v in pairs(Propertys) do
		Tables[#Tables + 1] = { v["x"],v["y"],v["z"],1.0,"E","Propriedade","Pressione para acessar" }
	end

	for _,Intern in pairs(Informations) do
		for Line,v in pairs(Intern) do
			local Message = "Saída"

			if Line == "Vault" then
				Message = "Baú"
			elseif Line == "Fridge" then
				Message = "Geladeira"
			elseif Line == "Clothes" then
				Message = "Armário"
			end

			Tables[#Tables + 1] = { v["x"],v["y"],v["z"],1.0,"E",Message,"Pressione para acessar" }
		end
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Blips")
AddEventHandler("propertys:Blips",function()
	if json.encode(Blips) ~= "[]" then
		for _,v in pairs(Blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		Blips = {}

		TriggerEvent("Notify","Sucesso","Marcações desativadas.","verde",10000)
	else
		for Name,v in pairs(Propertys) do
			Blips[Name] = AddBlipForCoord(v["x"],v["y"],v["z"])
			SetBlipSprite(Blips[Name],374)
			SetBlipAsShortRange(Blips[Name],true)
			SetBlipColour(Blips[Name],Markers[Name] and 35 or 43)
			SetBlipScale(Blips[Name],0.4)
		end

		TriggerEvent("Notify","Sucesso","Marcações ativadas.","verde",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:MARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Markers")
AddEventHandler("propertys:Markers",function(PropMarkers)
	Markers = PropMarkers
end)