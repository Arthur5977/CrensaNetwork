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
Tunnel.bindInterface("tattoos",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckWanted()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport,source) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKET
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bucket(Status)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Status then
			Player(source)["state"]["Route"] = Passport
			SetPlayerRoutingBucket(source,Passport)
		else
			Player(source)["state"]["Route"] = 0
			SetPlayerRoutingBucket(source,0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETATTOO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateTattoo(Tattoos)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Tables = json.encode(Tattoos)
		if Tables ~= "[]" then
			vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Tatuagens", dvalue = Tables })
		end
	end
end