-----------------------------------------------------------------------------------------------------------------------------------------
-- FALSEIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.FalseIdentity(Passport)
	local identity = vRP.Query("fidentity/Result",{ id = Passport })
	return identity[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identity(Passport)
	if vRP.UserSources[Passport] then
		if vRP.UserInfos[Passport] == nil then
			local identity = vRP.Query("characters/Person",{ id = Passport })

			vRP.UserInfos[Passport] = {}
			vRP.UserInfos[Passport]["id"] = identity[1]["id"]
			vRP.UserInfos[Passport]["steam"] = identity[1]["steam"]
			vRP.UserInfos[Passport]["phone"] = identity[1]["phone"]
			vRP.UserInfos[Passport]["serial"] = identity[1]["serial"]
			vRP.UserInfos[Passport]["name"] = identity[1]["name"]
			vRP.UserInfos[Passport]["name2"] = identity[1]["name2"]
			vRP.UserInfos[Passport]["locate"] = identity[1]["locate"]
			vRP.UserInfos[Passport]["sex"] = identity[1]["sex"]
			vRP.UserInfos[Passport]["blood"] = identity[1]["blood"]
			vRP.UserInfos[Passport]["fines"] = identity[1]["fines"]
			vRP.UserInfos[Passport]["prison"] = identity[1]["prison"]
			vRP.UserInfos[Passport]["port"] = identity[1]["port"]
			vRP.UserInfos[Passport]["criminal"] = identity[1]["criminal"]
			vRP.UserInfos[Passport]["driverlicense"] = identity[1]["driverlicense"]
			vRP.UserInfos[Passport]["newbie"] = identity[1]["newbie"]
			vRP.UserInfos[Passport]["deleted"] = identity[1]["deleted"]
		end

		return vRP.UserInfos[Passport]
	else
		local identity = vRP.Query("characters/Person",{ id = Passport })
		return identity[1] or false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InitPrison(Passport,amount)
	vRP.Query("characters/setPrison",{ Passport = Passport, prison = parseInt(amount) })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["prison"] = parseInt(amount)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdatePrison(Passport)
	vRP.Query("characters/removePrison",{ Passport = Passport, prison = 1 })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["prison"] = vRP.UserInfos[Passport]["prison"] - math.random(2)

		if vRP.UserInfos[Passport]["prison"] < 0 then
			vRP.UserInfos[Passport]["prison"] = 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradePort(Passport,Status)
	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["port"] = parseInt(Status)
	end

	vRP.Query("characters/updatePort",{ port = Status, id = Passport })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCRIMINAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetCriminal(Passport)
	local Passport = parseInt(Passport)
	if vRP.UserInfos[Passport] then
		return vRP.UserInfos[Passport]["criminal"]
	else
		local Identity = vRP.Identity(Passport)
		if Identity then
			return Identity["criminal"]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADECRIMINAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeCriminal(Passport,Status)
	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["criminal"] = parseInt(Status)
	end

	vRP.Query("characters/updateCriminal",{ criminal = Status, id = Passport })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDRIVERLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetDriverLicense(Passport)
	local Passport = parseInt(Passport)
	if vRP.UserInfos[Passport] then
		return vRP.UserInfos[Passport]["driverlicense"]
	else
		local Identity = vRP.Identity(Passport)
		if Identity then
			return Identity["driverlicense"]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEDRIVERLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeDriverLicense(Passport,Status)
	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["driverlicense"] = parseInt(Status)
	end

	vRP.Query("characters/updateDriverlicense",{ driverlicense = Status, id = Passport })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADELOCATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeLocate(Passport,Locate)
	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["locate"] = Locate
	end

	vRP.Query("characters/updateLocate",{  id = Passport, locate = Locate })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADECHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeChars(Passport)
	vRP.Query("accounts/infosUpdatechars",{ steam = vRP.UserInfos[Passport]["steam"] })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["chars"] = vRP.UserInfos[Passport]["chars"] + 1
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserGemstone(steam)
	local infoAccount = vRP.Account(steam)
	return infoAccount["gems"] or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeGemstone(Passport,amount)
	vRP.Query("accounts/AddGems",{ steam = vRP.UserInfos[Passport]["steam"], gems = amount })
	TriggerClientEvent("hud:AddGemstone",vRP.UserSources[Passport],amount)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADENAMES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeNames(Passport,name,name2)
	vRP.Query("characters/updateName",{ name = name, name2 = name2, id = Passport })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["name2"] = name2
		vRP.UserInfos[Passport]["name"] = name
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradePhone(Passport,phone)
	vRP.Query("characters/updatePhone",{ phone = phone, id = Passport })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["phone"] = phone
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PassportPlate(Plate)
	local rows = vRP.Query("vehicles/plateVehicles",{ plate = Plate })
	return rows[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERBLOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserBlood(Sanguine)
	local rows = vRP.Query("characters/getBlood",{ blood = Sanguine })
	if rows[1] then
		return rows[1]["id"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserPhone(phoneNumber)
	local rows = vRP.Query("characters/getPhone",{ phone = phoneNumber })
	return rows[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESTRINGNUMBER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateString(format)
	local abyte = string.byte("A")
	local zbyte = string.byte("0")
	local number = ""

	for i = 1,#format do
		local char = string.sub(format,i,i)
    	if char == "D" then
    		number = number..string.char(zbyte + math.random(0,9))
		elseif char == "L" then
			number = number..string.char(abyte + math.random(0,25))
		else
			number = number..char
		end
	end

	return number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GeneratePlate()
	local Passport = nil
	local Plate = ""

	repeat
		Plate = vRP.GenerateString("DDLLLDDD")
		Passport = vRP.PassportPlate(Plate)
	until not Passport

	return Plate
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GeneratePhone()
	local Passport = nil
	local phone = ""

	repeat
		phone = vRP.GenerateString("DDD-DDD")
		Passport = vRP.UserPhone(phone)
	until not Passport

	return phone
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSERIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserSerial(number)
	local rows = vRP.Query("characters/getSerial",{ serial = number })
	return rows[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEBLOODTYPES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateBloodTypes(format)
	local zbyte = string.byte("0")
	local number = ""

	for i = 1,#format do
		local char = string.sub(format,i,i)
    	if char == "D" then
    		number = number..string.char(zbyte + math.random(1,4))
		else
			number = number..char
		end
	end

	return number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEBLOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateBlood()
	local Passport = nil
	local blood = ""

	repeat
		blood = vRP.GenerateBloodTypes("D")
		Passport = vRP.UserBlood(blood)
	until not Passport

	return blood
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESERIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateSerial()
	local Passport = nil
	local serial = ""

	repeat
		serial = vRP.GenerateString("LLLDDD")
		Passport = vRP.UserSerial(serial)
	until not Passport

	return serial
end