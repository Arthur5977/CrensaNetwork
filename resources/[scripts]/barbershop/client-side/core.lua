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
Tunnel.bindInterface("barbershop",Creative)
vSERVER = Tunnel.getInterface("barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Barber = {}
local Camera = nil
local FirstLogin = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Barbershop"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Finish",function(Data,Callback)
	if not FirstLogin then
		vSERVER.Bucket(false)
	else
		FirstLogin = false
		vSERVER.Bucket(false)
		vSERVER.NoMoreNewbie(true)
		TriggerEvent("skinshop:Open",true,true)
		FreezeEntityPosition(PlayerPedId(),false)
	end

	exports["barbershop"]:Apply(Data)
	SetNuiFocus(false,false)
	vSERVER.Update(Data)
	vRP.Destroy()

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Cancel",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	exports["barbershop"]:Apply(LocalPlayer["state"]["Barbershop"])
	vSERVER.Bucket(false)
	LocalPlayer["state"]["Barbershop"] = {}
	SetNuiFocus(false,false)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	local Ped = PlayerPedId()
	if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") and Data[47] == 0 then
		vSERVER.ChangeSkin("mp_m_freemode_01")
		exports["skinshop"]:Apply()
	elseif GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01") and Data[47] == 1 then
		vSERVER.ChangeSkin("mp_f_freemode_01")
		exports["skinshop"]:Apply()
	end

	for Index,v in pairs(Data) do
		Barber[Index] = v
	end

	exports["barbershop"]:Apply()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()
	local Heading = GetEntityHeading(Ped)
	if Data == "Left" then
		SetEntityHeading(Ped,Heading + 10)
	else
		SetEntityHeading(Ped,Heading - 10)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("barbershop:Apply")
AddEventHandler("barbershop:Apply",function(Table)
	if Table then
		exports["barbershop"]:Apply(Table)
	else
		exports["barbershop"]:Apply()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function(Table,Ped)
	if not Ped then
		Ped = PlayerPedId()
	end

	if Table then
		Barber = Table
	end

	for Number = 1,47 do
		if not Barber[Number] then
			Barber[Number] = 0
		end
	end

	SetPedHeadBlendData(Ped,Fathers[Barber[1] + 1],Mothers[Barber[2] + 1],0,Barber[5],0,0,Barber[3] + 0.0,0,0,false)

	SetPedEyeColor(Ped,Barber[4])

	SetPedComponentVariation(Ped,2,Barber[10],0,0)
	SetPedHairColor(Ped,Barber[11],Barber[12])

	SetPedHeadOverlay(Ped,0,Barber[7],0.99)
	SetPedHeadOverlayColor(Ped,0,0,0,0)

	SetPedHeadOverlay(Ped,1,Barber[22],Barber[23])
	SetPedHeadOverlayColor(Ped,1,1,Barber[24],Barber[24])

	SetPedHeadOverlay(Ped,2,Barber[19],Barber[20])
	SetPedHeadOverlayColor(Ped,2,1,Barber[21],Barber[21])

	SetPedHeadOverlay(Ped,3,Barber[9],0.99)
	SetPedHeadOverlayColor(Ped,3,0,0,0)

	SetPedHeadOverlay(Ped,4,Barber[13],Barber[14])
	SetPedHeadOverlayColor(Ped,4,1,Barber[15],Barber[15])

	SetPedHeadOverlay(Ped,5,Barber[25],Barber[26])
	SetPedHeadOverlayColor(Ped,5,1,Barber[27],Barber[27])

	SetPedHeadOverlay(Ped,6,Barber[6],0.99)
	SetPedHeadOverlayColor(Ped,6,0,0,0)

	SetPedHeadOverlay(Ped,8,Barber[16],Barber[17])
	SetPedHeadOverlayColor(Ped,8,1,Barber[18],Barber[18])

	SetPedHeadOverlay(Ped,9,Barber[8],0.99)
	SetPedHeadOverlayColor(Ped,9,0,0,0)

	SetPedFaceFeature(Ped,0,Barber[28])
	SetPedFaceFeature(Ped,1,Barber[29])
	SetPedFaceFeature(Ped,2,Barber[30])
	SetPedFaceFeature(Ped,3,Barber[31])
	SetPedFaceFeature(Ped,4,Barber[32])
	SetPedFaceFeature(Ped,5,Barber[33])
	SetPedFaceFeature(Ped,6,Barber[44])
	SetPedFaceFeature(Ped,7,Barber[34])
	SetPedFaceFeature(Ped,8,Barber[36])
	SetPedFaceFeature(Ped,9,Barber[35])
	SetPedFaceFeature(Ped,10,Barber[45])
	SetPedFaceFeature(Ped,12,Barber[42])
	SetPedFaceFeature(Ped,13,Barber[46])
	SetPedFaceFeature(Ped,14,Barber[37])
	SetPedFaceFeature(Ped,15,Barber[38])
	SetPedFaceFeature(Ped,16,Barber[40])
	SetPedFaceFeature(Ped,17,Barber[39])
	SetPedFaceFeature(Ped,18,Barber[41])
	SetPedFaceFeature(Ped,19,Barber[43])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenBarbershop(Mode)
	for Number = 1,47 do
		if not Barber[Number] then
			Barber[Number] = 0
		end
	end
    local Ped = PlayerPedId()
	LocalPlayer["state"]["Barbershop"] = Barber
    if not FirstLogin then
        vSERVER.Bucket(true)
    else
        SetEntityHeading(Ped,138.9)
    end
	vRP.playAnim(true,{"mp_sleep","bind_pose_180"},true)

	
	local Heading = GetEntityHeading(Ped)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.5,0)

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.6)
	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading)
	SetCamActive(Camera,true)

	SendNUIMessage({ action = Mode, data = { Barber,GetNumberOfPedDrawableVariations(Ped,2) - 1 } })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local Locations = {
	vec3(-813.37,-183.85,37.57),
	vec3(138.13,-1706.46,29.3),
	vec3(-1280.92,-1117.07,7.0),
	vec3(1930.54,3732.06,32.85),
	vec3(1214.2,-473.18,66.21),
	vec3(-33.61,-154.52,57.08),
	vec3(-276.65,6226.76,31.7)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Tables = {}

	for Number = 1,#Locations do
		Tables[#Tables + 1] = { Locations[Number]["x"],Locations[Number]["y"],Locations[Number]["z"],2.5,"E","Barbearia","Pressione para abrir" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number = 1,#Locations do
					if #(Coords - Locations[Number]) <= 2.5 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) and vSERVER.Check() then
							OpenBarbershop("barber")
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("barbershop:Open")
AddEventHandler("barbershop:Open",function(Mode,Bool)
	vSERVER.Bucket(true)
	OpenBarbershop(Mode)
	FirstLogin = Bool
end)