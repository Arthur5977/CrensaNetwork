-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("spawn",Creative)
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Peds = {}
local Camera = nil
local Destroy = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PedCoords
-----------------------------------------------------------------------------------------------------------------------------------------
local PedCoords = {
	{ -2004.36,630.49,121.53,150.00 },
	{ -2003.26,630.97,121.53,150.00 },
	{ -2002.31,631.23,121.53,150.00 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMS
-----------------------------------------------------------------------------------------------------------------------------------------
local Anims = {
	{ ["Dict"] = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", ["Name"] = "hi_dance_crowd_17_v2_male^2" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", ["Name"] = "high_center_down" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", ["Name"] = "med_center_up" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Locate = {
	{ ["x"] = -2205.92, ["y"] = -370.48, ["z"] = 13.29, ["name"] = "Great Ocean", ["hash"] = 1 },
	{ ["x"] = -250.35, ["y"] = 6209.71, ["z"] = 31.49, ["name"] = "Duluoz Avenue", ["hash"] = 2 },
	{ ["x"] = 1694.37, ["y"] = 4794.66, ["z"] = 41.92, ["name"] = "Grapedseed Avenue", ["hash"] = 3 },
	{ ["x"] = 1858.94, ["y"] = 3741.78, ["z"] = 33.09, ["name"] = "Armadillo Avenue", ["hash"] = 4 },
	{ ["x"] = 328.0, ["y"] = 2617.89, ["z"] = 44.48, ["name"] = "Senora Road", ["hash"] = 5 },
	{ ["x"] = 308.33, ["y"] = -232.25, ["z"] = 54.07, ["name"] = "Hawick Avenue", ["hash"] = 6 },
	{ ["x"] = 449.71, ["y"] = -659.27, ["z"] = 28.48, ["name"] = "Integrity Way", ["hash"] = 7 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:OPENED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("spawn:Opened",function()
	Wait(5000)

	local Ped = PlayerPedId()
	SetEntityCoords(Ped,-2005.7,628.74,122.53,false,false,false,false)
	SetEntityVisible(Ped,false,false)
	FreezeEntityPosition(Ped,true)
	SetEntityInvincible(Ped,true)
	SetEntityHeading(Ped,136.07)
	SetEntityHealth(Ped,101)
	SetPedArmour(Ped,0)

	local Characters = vSERVER.Characters()
	if parseInt(#Characters) > 0 then
		for Number,v in pairs(Characters) do
			if not v["Skin"] then
				v["Skin"] = "mp_m_freemode_01"
			end

			RequestModel(v["Skin"])
			while not HasModelLoaded(v["Skin"]) do
				Wait(1)
			end

			if HasModelLoaded(v["Skin"]) then
				Peds[Number] = CreatePed(0,v["Skin"],PedCoords[Number][1],PedCoords[Number][2],PedCoords[Number][3],PedCoords[Number][4],false,false)
				SetEntityInvincible(Peds[Number],true)
				FreezeEntityPosition(Peds[Number],true)
				SetPedComponentVariation(Peds[Number],5,0,0,1)
				SetBlockingOfNonTemporaryEvents(Peds[Number],true)
				SetModelAsNoLongerNeeded(v["Skin"])

				local Ped = PlayerPedId()
				local Random = math.random(#Anims)
				if LoadAnim(Anims[Random]["Dict"]) then
					TaskPlayAnim(Peds[Number],Anims[Random]["Dict"],Anims[Random]["Name"],8.0,8.0,-1,1,0,0,0,0)
				end

				if NewSkinShop then
					exports["skinshop"]:Apply(v["Clothes"],Peds[Number])
				else
					Clothes(Peds[Number],v["Clothes"])
				end

				if NewBarberShop then
					exports["barbershop"]:Apply(v["Barber"],Peds[Number])
				else
					Barber(Peds[Number],v["Barber"])
				end

				for Index,Overlay in pairs(v["Tattoos"]) do
					AddPedDecorationFromHashes(Peds[Number],Overlay,Index)
				end
			end
		end
	end

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamCoord(Camera,-2005.7,628.74,122.53)
	RenderScriptCams(true,true,0,true,true)
	SetCamRot(Camera,0.0,0.0,320.0,2)
	SetCamActive(Camera,true)

	Wait(5000)

	SendNUIMessage({ action = "openSystem", infos = Characters })
	TriggerServerEvent("Queue:Connect")
	SetNuiFocus(true,true)

	if IsScreenFadedOut() then
		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEDISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateDisplay",function(data,cb)
	cb({ result = vSERVER.initSystem() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("characterChosen",function(Data,Callback)
	for _,v in pairs(Peds) do
		if DoesEntityExist(v) then
			SetEntityAsNoLongerNeeded(v)
			DeleteEntity(v)
		end
	end

	vSERVER.characterChosen(Data["id"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("newCharacter",function(Data,Callback)
	vSERVER.newCharacter(Data["name"],Data["name2"],Data["sex"],Data["locate"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateSpawn",function(Data,Callback)
	Callback({ result = Locate })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:justSpawn")
AddEventHandler("spawn:justSpawn",function(Open,Barbershop)
	local Ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(Camera,false)
	DestroyCam(Camera,true)
	Camera = nil

	if Open then
		local Coords = GetEntityCoords(Ped)
		Camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",Coords["x"],Coords["y"],Coords["z"] + 200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(Camera,true)
		RenderScriptCams(true,false,1,true,true)

		SendNUIMessage({ action = "openSpawn" })
	else
		SetEntityVisible(Ped,true,false)
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)
		Destroy = false

		if Barbershop then
			Wait(1000)
			TriggerEvent("barbershop:Open","open",true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSENEW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.closeNew()
	SendNUIMessage({ action = "closeNew" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:Close")
AddEventHandler("spawn:Close",function()
	SendNUIMessage({ action = "closeNew" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnChosen",function(Data,Callback)
	local Ped = PlayerPedId()

	if Data["hash"] == "spawn" then
		DoScreenFadeOut(0)

		SendNUIMessage({ action = "closeSpawn" })
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)

		LocalPlayer["state"]:set("Invisible",false,true)
		RenderScriptCams(false,false,0,true,true)
		SetEntityVisible(Ped,true,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,true)
		Destroy = false
		Camera = nil

		Wait(1000)

		DoScreenFadeIn(1000)
	else
		Destroy = false
		DoScreenFadeOut(0)

		Wait(1000)

		SetCamRot(Camera,270.0)
		SetCamActive(Camera,true)
		Destroy = true
		local speed = 0.7
		weight = 270.0

		DoScreenFadeIn(1000)

		SetEntityCoords(Ped,Locate[Data["hash"]]["x"],Locate[Data["hash"]]["y"],Locate[Data["hash"]]["z"],false,false,false,false)
		local Coords = GetEntityCoords(Ped)

		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 200.0)
		local i = Coords["z"] + 200.0

		while i > Locate[Data["hash"]]["z"] + 1.5 do
			i = i - speed
			SetCamCoord(Camera,Coords["x"],Coords["y"],i)

			if i <= Locate[Data["hash"]]["z"] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(Camera,weight)
			end

			if not Destroy then
				break
			end

			Wait(0)
		end
	end

	Callback("Ok")
end)
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
-- CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Clothes(Ped,Data)
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
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBER
-----------------------------------------------------------------------------------------------------------------------------------------
function Barber(Ped,Status)
	local Clothes = {}
	for Number = 1,41 do
		Clothes[Number] = Status[Number] or 0
	end

    local Face = Clothes[2] / 100 + 0.0
    local Skin = Clothes[4] / 100 + 0.0

	SetPedHeadBlendData(Ped,Clothes[41],Clothes[1],0,Clothes[41],Clothes[1],0,Face,Skin,0.0,false)

	SetPedEyeColor(Ped,Clothes[3])

	if Clothes[5] == 0 then
		SetPedHeadOverlay(Ped,0,Clothes[5],0.0)
	else
		SetPedHeadOverlay(Ped,0,Clothes[5],1.0)
	end

	SetPedHeadOverlay(Ped,6,Clothes[6],1.0)

	if Clothes[7] == 0 then
		SetPedHeadOverlay(Ped,9,Clothes[7],0.0)
	else
		SetPedHeadOverlay(Ped,9,Clothes[7],1.0)
	end

	SetPedHeadOverlay(Ped,3,Clothes[8],1.0)

	SetPedComponentVariation(Ped,2,Clothes[9],0,1)
	SetPedHairColor(Ped,Clothes[10],Clothes[11])

	SetPedHeadOverlay(Ped,4,Clothes[12],Clothes[13] * 0.1)
	SetPedHeadOverlayColor(Ped,4,1,Clothes[14],Clothes[14])

	SetPedHeadOverlay(Ped,8,Clothes[15],Clothes[16] * 0.1)
	SetPedHeadOverlayColor(Ped,8,1,Clothes[17],Clothes[17])

	SetPedHeadOverlay(Ped,2,Clothes[18],Clothes[19] * 0.1)
	SetPedHeadOverlayColor(Ped,2,1,Clothes[20],Clothes[20])

	SetPedHeadOverlay(Ped,1,Clothes[21],Clothes[22] * 0.1)
	SetPedHeadOverlayColor(Ped,1,1,Clothes[23],Clothes[23])

	SetPedHeadOverlay(Ped,5,Clothes[24],Clothes[25] * 0.1)
	SetPedHeadOverlayColor(Ped,5,1,Clothes[26],Clothes[26])

	SetPedFaceFeature(Ped,0,Clothes[27] * 0.1)
	SetPedFaceFeature(Ped,1,Clothes[28] * 0.1)
	SetPedFaceFeature(Ped,4,Clothes[29] * 0.1)
	SetPedFaceFeature(Ped,6,Clothes[30] * 0.1)
	SetPedFaceFeature(Ped,8,Clothes[31] * 0.1)
	SetPedFaceFeature(Ped,9,Clothes[32] * 0.1)
	SetPedFaceFeature(Ped,10,Clothes[33] * 0.1)
	SetPedFaceFeature(Ped,12,Clothes[34] * 0.1)
	SetPedFaceFeature(Ped,13,Clothes[35] * 0.1)
	SetPedFaceFeature(Ped,14,Clothes[36] * 0.1)
	SetPedFaceFeature(Ped,15,Clothes[37] * 0.1)
	SetPedFaceFeature(Ped,16,Clothes[38] * 0.1)
	SetPedFaceFeature(Ped,17,Clothes[39] * 0.1)
	SetPedFaceFeature(Ped,19,Clothes[40] * 0.1)
end