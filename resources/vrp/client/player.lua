-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.ModelExist(mHash)
	return IsModelInCdimage(mHash)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.SetHealth(Health)
	local Ped = PlayerPedId()
	SetEntityHealth(Ped,Health)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.UpgradeHealth(Number)
	local Ped = PlayerPedId()
	local Health = GetEntityHealth(Ped)
	if Health > 100 then
		SetEntityHealth(Ped,Health + Number)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.DowngradeHealth(Number)
	local Ped = PlayerPedId()
	local Health = GetEntityHealth(Ped)

	SetEntityHealth(Ped,Health - Number)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Skin(mHash)
	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end
	
	local Pid = PlayerId()
	local Ped = PlayerPedId()
	if HasModelLoaded(mHash) then
		SetPlayerModel(Pid,mHash)
		SetPedComponentVariation(Ped,5,0,0,1)
		SetModelAsNoLongerNeeded(mHash)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETENTITYCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.GetEntityCoords()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,GroundZ = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

	return {
		["x"] = Coords["x"],
		["y"] = Coords["y"],
		["z"] = GroundZ
	}
end