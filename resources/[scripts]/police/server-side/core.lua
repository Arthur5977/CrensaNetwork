-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("police",Creative)
vCLIENT = Tunnel.getInterface("police")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Reduces = {}
local Actived = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.initPrison(OtherPassport,services,fines,text)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Actived[Passport] == nil then
			Actived[Passport] = true

			local identity = vRP.Identity(Passport)
			if identity then
				local otherPlayer = vRP.Source(OtherPassport)
				if otherPlayer then
					vCLIENT.Sync(otherPlayer,true,true)
					TriggerClientEvent("radio:outServers",otherPlayer)
				end

				vRP.Query("prison/insertPrison",{ police = identity["name"].." "..identity["name2"], OtherPassport = parseInt(OtherPassport), services = services, fines = fines, text = text, date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M") })
				vRPC.PlaySound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("Notify",source,"Aviso","Prisão efetuada.","verde",5000)
				TriggerClientEvent("police:Update",source,"reloadPrison")
				vRP.InitPrison(OtherPassport,services)

				if fines > 0 then
					vRP.GiveFine(OtherPassport,fines)
				end

				TriggerEvent("Discord","Prison","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(OtherPassport).."\n**Serviços:** "..parseFormat(services).."\n**Multa:** $"..parseFormat(fines).."\n**Horário:** "..os.date("%H:%M:%S").."\n**Motivo:** "..text,13541152)
			end

			Actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local Preset = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 145, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 395, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 83, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 152, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 14, texture = 0 },
		["torso"] = { item = 418, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 86, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Preset")
AddEventHandler("police:Preset",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local mHash = vRP.ModelPlayer(Entity[1])
		if mHash == "mp_m_freemode_01" or mHash == "mp_f_freemode_01" then
			TriggerClientEvent("updateRoupas",Entity[1],Preset[mHash])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.searchUser(OtherPassport)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = parseInt(OtherPassport)
		local identity = vRP.Identity(OtherPassport)
		if identity then
			local fines = vRP.GetFine(OtherPassport)
			local records = vRP.Query("prison/getRecords",{ OtherPassport = parseInt(OtherPassport) })

			return { true,identity["name"].." "..identity["name2"],identity["phone"],fines,records,identity["port"],identity["criminal"] }
		end
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.initFine(OtherPassport,fines,text)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and fines > 0 then
		if Actived[Passport] == nil then
			Actived[Passport] = true

			TriggerEvent("Discord","Prison","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(OtherPassport).."\n**Multa:** $"..parseFormat(fines).."\n**Horário:** "..os.date("%H:%M:%S").."\n**Motivo:** "..text,2316674)
			TriggerClientEvent("Notify",source,"Aviso","Multa aplicada.","verde",5000)
			TriggerClientEvent("police:Update",source,"reloadFine")
			vRP.GiveFine(OtherPassport,fines)

			Actived[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updatePort(OtherPassport)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local portStatus = "Desativado"
		local OtherPassport = parseInt(OtherPassport)
		local identity = vRP.Identity(OtherPassport)

		if parseInt(identity["port"]) == 0 then
			portStatus = "Ativado"
			vRP.UpgradePort(OtherPassport,1)
		else
			vRP.UpgradePort(OtherPassport,0)
		end

		TriggerClientEvent("police:Update",source,"reloadSearch",parseInt(OtherPassport))
		TriggerEvent("Discord","Prison","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(OtherPassport).."\n**Porte:** "..portStatus.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECRIMINAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateCriminal(OtherPassport)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local criminalStatus = "Regular"
		local OtherPassport = parseInt(OtherPassport)
		local identity = vRP.Identity(OtherPassport)

		if parseInt(identity["criminal"]) == 0 then
			criminalStatus = "Irregular"
			vRP.UpgradeCriminal(OtherPassport,1)
		else
			vRP.UpgradeCriminal(OtherPassport,0)
		end

		TriggerClientEvent("police:Update",source,"reloadSearch",parseInt(OtherPassport))
		TriggerEvent("Discord","Prison","**Por:** "..parseFormat(Passport).."\n**Passaporte:** "..parseFormat(OtherPassport).."\n**Criminal:** "..criminalStatus.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:REDUCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Reduces")
AddEventHandler("police:Reduces",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		if parseInt(Identity["prison"]) > 0 then
			if not Reduces[Number] then
				Reduces[Number] = {}
			end

			if Reduces[Number][Passport] then
				if os.time() > Reduces[Number][Passport] then
					reduceFunction(source,Passport,Number)
				else
					TriggerClientEvent("Notify",source,"Aviso","Nada encontrado.","amarelo",5000)
				end
			else
				reduceFunction(source,Passport,Number)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCEFUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function reduceFunction(source,Passport,Number)
	vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)
	TriggerClientEvent("Progress",source,"Vasculhando",10000)
	Reduces[Number][Passport] = os.time() + 600
	Player(source)["state"]["Buttons"] = true
	Player(source)["state"]["Cancel"] = true
	local timeProgress = 10

	repeat
		Wait(1000)
		timeProgress = timeProgress - 1
	until timeProgress <= 0

	vRP.UpdatePrison(Passport,source,math.random(2))
	Player(source)["state"]["Buttons"] = false
	Player(source)["state"]["Cancel"] = false
	vRPC.Destroy(source)

	local Identity = vRP.Identity(Passport)
	if parseInt(Identity["prison"]) > 0 then
		TriggerClientEvent("Notify",source,false,"Restam <b>"..parseInt(Identity["prison"]).." serviços</b>.","azul",5000)
	else
		vCLIENT.Sync(source,false,true)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Identity = vRP.Identity(Passport)
	if parseInt(Identity["prison"]) > 0 then
		TriggerClientEvent("Notify",source,false,"Restam <b>"..parseInt(Identity["prison"]).." serviços</b>.","azul",5000)
		vCLIENT.Sync(source,true,false)
	end

	if Actived[Passport] == true then
		Actived[Passport] = nil
	end
end)