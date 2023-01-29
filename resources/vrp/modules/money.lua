-----------------------------------------------------------------------------------------------------------------------------------------
-- USERBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserBank(Passport,Mode)
	local Passport = parseInt(Passport)
	local bankInfos = vRP.Query("bank/getInfos",{ Passport = Passport, mode = Mode })
	return bankInfos[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetBank(Source)
	local Passport = parseInt(vRP.Passport(Source))
	if vRP.UserInfos[Passport] then
		return vRP.UserInfos[Passport]["bank"]
	else
		local Identity = vRP.Identity(Passport)
		if Identity then
			return Identity["bank"]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveBank(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		vRP.Query("bank/addValue",{ Passport = Passport, dvalue = Amount, mode = "Private" })

		if vRP.UserInfos[Passport] then
			vRP.UserInfos[Passport]["bank"] = vRP.UserInfos[Passport]["bank"] + Amount

			local Source = vRP.Source(Passport)
			if Source then
				TriggerClientEvent("itensNotify",Source,{ "recebeu","dollars",parseFormat(Amount),"Dólares" })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveBank(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		vRP.Query("bank/remValue",{ Passport = Passport, dvalue = Amount, mode = "Private" })

		if vRP.UserInfos[Passport] then
			vRP.UserInfos[Passport]["bank"] = vRP.UserInfos[Passport]["bank"] - Amount

			if vRP.UserInfos[Passport]["bank"] < 0 then
				vRP.UserInfos[Passport]["bank"] = 0
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetFine(Passport)
	local Passport = parseInt(Passport)
	if vRP.UserInfos[Passport] then
		return vRP.UserInfos[Passport]["fines"]
	else
		local Identity = vRP.Identity(Passport)
		if Identity then
			return Identity["fines"]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveFine(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		vRP.Query("characters/addFines",{ id = Passport, fines = Amount })

		if vRP.UserInfos[Passport] then
			vRP.UserInfos[Passport]["fines"] = vRP.UserInfos[Passport]["fines"] + Amount
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveFine(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		vRP.Query("characters/removeFines",{ id = Passport, fines = Amount })

		if vRP.UserInfos[Passport] then
			vRP.UserInfos[Passport]["fines"] = vRP.UserInfos[Passport]["fines"] - Amount

			if vRP.UserInfos[Passport]["fines"] < 0 then
				vRP.UserInfos[Passport]["fines"] = 0
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentGems(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if vRP.UserInfos[Passport] then
			if vRP.UserGemstone(vRP.UserInfos[Passport]["steam"]) >= Amount then
				vRP.Query("accounts/removeGems",{ steam = vRP.UserInfos[Passport]["steam"], gems = Amount })

				local Source = vRP.Source(Passport)
				if Source then
					TriggerClientEvent("hud:RemoveGemstone",Source,Amount)
				end

				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentBank(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Value = parseInt(Amount)
		local Passport = parseInt(Passport)
		if Passport then
			local Source = vRP.Source(Passport)
			if Source then
				if vRP.ConsultItem(Passport,"bankcard",1) then
					if vRP.UserInfos[Passport] then
						if vRP.UserInfos[Passport]["bank"] >= Value then
							vRP.RemoveBank(Passport,Value)
							TriggerClientEvent("itensNotify",Source,{ "pagou","dollars",Value,"Dólares" })
							return true
						else
							TriggerClientEvent("Notify",Source,"Atenção","<b>Saldo no Banco<b> insuficiente.","amarelo",5000)
						end
					end
				else
					TriggerClientEvent("Notify",Source,"Atenção","Você precisa de <b>1x "..itemName("bankcard").."<b>.","amarelo",5000)
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentFull(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if Passport then
			local Source = vRP.Source(Passport)
			if Source then
				if vRP.ConsultItem(Passport,"bankcard",1) then
					if vRP.UserInfos[Passport] then
						if vRP.UserInfos[Passport]["bank"] >= Amount then
							vRP.RemoveBank(Passport,Amount)
							TriggerClientEvent("itensNotify",Source,{ "pagou","dollars",Amount,"Dólares" })
							return true
						else
							TriggerClientEvent("Notify",Source,"Atenção","<b>Saldo no Banco<b> insuficiente.","amarelo",5000)
						end
					end
				else
					if vRP.TakeItem(Passport,"dollars",Amount,true) then
						return true
					else
						TriggerClientEvent("Notify",Source,"Atenção","<b>Dólares em Mãos<b> insuficientes.","amarelo",5000)
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.WithdrawCash(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if vRP.UserInfos[Passport]["bank"] >= Amount then
			vRP.GenerateItem(Passport,"dollars",Amount,true)
			vRP.RemoveBank(Passport,Amount)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANKMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBankMoney(Passport,Amount)
	local Dif = Amount - vRP.GetBank(Passport)
	vRP.Query("bank/addValue",{ Passport = Passport, dvalue = Dif, mode = "Private" })

	if vRP.UserInfos[Passport] then
		vRP.UserInfos[Passport]["bank"] = Amount
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OTHERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.getBankMoney = vRP.GetBank
vRP.giveBankMoney = vRP.GiveBank
vRP.removeBankMoney = vRP.RemoveBank