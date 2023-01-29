-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPremium(Passport)
	vRP.Query("accounts/SetPremium",{ steam = vRP.UserInfos[Passport]["steam"], premium = os.time() + 2592000, priority = 50 })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["premium"] = parseInt(os.time() + 2592000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradePremium(Passport)
	vRP.Query("accounts/updatePremium",{ steam = vRP.UserInfos[Passport]["steam"] })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["premium"] = vRP.UserInfos[Passport]["premium"] + 2592000
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserPremium(Passport)
	if vRP.UserInfos[Passport] then
		if vRP.UserInfos[Passport]["premium"] >= os.time() then
			return true
		end
	else
		local identity = vRP.Query("characters/Person",{ id = Passport })
		if identity[1] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEAMPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.LicensePremium(steam)
	local infoAccount = vRP.Account(steam)
	if infoAccount and infoAccount["premium"] >= os.time() then
		return true
	end

	return false
end