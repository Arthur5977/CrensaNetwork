-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("hud",Creative)
vSERVER = Tunnel.getInterface("hud")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Display = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Road = ""
local Hood = false
local Gemstone = 0
local Pause = false
local Crossing = ""
local Foods = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Health = 999
local Armour = 999
-----------------------------------------------------------------------------------------------------------------------------------------
-- THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
local Thirst = 999
local ThirstTimer = 0
local ThirstDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
local Hunger = 999
local HungerTimer = 0
local HungerDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
local Stress = 999
local StressTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = 0
local WantedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reposed = 0
local ReposedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
local Luck = 0
local LuckTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
local Dexterity = 0
local DexterityTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()

			if IsPauseMenuActive() then
				if not Pause and Display then
					SendNUIMessage({ Action = "Body", Status = false })
					Pause = true
				end
			else
				if Display then
					if Pause then
						SendNUIMessage({ Action = "Body", Status = true })
						Pause = false
					end

					local Coords = GetEntityCoords(Ped)
					local Armouring = GetPedArmour(Ped)
					local Healing = GetEntityHealth(Ped)
					local MinRoad,MinCross = GetStreetNameAtCoord(Coords["x"],Coords["y"],Coords["z"])
					local FullRoad = GetStreetNameFromHashKey(MinRoad)
					local FullCross = GetStreetNameFromHashKey(MinCross)

					if Health ~= Healing then
						SendNUIMessage({ Action = "Health", Number = Healing - 100 })
						Health = Healing
					end

					if Armour ~= Armouring then
						SendNUIMessage({ Action = "Armour", Number = Armouring })
						Armour = Armouring
					end

					if FullRoad ~= "" and Road ~= FullRoad then
						SendNUIMessage({ Action = "Road", Name = FullRoad })
						Road = FullRoad
					end

					if FullCross ~= "" and Crossing ~= FullCross then
						SendNUIMessage({ Action = "Crossing", Name = FullCross })
						Crossing = FullCross
					end

					SendNUIMessage({ Action = "Clock", Hours = GlobalState["Hours"], Minutes = GlobalState["Minutes"] })
				end
			end

			if Luck > 0 and LuckTimer <= GetGameTimer() then
				Luck = Luck - 1
				LuckTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Luck", Number = Luck })
			end

			if Dexterity > 0 and DexterityTimer <= GetGameTimer() then
				Dexterity = Dexterity - 1
				DexterityTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Dexterity", Number = Dexterity })
			end

			if Wanted > 0 and WantedTimer <= GetGameTimer() then
				Wanted = Wanted - 1
				WantedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Wanted", Number = Wanted })
			end

			if Reposed > 0 and ReposedTimer <= GetGameTimer() then
				Reposed = Reposed - 1
				ReposedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Reposed", Number = Reposed })
			end

			if GetEntityHealth(Ped) > 100 then
				if Hunger < 15 and HungerTimer <= GetGameTimer() then
					HungerTimer = GetGameTimer() + 10000
					ApplyDamageToPed(Ped,math.random(2),false)
					TriggerEvent("Notify",false,"Sofrendo com a fome.","fome",2500)
				end

				if Thirst < 15 and ThirstTimer <= GetGameTimer() then
					ThirstTimer = GetGameTimer() + 10000
					ApplyDamageToPed(Ped,math.random(2),false)
					TriggerEvent("Notify",false,"Sofrendo com a sede.","sede",2500)
				end

				if Stress >= 40 and StressTimer <= GetGameTimer() then
					StressTimer = GetGameTimer() + 10000

					AnimpostfxPlay("MenuMGIn")
					SetTimeout(2500,function()
						AnimpostfxStop("MenuMGIn")
					end)
				end

				if Hunger > 0 and HungerDelay <= GetGameTimer() then
					HungerDelay = GetGameTimer() + 60000
					vRPS.DowngradeHunger()
					Hunger = Hunger - 1
				end

				if Thirst > 0 and ThirstDelay <= GetGameTimer() then
					ThirstDelay = GetGameTimer() + 60000
					vRPS.DowngradeThirst()
					Thirst = Thirst - 1
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Passport",("player:%s"):format(LocalPlayer["state"]["Player"]),function(Name,Key,Value)
	SendNUIMessage({ Action = "Passport", Number = Value })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Voip",function(Number)
	local Target = { "Baixo","Normal","Médio","Alto","Megafone" }

	SendNUIMessage({ Action = "Voip", Voip = Target[Number] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Voice",function(Status)
	SendNUIMessage({ Action = "Voice", Status = Status and "#e3c124" or "#ccc" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted",function(Seconds)
	Wanted = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function()
	return Wanted > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Reposed")
AddEventHandler("hud:Reposed",function(Seconds)
	Reposed = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Reposed",function()
	return Reposed > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Active",function(Status)
	SendNUIMessage({ Action = "Body", Status = Status })
	Display = Status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function()
	Display = not Display
	SendNUIMessage({ Action = "Body", Status = Display })

	if not Display and IsMinimapRendering() then
		DisplayRadar(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(Message,Timer)
	SendNUIMessage({ Action = "Progress", Message = Message, Timer = Timer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	SendNUIMessage({ Action = "Voip", Voip = "Online" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	SendNUIMessage({ Action = "Voip", Voip = "Offline" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number)
	if Thirst ~= Number then
		SendNUIMessage({ Action = "Thirst", Number = Number })
		Thirst = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(Number)
	if Hunger ~= Number then
		SendNUIMessage({ Action = "Hunger", Number = Number })
		Hunger = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress",function(Number)
	if Stress ~= Number then
		SendNUIMessage({ Action = "Stress", Number = Number })
		Stress = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Luck")
AddEventHandler("hud:Luck",function(Seconds)
	Luck = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Dexterity")
AddEventHandler("hud:Dexterity",function(Seconds)
	Dexterity = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ADDGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:AddGemstone")
AddEventHandler("hud:AddGemstone",function(Number)
	Gemstone = Gemstone + Number

	SendNUIMessage({ Action = "Gemstone", Number = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveGemstone")
AddEventHandler("hud:RemoveGemstone",function(Number)
	Gemstone = Gemstone - Number

	if Gemstone < 0 then
		Gemstone = 0
	end

	SendNUIMessage({ Action = "Gemstone", Number = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Radio",function(Frequency)
	if type(Frequency) == "number" then
		SendNUIMessage({ Action = "Frequency", Frequency = Frequency.."Mhz" })
	else
		SendNUIMessage({ Action = "Frequency", Frequency = Frequency })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Hood",function()
	if Hood then
		DoScreenFadeIn(0)
		Hood = false
	else
		DoScreenFadeOut(0)
		Hood = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOODS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()
			if GetGameTimer() >= Foods and GetEntityHealth(Ped) > 100 then
				TriggerEvent("hud:Thirst",Thirst - 1)
				TriggerEvent("hud:Hunger",Hunger - 1)

				Foods = GetGameTimer() + 90000
				Thirst = Thirst - 1
				Hunger = Hunger - 1

				vRPS.Foods()
			end
		end

		Wait(60000)
	end
end)