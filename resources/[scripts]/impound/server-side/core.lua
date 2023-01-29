-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Impound = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND:CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("impound:Check")
AddEventHandler("impound:Check",function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Impound[entity[2].."-"..entity[1]] then
			Active[Passport] = nil
			return
		else
			Impound[entity[2].."-"..entity[1]] = nil

			local VehRandom = 1000
			local VehParts = math.random(4)
			local VehSelected = "suspension"
			local AmountItens = math.random(4,5)
			local Tow = vRP.GetExperience(Passport,"Tows")
			local Class = ClassCategory(Tow)

			if Class == "B" or Class == "B+" then
				VehRandom = math.random(4500)
			elseif Class == "A" or Class == "A+" then
				VehRandom = math.random(3500)
			elseif Class == "S" or Class == "S+" then
				VehRandom = math.random(2500)
			end

			if VehParts <= 1 then
				VehSelected = "engine"
			elseif VehParts == 2 then
				VehSelected = "transmission"
			elseif VehParts == 3 then
				VehSelected = "brake"
			end

			if VehRandom <= 10 then
				vRP.GenerateItem(Passport,VehSelected.."e",1,true)
			elseif VehRandom >= 10 and VehRandom <= 30 then
				vRP.GenerateItem(Passport,VehSelected.."d",1,true)
			elseif VehRandom >= 31 and VehRandom <= 60 then
				vRP.GenerateItem(Passport,VehSelected.."c",1,true)
			elseif VehRandom >= 61 and VehRandom <= 100 then
				vRP.GenerateItem(Passport,VehSelected.."b",1,true)
			elseif VehRandom >= 101 and VehRandom <= 150 then
				vRP.GenerateItem(Passport,VehSelected.."a",1,true)
			end

			vRP.GenerateItem(Passport,"plastic",AmountItens,true)
			vRP.GenerateItem(Passport,"glass",AmountItens,true)
			vRP.GenerateItem(Passport,"rubber",AmountItens,true)
			vRP.GenerateItem(Passport,"copper",AmountItens,true)
			vRP.GenerateItem(Passport,"aluminum",AmountItens,true)
			vRP.PutExperience(Passport,"Tows",1)

			TriggerClientEvent("garages:Delete",source,entity[3])
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Impound")
AddEventHandler("police:Impound",function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Impound[entity[2].."-"..entity[1]] then
			Impound[entity[2].."-"..entity[1]] = true
			TriggerEvent("towdriver:Call",source,entity[2],entity[1])
			vRPC.PlaySound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"Aviso","Veículo foi registrado.","verde",5000)

			if string.sub(entity[1],1,4) == "DISM" then
				local VehParts = math.random(4)
				local VehSelected = "suspension"
				local VehRandom = math.random(4500)
				local AmountItens = math.random(4,5)

				if VehParts <= 1 then
					VehSelected = "engine"
				elseif VehParts == 2 then
					VehSelected = "transmission"
				elseif VehParts == 3 then
					VehSelected = "brake"
				end

				if VehRandom <= 10 then
					vRP.GenerateItem(Passport,VehSelected.."e",1,true)
				elseif VehRandom >= 10 and VehRandom <= 30 then
					vRP.GenerateItem(Passport,VehSelected.."d",1,true)
				elseif VehRandom >= 31 and VehRandom <= 60 then
					vRP.GenerateItem(Passport,VehSelected.."c",1,true)
				elseif VehRandom >= 61 and VehRandom <= 100 then
					vRP.GenerateItem(Passport,VehSelected.."b",1,true)
				elseif VehRandom >= 101 and VehRandom <= 150 then
					vRP.GenerateItem(Passport,VehSelected.."a",1,true)
				end

				vRP.GenerateItem(Passport,"plastic",AmountItens,true)
				vRP.GenerateItem(Passport,"glass",AmountItens,true)
				vRP.GenerateItem(Passport,"rubber",AmountItens,true)
				vRP.GenerateItem(Passport,"copper",AmountItens,true)
				vRP.GenerateItem(Passport,"aluminum",AmountItens,true)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Veículo já está na lista.","amarelo",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATENAME
-----------------------------------------------------------------------------------------------------------------------------------------
local plateName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local plateLastname = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
local plateSave = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Plate")
AddEventHandler("police:Plate",function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		runPlate(source,entity[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("placa",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,"Policia") and Message[1] then
			runPlate(source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUNPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function runPlate(source,Plate)
	local Passport = vRP.PassportPlate(Plate)
	if Passport then
		local Identity = vRP.Identity(Passport["Passport"])
		vRPC.PlaySound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,false,"<b>Passaporte:</b> "..Identity["id"].."<br><b>Nome:</b> "..Identity["name"].." "..Identity["name2"].."<br><b>Nº:</b> "..Identity["phone"],"azul",10000)
	else
		if not plateSave[Plate] then
			plateSave[Plate] = { plateName[math.random(#plateName)].." "..plateLastname[math.random(#plateLastname)],vRP.GeneratePhone() }
		end

		vRPC.PlaySound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,false,"<b>Passaporte:</b> 9.999<br><b>Nome:</b> "..plateSave[Plate][1].."<br><b>Nº:</b> "..plateSave[Plate][2],"azul",10000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARREST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Arrest")
AddEventHandler("police:Arrest",function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.Request(source,"Apreender o veículo?","Sim, concluír apreensão","Não, mudei de ideia") then
			local Passport = vRP.PassportPlate(entity[1])
			if Passport then
				local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport["Passport"], vehicle = entity[2] })
				if Vehicle[1] then
					if Vehicle[1]["arrest"] <= os.time() then
						vRP.Query("vehicles/arrestVehicles",{ Passport = Passport["Passport"], vehicle = entity[2] })
						TriggerClientEvent("Notify",source,"Aviso","Veículo apreendido.","verde",5000)
					else
						TriggerClientEvent("Notify",source,"Aviso","Veículo já se encontra apreendido.","amarelo",5000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)