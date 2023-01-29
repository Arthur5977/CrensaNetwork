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
Tunnel.bindInterface("service",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Panel = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Split = splitString(Service,"-")
		local Permission = Split[1]

		if vRP.HasPermission(Passport,Permission) then
			vRP.ServiceLeave(source,Passport,Permission)
		elseif vRP.HasPermission(Passport,"wait"..Permission) then
			vRP.ServiceEnter(source,Passport,Permission)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("painel",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		if vRP.HasPermission(Passport,"set"..Message[1]) then
			Panel[Passport] = Message[1]
			TriggerClientEvent("service:Open",source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Request()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] then
		local Members = {}
		local Sources = vRP.Players()
		local Entitys = vRP.DataGroups(Panel[Passport])

		for Number,_ in pairs(Entitys) do
			local Number = parseInt(Number)
			local Identity = vRP.Identity(Number)
			if Identity then
				table.insert(Members,{ ["Name"] = Identity["name"].." "..Identity["name2"], ["Phone"] = Identity["phone"], ["Status"] = Sources[Number], ["Passport"] = Number })
			end
		end

		if Panel[Passport] == "Policia" or Panel[Passport] == "Paramedico" then
			local Entitys = vRP.DataGroups("wait"..Panel[Passport])

			for Number,_ in pairs(Entitys) do
				local Number = parseInt(Number)
				local Identity = vRP.Identity(Number)
				if Identity then
					table.insert(Members,{ ["Name"] = Identity["name"].." "..Identity["name2"], ["Phone"] = Identity["phone"], ["Status"] = Sources[Number], ["Passport"] = Number })
				end
			end
		end

		return Members
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("service:Remove")
AddEventHandler("service:Remove",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and Number > 1 and Passport ~= Number then
		if vRP.HasPermission(Passport,"set"..Panel[Passport]) then
			vRP.RemovePermission(Number,Panel[Passport])
			vRP.RemovePermission(Number,"wait"..Panel[Passport])

			TriggerClientEvent("service:Update",source)
			TriggerClientEvent("Notify",source,"Aviso","Passaporte removido.","verde",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("service:Add")
AddEventHandler("service:Add",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and Number > 1 and Passport ~= Number and vRP.Identity(Number) then
		if vRP.HasPermission(Passport,"set"..Panel[Passport]) then
			vRP.RemovePermission(Number,Panel[Passport])
			vRP.RemovePermission(Number,"wait"..Panel[Passport])

			vRP.SetPermission(Number,Panel[Passport])
			TriggerClientEvent("Notify",source,"Aviso","Passaporte adicionado.","verde",5000)
			TriggerClientEvent("service:Update",source)
		end
	end
end)