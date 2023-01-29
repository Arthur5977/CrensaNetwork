local experienceList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PutExperience(Passport,experience,amount)
	local Passport = parseInt(Passport)

	if experienceList[Passport][experience] == nil then
		experienceList[Passport][experience] = 0
	end

	experienceList[Passport][experience] = experienceList[Passport][experience] + amount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetExperience(Passport,experience)
	local Passport = parseInt(Passport)

	if experienceList[Passport][experience] == nil then
		experienceList[Passport][experience] = 0
	end

	return parseInt(experienceList[Passport][experience])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	experienceList[Passport] = vRP.UserData(Passport,"Experience")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if experienceList[Passport] then
		vRP.Query("playerdata/SetData",{ Passport = parseInt(Passport), dkey = "Experience", dvalue = json.encode(experienceList[Passport]) })
		experienceList[Passport] = nil
	end
end)