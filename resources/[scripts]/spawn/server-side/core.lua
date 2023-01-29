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
Tunnel.bindInterface("spawn",Creative)
vCLIENT = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Selected = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.initSystem()
	local source = source
	local CharacterList = {}
	local Steam = vRP.Identities(source)
	local consult = vRP.Query("characters/Characters",{ steam = Steam })

	Player(source)["state"]["Route"] = 999999
	SetPlayerRoutingBucket(source,999999)

	if consult[1] then
		for k,v in pairs(consult) do
			local Identity = vRP.Identity(v["id"])
			table.insert(CharacterList,{ Passport = v["id"], Nome = v["name"].." "..v["name2"], Sexo = v["sex"], Local = v["locate"], Sangue = Sanguine(Identity["blood"]) })
		end
	end

	return CharacterList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Characters()
	local source = source
	local Character = {}
	local Steam = vRP.Identities(source)
	local consult = vRP.Query("characters/Characters",{ steam = Steam })

	SetPlayerRoutingBucket(source,source)

	if consult[1] then
		for k,v in pairs(consult) do
			local userTablesSkin = vRP.UserData(v["id"],"Datatable")
			local userTablesBarber = vRP.UserData(v["id"],"Barbershop")
			local userTablesClotings = vRP.UserData(v["id"],"Clothings")
			local userTablesTatto = vRP.UserData(v["id"],"Tatuagens")
			
			table.insert(Character,{ Skin = userTablesSkin["skin"], Barber = userTablesBarber, Clothes = userTablesClotings, Tattoos = userTablesTatto })
		end
	end

	return Character
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.characterChosen(Passport)
	local source = source
	local Steam = vRP.Identities(source)
	local Consult = vRP.Query("characters/UserSteam",{ id = Passport, steam = Steam })
	if Consult[1] then
		SetPlayerRoutingBucket(source,0)
		Player(source)["state"]["Route"] = 0
		vRP.CharacterChosen(source,Passport,nil)
	else
		DropPlayer(source,"Conectando em personagem irregular.")
		TriggerEvent("Discord","Hackers","A Steam **"..Steam.."** conectou em outra conta.",3092790)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.newCharacter(name,name2,sex,locate)
	local source = source
	if Selected[source] == nil then
		Selected[source] = true

		local Steam = vRP.Identities(source)
		local Account = vRP.Account(Steam)
		local amountCharacters = parseInt(Account["chars"])
		local myChars = vRP.Query("characters/countPersons",{ steam = Steam })

		if vRP.LicensePremium(Steam) then
			amountCharacters = amountCharacters + 2
		end

		if parseInt(amountCharacters) <= parseInt(myChars[1]["qtd"]) then
			TriggerClientEvent("Notify",source,"Atenção","Limite de personagens atingido.","amarelo",3000)
			Selected[source] = nil
			return
		end

		if sex == "mp_m_freemode_01" then
			vRP.Query("characters/newCharacter",{ steam = Steam, name = name, name2 = name2, locate = locate, sex = "M", phone = vRP.GeneratePhone(), serial = vRP.GenerateSerial(), blood = math.random(4) })
		else
			vRP.Query("characters/newCharacter",{ steam = Steam, name = name, name2 = name2, locate = locate, sex = "F", phone = vRP.GeneratePhone(), serial = vRP.GenerateSerial(), blood = math.random(4) })
		end

		local consult = vRP.Query("characters/lastCharacters",{ steam = Steam })
		if consult[1] then
			vRP.Query("bank/newAccount",{ Passport = consult[1]["id"], dvalue = 2000, mode = "Private", owner = 1 })
			vRP.CharacterChosen(source,consult[1]["id"],sex,locate)
			vCLIENT.closeNew(source)

			Player(source)["state"]["Route"] = 0
			SetPlayerRoutingBucket(source,0)
		end

		Selected[source] = nil
	end
end