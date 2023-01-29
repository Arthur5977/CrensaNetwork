-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("lscustoms")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeBennys = false
local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalPoliceLivery = nil
local originalPlateIndex = nil
local attemptingPurchase = false
local isPurchaseSuccessful = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local bennysLocations = {
	["Ottos01"] = {
		pos = vec3(830.59,-819.99,25.71),
		heading = 87.88,
		permission = "Mecanico"
	},
	["Ottos02"] = {
		pos = vec3(830.58,-812.82,25.71),
		heading = 87.88,
		permission = "Mecanico"
	},
	["Ottos03"] = {
		pos = vec3(830.58,-805.54,25.7),
		heading = 87.88,
		permission = "Mecanico"
	},
	["Sandy01"] = {
		pos = vec3(1174.98,2640.4,37.74),
		heading = 1.0,
		permission = "Mecanico"
	},
	["Sandy02"] = {
		pos = vec3(1182.14,2639.94,37.74),
		heading = 1.0,
		permission = "Mecanico"
	},
	["Paleto01"] = {
		pos = vec3(110.63,6626.54,31.78),
		heading = 224.94,
		permission = "Mecanico"
	},
	["Paleto02"] = {
		pos = vec3(105.26,6621.59,31.78),
		heading = 223.94,
		permission = "Mecanico"
	},
	["Policia01"] = {
		pos = vec3(435.49,-975.99,25.21),
		heading = 87.88,
		permission = "Policia"
	},
	["Policia02"] = {
		pos = vec3(450.24,-975.85,25.21),
		heading = 87.88,
		permission = "Policia"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function saveVehicle()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)
		local vehicleMods = {
			neon = {},
			colors = {},
			extracolors = {},
			dashColour = -1,
			interColour = -1,
			lights = {},
			tint = GetVehicleWindowTint(vehicle),
			wheeltype = GetVehicleWheelType(vehicle),
			platestyle = GetVehicleNumberPlateTextIndex(vehicle),
			mods = {},
			var = {},
			smokecolor = {},
			xenonColor = -1,
			liverys = 24,
			extras = {},
			plateIndex = 0
		}

		vehicleMods["xenonColor"] = GetCurrentXenonColour(vehicle)
		vehicleMods["lights"][1],vehicleMods["lights"][2],vehicleMods["lights"][3] = GetVehicleNeonLightsColour(vehicle)
		vehicleMods["colors"][1],vehicleMods["colors"][2] = GetVehicleColours(vehicle)
		vehicleMods["extracolors"][1],vehicleMods["extracolors"][2] = GetVehicleExtraColours(vehicle)
		vehicleMods["smokecolor"][1],vehicleMods["smokecolor"][2],vehicleMods["smokecolor"][3] = GetVehicleTyreSmokeColor(vehicle)
		vehicleMods["dashColour"] = GetVehicleInteriorColour(vehicle)
		vehicleMods["interColour"] = GetVehicleDashboardColour(vehicle)
		vehicleMods["liverys"] = GetVehicleLivery(vehicle)
		vehicleMods["plateIndex"] = GetVehicleNumberPlateTextIndex(vehicle)

		for i = 0,3 do
			vehicleMods["neon"][i] = IsVehicleNeonLightEnabled(vehicle,i)
		end

		for i = 0,16 do
			vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)
		end

		for i = 17,22 do
			vehicleMods["mods"][i] = IsToggleModOn(vehicle,i)
		end

		for i = 23,48 do
			vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)

			if i == 24 or i == 23 then
				vehicleMods["var"][i] = GetVehicleModVariation(vehicle,i)
			end
		end

		for i = 1,12 do
			local ison = IsVehicleExtraTurnedOn(vehicle,i)
			if 1 == tonumber(ison) then
				vehicleMods["extras"][i] = 1
			else
				vehicleMods["extras"][i] = 0
			end
		end

		TriggerServerEvent("lscustoms:updateVehicle",vehicleMods,GetVehicleNumberPlateText(vehicle),vRP.VehicleName())
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTEMPTPURCHASE
-----------------------------------------------------------------------------------------------------------------------------------------
function AttemptPurchase(type,upgradeLevel)
	if upgradeLevel ~= nil then
		upgradeLevel = upgradeLevel + 2
	end

	TriggerServerEvent("lscustoms:attemptPurchase",type,upgradeLevel)

	attemptingPurchase = true

	while attemptingPurchase do
		Wait(1)
	end

	if not isPurchaseSuccessful then
		PlaySoundFrontend(-1,"ERROR","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
	end

	return isPurchaseSuccessful
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentMod(id)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local mod = GetVehicleMod(vehicle,id)
	local modName = GetLabelText(GetModTextLabel(vehicle,id,mod))

	return mod,modName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWheel()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local wheel = GetVehicleMod(vehicle,23)
	local wheelName = GetLabelText(GetModTextLabel(vehicle,23,wheel))
	local wheelType = GetVehicleWheelType(vehicle)

	return wheel,wheelName,wheelType
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTCHUSTOMWHEELSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentCustomWheelState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local state = GetVehicleModVariation(vehicle,23)

	if state then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalWheel()
	return originalWheel
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalCustomWheel()
	return originalCustomWheels
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWindowTint()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return GetVehicleWindowTint(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTVEHICLEWHEELSMOKECLOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentVehicleWheelSmokeColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local r,g,b = GetVehicleTyreSmokeColor(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonState(id)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsVehicleNeonLightEnabled(vehicle,id)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local r,g,b = GetVehicleNeonLightsColour(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsToggleModOn(vehicle,22)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return GetVehicleHeadlightsColour(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTTURBOSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentTurboState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsToggleModOn(vehicle,18)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTEXTRASTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentExtraState(extra)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return IsVehicleExtraTurnedOn(vehicle,extra)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKVALIDMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckValidMods(category,id,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local tempMod = GetVehicleMod(vehicle,id)
	local tempWheel = GetVehicleMod(vehicle,23)
	local tempWheelType = GetVehicleWheelType(vehicle)
	local tempWheelCustom = GetVehicleModVariation(vehicle,23)
	local amountValidMods = 0
	local validMods = {}
	local hornNames = {}

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,wheelType)
	end

	if id == 14 then
		for k,v in pairs(vehicleCustomisation) do 
			if vehicleCustomisation[k]["category"] == category then
				hornNames = vehicleCustomisation[k]["hornNames"]
				break
			end
		end
	end

	local modAmount = GetNumVehicleMods(vehicle,id)
	for i = 1,modAmount do
		local label = GetModTextLabel(vehicle,id,(i - 1))
		local modName = GetLabelText(label)

		if modName == "NULL" then
			if id == 14 then
				if i <= #hornNames then
					modName = hornNames[i]["name"]
				else
					modName = "Horn "..i
				end
			else
				modName = category.." "..i
			end
		end

		validMods[i] = { id = (i - 1), name = modName }

		amountValidMods = amountValidMods + 1
	end

	if modAmount > 0 then
		table.insert(validMods,1,{ id = -1, name = "Original" })
	end

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,tempWheelType)
		SetVehicleMod(vehicle,23,tempWheel,tempWheelCustom)
	end

	return validMods,amountValidMods
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalMod()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleMod(vehicle,originalCategory,originalMod)
	SetVehicleDoorsShut(vehicle,true)

	originalCategory = nil
	originalMod = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWindowTint()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleWindowTint(vehicle,originalWindowTint)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalColours()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleColours(vehicle,originalPrimaryColour,originalSecondaryColour)
	SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
	SetVehicleDashboardColour(vehicle,originalDashColour)
	SetVehicleInteriorColour(vehicle,originalInterColour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWHEELS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWheels()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	SetVehicleWheelType(vehicle,originalWheelType)

	if originalWheelCategory ~= nil then
		SetVehicleMod(vehicle,originalWheelCategory,originalWheel,originalCustomWheels)
		
		if GetVehicleClass(vehicle) == 8 then
			SetVehicleMod(vehicle,24,originalWheel,originalCustomWheels)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONSTATES
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonStates()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNeonLightEnabled(vehicle,originalNeonLightSide,originalNeonLightState)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonColours()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNeonLightsColour(vehicle,originalNeonColourR,originalNeonColourG,originalNeonColourB)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalXenonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleHeadlightsColour(vehicle,originalXenonColour)
	SetVehicleLights(vehicle,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePoliceLivery()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleLivery(vehicle,originalPoliceLivery)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePlateIndex()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNumberPlateTextIndex(vehicle,originalPlateIndex)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewMod(categoryID,modID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalMod and not originalCategory then
		originalCategory = categoryID
		originalMod = GetVehicleMod(vehicle,categoryID)
	end

	if categoryID == 39 or categoryID == 40 or categoryID == 41 then
		SetVehicleDoorOpen(vehicle,4,false,true)
	elseif categoryID == 37 or categoryID == 38 then
		SetVehicleDoorOpen(vehicle,5,false,true)
	end

	SetVehicleMod(vehicle,categoryID,modID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWindowTint(windowTintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewColour(paintType,paintCategory,paintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	SetVehicleModKit(vehicle,0)

	if not originalDashColour and not originalInterColour and not originalPrimaryColour and not originalSecondaryColour and not originalPearlescentColour and not originalWheelColour then
		originalPrimaryColour,originalSecondaryColour = GetVehicleColours(vehicle)
		originalPearlescentColour,originalWheelColour = GetVehicleExtraColours(vehicle)
		originalDashColour = GetVehicleDashboardColour(vehicle)
		originalInterColour = GetVehicleInteriorColour(vehicle)
	end

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
		else
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,originalPrimaryColour,paintID)
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,originalWheelColour)
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,originalPearlescentColour,paintID)
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWheel(categoryID,wheelID,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	if not originalWheelCategory and not originalWheel and not originalWheelType and not originalCustomWheels then
		originalWheelCategory = categoryID
		originalWheelType = GetVehicleWheelType(vehicle)
		originalWheel = GetVehicleMod(vehicle,23)
		originalCustomWheels = GetVehicleModVariation(vehicle,23)
	end

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeon(side,enabled)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalNeonLightState and not originalNeonLightSide then
		if IsVehicleNeonLightEnabled(vehicle,side) then
			originalNeonLightState = 1
		else
			originalNeonLightState = 0
		end

		originalNeonLightSide = side
	end

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeonColour(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalNeonColourR and not originalNeonColourG and not originalNeonColourB then
		originalNeonColourR,originalNeonColourG,originalNeonColourB = GetVehicleNeonLightsColour(vehicle)
	end

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewXenonColour(colour)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalXenonColour then
		originalXenonColour = GetVehicleHeadlightsColour(vehicle)
	end

	SetVehicleLights(vehicle,2)
	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPoliceLivery(liv)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleLivery(vehicle,tonumber(liv))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPlateIndex(index)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNumberPlateTextIndex(vehicle,tonumber(index))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyMod(categoryID,modID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if categoryID == 18 then
		ToggleVehicleMod(vehicle,categoryID,modID)
	elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	else
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYEXTRA
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyExtra(extraID)
	local Ped = PlayerPedId()
	local Vehicle = GetVehiclePedIsUsing(Ped)

	local engine = GetVehicleEngineHealth(Vehicle)
	local body = GetVehicleBodyHealth(Vehicle)
	local health = GetEntityHealth(Vehicle)
	local vehWindows = {}
	local vehTyres = {}
	local vehDoors = {}

	for i = 0,7 do
		local Status = false

		if GetTyreHealth(Vehicle,i) ~= 1000.0 then
			Status = true
		end

		vehTyres[i] = Status
	end

	for i = 0,5 do
		vehDoors[i] = IsVehicleDoorDamaged(Vehicle,i)
	end

	for i = 0,5 do
		vehWindows[i] = IsVehicleWindowIntact(Vehicle,i)
	end

	local isEnabled = IsVehicleExtraTurnedOn(Vehicle,extraID)
	if isEnabled == 1 then
		SetVehicleExtra(Vehicle,tonumber(extraID),1)
		SetVehiclePetrolTankHealth(Vehicle,4000.0)
	else
		SetVehicleExtra(Vehicle,tonumber(extraID),0)
		SetVehiclePetrolTankHealth(Vehicle,4000.0)
	end

	SetVehicleEngineHealth(Vehicle,engine)
	SetVehicleBodyHealth(Vehicle,body)
	SetEntityHealth(Vehicle,health)

	for Tyre,Burst in pairs(vehTyres) do
		if Burst then
			SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
		end
	end

	for k,v in pairs(vehWindows) do
		if not v then
			SmashVehicleWindow(Vehicle,k)
		end
	end

	for k,v in pairs(vehDoors) do
		if v then
			SetVehicleDoorBroken(Vehicle,k,v)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWindowTint(windowTintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalWindowTint = windowTintID

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyColour(paintType,paintCategory,paintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local vehPrimaryColour,vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour,vehWheelColour = GetVehicleExtraColours(vehicle)

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,vehWheelColour)
			originalPrimaryColour = paintID
		else
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			originalPrimaryColour = paintID
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,vehPrimaryColour,paintID)
		originalSecondaryColour = paintID
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,vehWheelColour)
		originalPearlescentColour = paintID
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,vehPearlescentColour,paintID)
		originalWheelColour = paintID
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
		originalDashColour = paintID
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
		originalInterColour = paintID
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWheel(categoryID,wheelID,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	originalWheelCategory = categoryID
	originalWheel = wheelID
	originalWheelType = wheelType

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)
	
	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyCustomWheel(state)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleMod(vehicle,23,GetVehicleMod(vehicle,23),state)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,GetVehicleMod(vehicle,24),state)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeon(side,enabled)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalNeonLightState = enabled
	originalNeonLightSide = side

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeonColour(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalNeonColourR = r
	originalNeonColourG = g
	originalNeonColourB = b

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONLIGHTS
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonLights(category,state)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	ToggleVehicleMod(vehicle,category,state)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonColour(colour)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalXenonColour = colour

	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPoliceLivery(liv)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalPoliceLivery = liv

	SetVehicleLivery(vehicle,liv)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPlateIndex(index)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalPlateIndex = index

	SetVehicleNumberPlateTextIndex(vehicle,index)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTYRESMOKE
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyTyreSmoke(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	ToggleVehicleMod(vehicle,20,true)
	SetVehicleTyreSmokeColor(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITBENNYS
-----------------------------------------------------------------------------------------------------------------------------------------
function ExitBennys()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)
		if GetPedInVehicleSeat(vehicle,-1) == Ped then
			FreezeEntityPosition(vehicle,false)
			saveVehicle()
		end
	end

	TriggerServerEvent("lscustoms:inVehicle",nil)
	TriggerEvent("player:inBennys",false)
	DisplayMenuContainer(false)
	activeBennys = false
	DestroyMenus()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
function disableControls()
	activeBennys = true

	CreateThread(function()
		while activeBennys do
			DisableControlAction(0,38,true)
			DisableControlAction(0,172,true)
			DisableControlAction(0,173,true)
			DisableControlAction(0,177,true)
			DisableControlAction(0,176,true)
			DisableControlAction(0,71,true)
			DisableControlAction(0,72,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,75,true)
			
			if IsDisabledControlJustReleased(1,172) then
				MenuScrollFunctionality("up")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,173) then
				MenuScrollFunctionality("down")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,176) then
				MenuManager(true)
				PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,177) then
				MenuManager(false)
				PlaySoundFrontend(-1,"NO","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end

			Wait(0)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASESUCCESFUL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseSuccessful")
AddEventHandler("lscustoms:purchaseSuccessful",function()
	isPurchaseSuccessful = true
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASEFAILED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseFailed")
AddEventHandler("lscustoms:purchaseFailed",function()
	isPurchaseSuccessful = false
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if not activeBennys then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
				local vehicle = GetVehiclePedIsUsing(Ped)
				if GetPedInVehicleSeat(vehicle,-1) == Ped then
					for k,v in pairs(bennysLocations) do
						local Distance = #(Coords - v["pos"])

						if Distance <= 2.5 then
							TimeDistance = 1

							if IsControlJustPressed(1,38) and MumbleIsConnected() and vSERVER.checkPermission(v["permission"]) then
								local isMotorcycle = false

								if v["bikes"] then
									if GetVehicleClass(vehicle) == 8 then
										isMotorcycle = true
									else
										goto skipBennys
									end
								else
									if GetVehicleClass(vehicle) == 8 then
										isMotorcycle = true
									else
										isMotorcycle = false
									end
								end

								SetVehicleModKit(vehicle,0)
								SetEntityCoords(vehicle,v["pos"])
								SetEntityHeading(vehicle,v["heading"])
								FreezeEntityPosition(vehicle,true)
								SetVehicleOnGroundProperly(vehicle)

								originalCategory = nil
								originalMod = nil
								originalPrimaryColour = nil
								originalSecondaryColour = nil
								originalPearlescentColour = nil
								originalWheelColour = nil
								originalDashColour = nil
								originalInterColour = nil
								originalWindowTint = nil
								originalWheelCategory = nil
								originalWheel = nil
								originalWheelType = nil
								originalCustomWheels = nil
								originalNeonLightState = nil
								originalNeonLightSide = nil
								originalNeonColourR = nil
								originalNeonColourG = nil
								originalNeonColourB = nil
								originalXenonColour = nil
								originalPoliceLivery = nil
								originalPlateIndex = nil

								InitiateMenus(isMotorcycle)

								DisplayMenuContainer(true)
								DisplayMenu(true,"mainMenu")
								TriggerEvent("player:inBennys",true)
								PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
								TriggerServerEvent("lscustoms:inVehicle",VehToNet(vehicle),GetVehicleNumberPlateText(vehicle))

								disableControls()

								::skipBennys::
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)