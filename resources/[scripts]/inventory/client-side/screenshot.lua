-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local FovMin = 5.0
local FovMax = 70.0
local Camera = false
local Binoculars = false
local Total = (FovMax + FovMin) * 0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Camera")
AddEventHandler("inventory:Camera",function(Action)
	if not Camera then
		Binoculars = Action
		local Ped = PlayerPedId()
		local Heading = GetEntityHeading(Ped)

		if Binoculars then
			Scaleform = RequestScaleformMovie("BINOCULARS")
			while not HasScaleformMovieLoaded(Scaleform) do
				Wait(1)
			end

			vRP.createObjects("amb@world_human_binoculars@male@enter","enter","prop_binoc_01",50,28422)
		else
			vRP.createObjects("amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",49,28422)
		end

		Camera = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
		AttachCamToEntity(Camera,Ped,0.0,0.0,1.0,true)
		LocalPlayer["state"]:set("Camera",true,true)
		RenderScriptCams(true,true,100,true,true)
		SetCamRot(Camera,0.0,0.0,Heading)
		TriggerEvent("hud:Active",false)
		SetCamActive(Camera,true)
		SetCamFov(Camera,Total)

		while Camera do
			Wait(1)

			local Ped = PlayerPedId()
			local Zoom = (1.0 / (FovMax - FovMin)) * (Total - FovMin)
			CheckInputRotation(Camera,Zoom)
			HandleZoom(Camera)

			if Binoculars then
				DrawScaleformMovieFullscreen(Scaleform,255,255,255,255)
			end

			if IsPedArmed(Ped,6) then
				RemoveCamera()
			end
		end
	else
		RemoveCamera()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVECAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RemoveCamera()
	Total = (FovMax + FovMin) * 0.5

	LocalPlayer["state"]:set("Camera",false,true)

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	vRP.Destroy()

	TriggerEvent("hud:Active",true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(Cam,Zoom)
	local AxisX = GetDisabledControlNormal(0,220)
	local AxisY = GetDisabledControlNormal(0,221)
	local Rotation = GetCamRot(Cam,2)
	if AxisX ~= 0.0 or AxisY ~= 0.0 then
		NewZ = Rotation["z"] + AxisX * -1.0 * 8.0 * (Zoom + 0.1)
		NewX = math.max(math.min(20.0,Rotation["x"] + AxisY * -1.0 * 8.0 * (Zoom + 0.1)),-89.5)
		SetCamRot(Cam,NewX,0.0,NewZ,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(Cam)
	if IsControlJustPressed(1,241) then
		Total = math.max(Total - 5.0,FovMin)
	end

	if IsControlJustPressed(1,242) then
		Total = math.min(Total + 5.0,FovMax)
	end

	local Current = GetCamFov(Cam)
	if math.abs(Total - Current) < 0.1 then
		Total = Current
	end

	SetCamFov(Cam,Current + (Total - Current) * 0.05)
end