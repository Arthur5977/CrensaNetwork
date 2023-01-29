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
Tunnel.bindInterface("skinshop",Creative)
vSERVER = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = "hat"
local Camera = nil
local Animation = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Skinshop"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATASET
-----------------------------------------------------------------------------------------------------------------------------------------
local Dataset = {
	["pants"] = { item = 0, texture = 0 },
	["arms"] = { item = 0, texture = 0 },
	["tshirt"] = { item = 1, texture = 0 },
	["torso"] = { item = 0, texture = 0 },
	["vest"] = { item = 0, texture = 0 },
	["shoes"] = { item = 0, texture = 0 },
	["mask"] = { item = 0, texture = 0 },
	["backpack"] = { item = 0, texture = 0 },
	["hat"] = { item = -1, texture = 0 },
	["glass"] = { item = 0, texture = 0 },
	["ear"] = { item = -1, texture = 0 },
	["watch"] = { item = -1, texture = 0 },
	["bracelet"] = { item = -1, texture = 0 },
	["accessory"] = { item = 0, texture = 0 },
	["decals"] = { item = 0, texture = 0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:Apply")
AddEventHandler("skinshop:Apply",function(Table)
	for Index,v in pairs(Dataset) do
		if not Table[Index] then
			Table[Index] = v
		end
	end

	Dataset = Table
	vSERVER.Update(Dataset)
	exports["skinshop"]:Apply()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Skinshops = {
	{ -1124.28,-1442.92,5.22 },
	{ 74.88,-1400.08,29.37 },
	{ 80.42,-1400.13,29.37 },
	{ -709.09,-143.23,37.41 },
	{ -701.47,-156.89,37.41 },
	{ -166.04,-294.02,39.73 },
	{ -171.45,-308.83,39.73 },
	{ -828.87,-1076.69,11.32 },
	{ -826.14,-1081.52,11.32 },
	{ -1198.62,-770.67,17.3 },
	{ -1451.4,-247.0,49.82 },
	{ -1440.71,-235.17,49.82 },
	{ 10.38,6516.93,31.88 },
	{ 6.66,6521.02,31.88 },
	{ 1693.48,4829.94,42.06 },
	{ 1688.02,4829.23,42.06 },
	{ 129.04,-218.61,54.56 },
	{ 613.28,2756.72,42.09 },
	{ 1189.51,2710.73,38.22 },
	{ 1189.46,2705.23,38.22 },
	{ -3167.03,1048.69,20.86 },
	{ -1107.17,2706.14,19.11 },
	{ -1103.47,2702.0,19.11 },
	{ 426.08,-799.02,29.49 },
	{ 420.55,-799.1,29.49 },
	{ 1210.61,-1474.0,34.85 }, -- Bombeiros
	{ -1181.86,-900.55,13.99 }, -- BurgerShot
	{ 461.46,-998.05,31.19 }, -- Departamento LSPD
	{ 387.29,799.17,187.45 }, -- Departamento Ranger
	{ 1841.13,3679.86,34.19 }, -- Departamento Sheriff
	{ -437.49,6009.62,36.99 }, -- Departamento Sheriff
	{ 361.77,-1593.19,25.9 }, -- Departamento State
	{ -586.89,-1049.92,22.34 }, -- Uwu Café
	{ 300.2,-598.85,43.29 }, -- Hospital Sul
	{ -256.56,6327.32,32.42 }, -- Hospital Norte
	{ 841.11,-824.54,26.34 }, -- Mecânica Sul
	{ 801.62,-830.37,26.34 }, -- Mecânica Sul
	{ 810.31,-760.23,31.26 } -- Pizza This
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Tables = {}

	for Number = 1,#Skinshops do
		Tables[#Tables + 1] = { Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3],2.0,"E","Loja de Roupas","Pressione para abrir" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number = 1,#Skinshops do
					local Distance = #(Coords - vec3(Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3]))
					if Distance <= 2 then
						TimeDistance = 1

						if IsControlJustPressed(0,38) then
							OpenSkinshop()
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:Open")
AddEventHandler("skinshop:Open",function(Boolean,Variable)
	TriggerEvent("dynamic:closeSystem")

	if Variable then
		OpenSkinshop()
		vSERVER.Bucket(true)
		return
	end

	if not vSERVER.Check() then
		OpenSkinshop()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXVALUES
-----------------------------------------------------------------------------------------------------------------------------------------
function MaxValues()
	local MaxValues = {
		["pants"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 4 },
		["arms"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 3 },
		["tshirt"] = { min = 1, item = 0, texture = 0, mode = "variation", id = 8 },
		["torso"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 11 },
		["vest"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 9 },
		["shoes"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 6 },
		["mask"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 1 },
		["backpack"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 5 },
		["hat"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 0 },
		["glass"] = { min = 0, item = 0, texture = 0, mode = "prop", id = 1 },
		["ear"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 2 },
		["watch"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 6 },
		["bracelet"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 7 },
		["accessory"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 7 },
		["decals"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 10 }
	}

	local Ped = PlayerPedId()
	for Index,v in pairs(MaxValues) do
		if v["mode"] == "variation" then
			v["item"] = GetNumberOfPedDrawableVariations(Ped,v["id"])
			v["texture"] = GetNumberOfPedTextureVariations(Ped,v["id"],GetPedDrawableVariation(Ped,v["id"])) - 1
		elseif v["mode"] == "prop" then
			v["item"] = GetNumberOfPedPropDrawableVariations(Ped,v["id"])
			v["texture"] = GetNumberOfPedPropTextureVariations(Ped,v["id"],GetPedPropIndex(Ped,v["id"])) - 1
		end

		if v["texture"] < 0 then
			v["texture"] = 0
		end
	end

	return MaxValues
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenSkinshop()
	LocalPlayer["state"]["Skinshop"] = Dataset
	Bucket = LocalPlayer["state"]["Route"]
	SendNUIMessage({ action = "open", data = { Current = Dataset, Max = MaxValues() } })
	vRP.PlayAnim(true,{"mp_sleep","bind_pose_180"},true)

	SetNuiFocus(true,true)
	CameraActive()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function CameraActive(Number)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	local Ped = PlayerPedId()

	if Number then
		SetEntityCoords(Ped,Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3] - 1)
		SetEntityHeading(Ped,Skinshops[Number][4])
	end

	local Heading = GetEntityHeading(Ped)
	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.25,1.0,0.0)

	if Init == "hat" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.45)
	elseif Init == "shirt" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.25)
	elseif Init == "pants" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.45)
	elseif Init == "clock" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	end

	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading)
	SetCamActive(Camera,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function(Data,Ped)
	if not Ped then
		Ped = PlayerPedId()
	end

	if not Data then
		Data = Dataset
	end

	for Index,v in pairs(Dataset) do
		if not Data[Index] then
			Data[Index] = {
				["item"] = v["item"],
				["texture"] = v["texture"]
			}
		end
	end

	SetPedComponentVariation(Ped,4,Data["pants"]["item"],Data["pants"]["texture"],1)
	SetPedComponentVariation(Ped,3,Data["arms"]["item"],Data["arms"]["texture"],1)
	SetPedComponentVariation(Ped,5,Data["backpack"]["item"],Data["backpack"]["texture"],1)
	SetPedComponentVariation(Ped,8,Data["tshirt"]["item"],Data["tshirt"]["texture"],1)
	SetPedComponentVariation(Ped,9,Data["vest"]["item"],Data["vest"]["texture"],1)
	SetPedComponentVariation(Ped,11,Data["torso"]["item"],Data["torso"]["texture"],1)
	SetPedComponentVariation(Ped,6,Data["shoes"]["item"],Data["shoes"]["texture"],1)
	SetPedComponentVariation(Ped,1,Data["mask"]["item"],Data["mask"]["texture"],1)
	SetPedComponentVariation(Ped,10,Data["decals"]["item"],Data["decals"]["texture"],1)
	SetPedComponentVariation(Ped,7,Data["accessory"]["item"],Data["accessory"]["texture"],1)

	if Data["hat"]["item"] ~= -1 and Data["hat"]["item"] ~= 0 then
		SetPedPropIndex(Ped,0,Data["hat"]["item"],Data["hat"]["texture"],1)
	else
		ClearPedProp(Ped,0)
	end

	if Data["glass"]["item"] ~= -1 and Data["glass"]["item"] ~= 0 then
		SetPedPropIndex(Ped,1,Data["glass"]["item"],Data["glass"]["texture"],1)
	else
		ClearPedProp(Ped,1)
	end

	if Data["ear"]["item"] ~= -1 and Data["ear"]["item"] ~= 0 then
		SetPedPropIndex(Ped,2,Data["ear"]["item"],Data["ear"]["texture"],1)
	else
		ClearPedProp(Ped,2)
	end

	if Data["watch"]["item"] ~= -1 and Data["watch"]["item"] ~= 0 then
		SetPedPropIndex(Ped,6,Data["watch"]["item"],Data["watch"]["texture"],1)
	else
		ClearPedProp(Ped,6)
	end

	if Data["bracelet"]["item"] ~= -1 and Data["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(Ped,7,Data["bracelet"]["item"],Data["bracelet"]["texture"],1)
	else
		ClearPedProp(Ped,7)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("update",function(Data,Callback)
	Dataset = Data
	exports["skinshop"]:Apply()

	Callback(MaxValues())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Setup",function(Data,Callback)
	Init = Data["value"]
	local Ped = PlayerPedId()
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.25,1.0,0.0)

	if Init == "hat" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.45)
	elseif Init == "shirt" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.25)
	elseif Init == "pants" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.45)
	elseif Init == "clock" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Save",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	SetNuiFocus(false,false)
	vSERVER.Update(Dataset)
	vRP.Destroy()
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Reset",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	exports["skinshop"]:Apply(LocalPlayer["state"]["Skinshop"])

	Dataset = LocalPlayer["state"]["Skinshop"]
	LocalPlayer["state"]["Skinshop"] = {}
	SetNuiFocus(false,false)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()

	if Data == "Left" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) - 5)
	elseif Data == "Right" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) + 5)
	elseif Data == "Top" then
		local Coords = GetCamCoord(Camera)
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	elseif Data == "Bottom" then
		local Coords = GetCamCoord(Camera)
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.05)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setMask")
AddEventHandler("skinshop:setMask",function()
	if not Animation and not LocalPlayer["state"]["Buttons"] then
		Animation = true
		vRP.PlayAnim(true,{"missfbi4","takeoff_mask"},true)

		Wait(1000)

		local Ped = PlayerPedId()
		if GetPedDrawableVariation(Ped,1) == Dataset["mask"]["item"] then
			SetPedComponentVariation(Ped,1,0,0,1)
		else
			SetPedComponentVariation(Ped,1,Dataset["mask"]["item"],Dataset["mask"]["texture"],1)
		end

		Animation = false
		vRP.Destroy()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setHat")
AddEventHandler("skinshop:setHat",function()
	if not Animation and not LocalPlayer["state"]["Buttons"] then
		Animation = true
		vRP.PlayAnim(true,{"mp_masks@standard_car@ds@","put_on_mask"},true)

		Wait(1000)

		local Ped = PlayerPedId()
		if GetPedPropIndex(Ped,0) == Dataset["hat"]["item"] then
			ClearPedProp(Ped,0)
		else
			SetPedPropIndex(Ped,0,Dataset["hat"]["item"],Dataset["hat"]["texture"],1)
		end

		Animation = false
		vRP.Destroy()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETGLASSES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setGlasses")
AddEventHandler("skinshop:setGlasses",function()
	if not Animation and not LocalPlayer["state"]["Buttons"] then
		Animation = true
		vRP.PlayAnim(true,{"clothingspecs","take_off"},true)

		Wait(1000)

		local Ped = PlayerPedId()
		if GetPedPropIndex(Ped,1) == Dataset["glass"]["item"] then
			ClearPedProp(Ped,1)
		else
			SetPedPropIndex(Ped,1,Dataset["glass"]["item"],Dataset["glass"]["texture"],1)
		end

		Animation = false
		vRP.Destroy()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkShoes()
	local Number = 34
	local Ped = PlayerPedId()
	if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
		Number = 35
	end

	if Dataset["shoes"]["item"] ~= Number then
		Dataset["shoes"]["item"] = Number
		Dataset["shoes"]["texture"] = 0
		SetPedComponentVariation(Ped,6,Dataset["shoes"]["item"],Dataset["shoes"]["texture"],1)

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Customization()
	return Dataset
end