-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetMedicPlan(Passport)
	vRP.Query("accounts/SetMedicPlan",{ steam = vRP.UserInfos[Passport]["steam"], medicplan = os.time() + 2592000 })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["medicplan"] = parseInt(os.time() + 2592000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeMedicPlan(Passport)
	vRP.Query("accounts/updateMedicPlan",{ steam = vRP.UserInfos[Passport]["steam"] })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["medicplan"] = vRP.UserInfos[Passport]["medicplan"] + 2592000
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserMedicPlan(Passport)
	if vRP.UserInfos[Passport] then
		if vRP.UserInfos[Passport]["medicplan"] >= os.time() then
			return true
		end
	else
		local Identity = vRP.Query("characters/Person",{ id = Passport })
		if Identity[1] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LICENSEMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.LicenseMedicPlan(steam)
	local Info = vRP.Account(steam)
	if Info and Info["medicplan"] >= os.time() then
		return true
	end

	return false
end