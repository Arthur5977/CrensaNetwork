-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local weed = {}
local alcohol = {}
local chemical = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEEDRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weedReturn(Passport)
	if weed[Passport] then
		if os.time() < weed[Passport] then
			return parseInt(weed[Passport] - os.time())
		else
			weed[Passport] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEEDTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weedTimer(Passport,timeSet)
	if weed[Passport] then
		weed[Passport] = weed[Passport] + (timeSet * 60)
	else
		weed[Passport] = os.time() + (timeSet * 60)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.chemicalReturn(Passport)
	if chemical[Passport] then
		if os.time() < chemical[Passport] then
			return parseInt(chemical[Passport] - os.time())
		else
			chemical[Passport] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.chemicalTimer(Passport,timeSet)
	if chemical[Passport] then
		chemical[Passport] = chemical[Passport] + (timeSet * 60)
	else
		chemical[Passport] = os.time() + (timeSet * 60)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALCOHOLRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.alcoholReturn(Passport)
	if alcohol[Passport] then
		if os.time() < alcohol[Passport] then
			return parseInt(alcohol[Passport] - os.time())
		else
			alcohol[Passport] = nil
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEMICALTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.alcoholTimer(Passport,timeSet)
	if alcohol[Passport] then
		alcohol[Passport] = alcohol[Passport] + (timeSet * 60)
	else
		alcohol[Passport] = os.time() + (timeSet * 60)
	end
end