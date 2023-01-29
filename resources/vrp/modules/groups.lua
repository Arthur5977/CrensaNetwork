-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local permList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Admin"] = 0
GlobalState["Policia"] = 0
GlobalState["Mecanico"] = 0
GlobalState["Paramedico"] = 0
GlobalState["PizzaThis"] = 0
GlobalState["UwuCoffee"] = 0
GlobalState["BeanMachine"] = 0
GlobalState["Ballas"] = 0
GlobalState["Vagos"] = 0
GlobalState["Families"] = 0
GlobalState["Aztecas"] = 0
GlobalState["Bloods"] = 0
GlobalState["Triads"] = 0
GlobalState["Razors"] = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.NumPermission(Permission)
	return permList[Permission]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceEnter(source,Passport,Permission)
	if GroupBlips[Permission] then
		Player(source)["state"][Permission] = true
		GlobalState[Permission] = GlobalState[Permission] + 1
		TriggerEvent("blipsystem:Enter",source,Permission,true)
	end

	if GroupSalary[Permission] then
		TriggerEvent("Salary:Add",Passport,Permission)
	end

	vRP.SetPermission(Passport,Permission)
	vRP.RemovePermission(Passport,"wait"..Permission)
	TriggerClientEvent("Notify",source,"Sucesso","Entrou em Serviço.","verde",5000)
	TriggerClientEvent("service:Label",source,Permission,"Sair de Serviço",5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICELEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceLeave(source,Passport,Permission)
	if GroupBlips[Permission] then
		TriggerEvent("blipsystem:Exit",source)
		Player(source)["state"][Permission] = false
		TriggerClientEvent("radio:RadioClean",source)
		GlobalState[Permission] = GlobalState[Permission] - 1
	end

	if GroupSalary[Permission] then
		TriggerEvent("Salary:Remove",Passport,Permission)
	end

	TriggerClientEvent("service:Label",source,Permission,"Entrar em Serviço",5000)
	TriggerClientEvent("Notify",source,"Atenção","Saiu de serviço.","amarelo",5000)
	vRP.SetPermission(Passport,"wait"..Permission)
	vRP.RemovePermission(Passport,Permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Groups()
	return Groups
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATAGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DataGroups(Group)
	return vRP.GetSrvData("Permissions:"..Group)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasPermission(Passport,Permission)
	if vRP.GetSrvData("Permissions:"..Permission)[tostring(Passport)] then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPermission(Passport,Permission)
	vRP.GetSrvData("Permissions:"..Permission)[tostring(Passport)] = true
	vRP.SetSrvData("Permissions:"..Permission,(vRP.GetSrvData("Permissions:"..Permission)))

	if vRP.Source(Passport) then
		permList[Permission][tostring(Passport)] = vRP.Source(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemovePermission(Passport,Permission)
	if permList[Permission][Passport] then
		permList[Permission][Passport] = nil
	end

	if vRP.GetSrvData("Permissions:"..Permission)[tostring(Passport)] then
		vRP.GetSrvData("Permissions:"..Permission)[tostring(Passport)] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasGroup(Passport,Permission)
	if Groups[Permission] then
		for k,v in pairs(Groups[Permission]) do
			if vRP.GetSrvData("Permissions:"..k)[tostring(Passport)] then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(Groups) do
		permList[k] = {}
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	for k,v in pairs(Groups) do
		if GroupBlips[k] and vRP.HasPermission(Passport,k) then
			vRP.ServiceEnter(source,Passport,k)
		end
	end

	if vRP.HasGroup(Passport,"Ballas") then
		TriggerClientEvent("player:Relationship",source,"Ballas")
	end

	if vRP.HasGroup(Passport,"Families") then
		TriggerClientEvent("player:Relationship",source,"Families")
	end

	if vRP.HasGroup(Passport,"Vagos") then
		TriggerClientEvent("player:Relationship",source,"Vagos")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	for k,v in pairs(permList) do
		if permList[k][Passport] then
			if GroupBlips[k] then
				TriggerEvent("blipsystem:Exit",source)
			end

			if GroupSalary[k] then
				TriggerEvent("Salary:Remove",Passport,k)
			end

			permList[k][Passport] = nil
		end
	end

	for k,v in pairs(Groups) do
		if GroupBlips[k] and vRP.HasPermission(Passport,k) then
			GlobalState[k] = GlobalState[k] - 1
		end
	end
end)