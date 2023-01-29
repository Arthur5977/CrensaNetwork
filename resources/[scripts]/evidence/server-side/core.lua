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
Tunnel.bindInterface("evidence",Creative)
vCLIENT = Tunnel.getInterface("evidence")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Evidences = {}
local evidenceNumber = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("evidence:dropEvidence")
AddEventHandler("evidence:dropEvidence",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Item = 1
		local Color = { 244,197,50 }

		if Mode == "red" then
			Item = 2
			Color = { 241,96,96 }
		elseif Mode == "green" then
			Item = 3
			Color = { 140,212,91 }
		elseif Mode == "blue" then
			Item = 4
			Color = { 70,140,245 }
		end

		evidenceNumber = evidenceNumber + 1
		local Coords,Grid = vCLIENT.GetPostions(source)

		if not Evidences[Grid] then
			Evidences[Grid] = {}
		end

		Evidences[Grid][tostring(evidenceNumber)] = { Coords,tostring("evidence0"..Item.."-"..Passport),Color }
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("evidence:removeEvidence")
AddEventHandler("evidence:removeEvidence",function(Id,Grid)
	if Evidences[Grid] and Evidences[Grid][tostring(Id)] then
		Evidences[Grid][tostring(Id)] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPEVIDENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("evidence:pickupEvidence")
AddEventHandler("evidence:pickupEvidence",function(Id,Grid)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Id and Grid then
		if Evidences[Grid] and Evidences[Grid][tostring(Id)] then
			local Temporary = Evidences[Grid][tostring(Id)]

			Evidences[Grid][tostring(Id)] = nil
			vRP.GiveItem(Passport,Temporary[2],1,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETEVIDENCES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetEvidences(Grid)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Grid and Evidences[Grid] then
		return Evidences[Grid]
	end

	return {}
end