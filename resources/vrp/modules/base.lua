-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.userIds = {}
vRP.UserInfos = {}
vRP.userTables = {}
vRP.UserSources = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYSQL
-----------------------------------------------------------------------------------------------------------------------------------------
local prepared_queries = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Prepare(Name,Query)
    prepared_queries[Name] = Query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Query(Name,Params)
    return exports.oxmysql:query_async(prepared_queries[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identities(source)
	local Result = false

	local Identifiers = GetPlayerIdentifiers(source)
	for _,v in pairs(Identifiers) do
		if string.find(v,"steam") then
			local splitName = splitString(v,":")
			Result = splitName[2]
			break
		end
	end

	return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(Archive,Text)
	Archive = io.open("resources/"..Archive,"a")
	if Archive then
		archive:write(Text.."\n")
	end

	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Banned(Steam)
	local Consult = vRP.Query("banneds/GetBanned",{ steam = Steam })
	if Consult[1] then
		if Consult[1]["time"] <= os.time() then
			vRP.Query("banneds/RemoveBanned",{ steam = Steam })
			return false
		end

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTOKEN
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckToken(source,steam)
    local Token = GetPlayerTokens(source)
    for k,v in pairs(Token) do
		local Consult = vRP.Query("banneds/GetToken",{ token = v })
        if Consult[1] then
            return false
        end

		vRP.Query("banneds/InsertToken",{ token = v, steam = steam })
    end

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Account(Steam)
	local infoAccount = vRP.Query("accounts/getInfos",{ steam = Steam })
	return infoAccount[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserData(Passport,Key)
	local consult = vRP.Query("playerdata/GetData",{ Passport = Passport, dkey = Key })
	if consult[1] then
		return json.decode(consult[1]["dvalue"])
	else
		return {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsidePropertys(Passport,Coords)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		Datatable["position"] = { x = Coords[1], y = Coords[2], z = Coords[3] }
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Inventory(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		if Datatable["inventory"] == nil then
			Datatable["inventory"] = {}
		end

		return Datatable["inventory"]
	end

	return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SkinCharacter(Passport,Hash)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		Datatable["skin"] = Hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Passport(source)
	return vRP.userIds[parseInt(source)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Players()
	return vRP.UserSources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userPlayers()
	return vRP.userIds
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Source(Passport)
	return vRP.UserSources[parseInt(Passport)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Datatable(Passport)
	return vRP.userTables[parseInt(Passport)] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(reason)
	playerDropped(source,reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Kick(Passport,reason)
	local userSource = vRP.Source(Passport)
	if userSource then
		playerDropped(userSource,"Kick/Afk")
		DropPlayer(userSource,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
function playerDropped(source,reason)
	local source = parseInt(source)
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("Discord","Disconnect","**Source:** "..parseFormat(source).."\n**Passaporte:** "..parseFormat(Passport).."\n**Motivo:** "..reason.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)

		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)

			Datatable["armour"] = GetPedArmour(Ped)
			Datatable["health"] = GetEntityHealth(Ped)
			Datatable["position"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }

			TriggerEvent("Disconnect",Passport,source)
			vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Datatable", dvalue = json.encode(Datatable) })
			vRP.UserSources[Passport] = nil
			vRP.userTables[Passport] = nil
			vRP.UserInfos[Passport] = nil
			vRP.userIds[source] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:Connecting",function(source,identifiers,deferrals)
	local Steam = vRP.Identities(source)
	if Steam then
		if Maintenance then
			if MaintenanceLicenses[vRP.Identities(source)] then
				deferrals.done()
			else
				deferrals.done(MaintenanceText)
			end
		elseif not vRP.Banned(Steam) then
			local infoAccount = vRP.Account(Steam)
			if infoAccount then
				if infoAccount["whitelist"] then
					deferrals.done()
				else
					deferrals.done(ReleaseText..": "..Steam)
				end
			else
				vRP.Query("accounts/newAccount",{ steam = Steam })
				deferrals.done(ReleaseText..": "..Steam)
			end
		else
			CheckToken(Steam)
			deferrals.done(BannedText)
		end
	else
		deferrals.done("Conexão perdida com a Steam.")
	end

	TriggerEvent("Queue:Remove",identifiers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CharacterChosen(source,Passport,model,locate)
	vRP.userIds[source] = Passport
	vRP.UserSources[Passport] = source
	local Identity = vRP.Identity(Passport)
	vRP.userTables[Passport] = vRP.UserData(Passport,"Datatable")

	if model ~= nil then
		vRP.userTables[Passport]["inventory"] = {}

		for k, v in pairs(CharacterItens) do
			vRP.GenerateItem(Passport,k,v,false)
		end

		vRP.GenerateItem(Passport,"identity-"..Passport,1,false)

		vRP.userTables[Passport]["skin"] = GetHashKey(model)

		if locate == "Sul" then
			vRP.userTables[Passport]["position"] = { x = -28.08, y = -145.96, z = 56.99 }
		else
			vRP.userTables[Passport]["position"] = { x = 1935.59, y = 3721.93, z = 32.87 }
		end
	end

	local userBank = vRP.UserBank(Passport,"Private")
	if userBank then
		vRP.UserInfos[Passport]["bank"] = userBank["dvalue"]
	end

	local infoAccount = vRP.Account(Identity["steam"])
	if infoAccount then
		vRP.UserInfos[Passport]["premium"] = infoAccount["premium"]
		vRP.UserInfos[Passport]["chars"] = infoAccount["chars"]

		TriggerClientEvent("hud:AddGemstone",source,infoAccount["gems"])

		TriggerEvent("Discord","Connect","**Source:** "..parseFormat(source).."\n**Passaporte:** "..parseFormat(Passport).."\n**Ip:** "..GetPlayerEndpoint(source).."\n**Horário:** "..os.date("%H:%M:%S"),3092790)

		PerformHttpRequest(Discords[Login],function(err,text,headers) end,"POST",json.encode({ content = infoAccount["discord"].." #"..Passport.." "..Identity["name"] }),{ ["Content-Type"] = "application/json" })
	end

	local Identities = vRP.Identities(source)
	if Identities ~= Identity["steam"] then
		vRP.Kick(Passport,"Expulso da cidade.")
	end

	TriggerEvent("Connect",Passport,source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetGameType(ServerName)
	SetMapName(ServerName)
	SetRoutingBucketEntityLockdownMode(0,"relaxed")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:PRINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:Print")
AddEventHandler("vRP:Print",function(message)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("Discord","Hackers","Passaporte **"..Passport.."** "..message..".",3092790)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
	if "vrp" == Resource then
		print("Servidor autenticado com sucesso.")
	end
end)