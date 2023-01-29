-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("plants",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Plants = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Plants",function(Coords,Route,Points)
	local Number = 0

	repeat
		Number = Number + 1
	until not Plants[tostring(Number)]

	Plants[tostring(Number)] = {
		["Coords"] = { mathLength(Coords["x"]),mathLength(Coords["y"]),mathLength(Coords["z"]) },
		["Time"] = os.time() + 10800,
		["Points"] = Points,
		["Route"] = Route
	}

	TriggerClientEvent("plants:New",-1,tostring(Number),Plants[tostring(Number)])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:COLLECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plants:Collect")
AddEventHandler("plants:Collect",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Plants[Number] then
		if (os.time() - Plants[Number]["Time"]) > 3600 then
			Plants[Number] = nil
			TriggerClientEvent("plants:Remover",-1,Number)
			TriggerClientEvent("dynamic:closeSystem",source)
			TriggerClientEvent("Notify",source,"Aviso","A plantação apodreceu.","vermelho",5000)
		else
			if os.time() >= Plants[Number]["Time"] then
				local Temporary = Plants[Number]

				if (vRP.InventoryWeight(Passport) + itemWeight("weedleaf")) <= vRP.GetWeight(Passport) then
					Plants[Number] = nil
					Player(source)["state"]["Cancel"] = true
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("dynamic:closeSystem",source)
					TriggerClientEvent("Progress",source,"Coletando",10000)
					vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

					Wait(10000)

					vRP.GenerateItem(Passport,"weedleaf-"..Temporary["Points"],1,true)
					TriggerClientEvent("plants:Remover",-1,Number)
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					vRPC.Destroy(source)
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTS:CLONING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plants:Cloning")
AddEventHandler("plants:Cloning",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Plants[Number] then
		if (os.time() - Plants[Number]["Time"]) > 3600 then
			Plants[Number] = nil
			TriggerClientEvent("plants:Remover",-1,Number)
			TriggerClientEvent("dynamic:closeSystem",source)
			TriggerClientEvent("Notify",source,"Aviso","A plantação apodreceu.","vermelho",5000)
		else
			if (Plants[Number]["Time"] - os.time()) <= 5400 then
				local Temporary = Plants[Number]

				if (vRP.InventoryWeight(Passport) + itemWeight("weedclone") * 2) <= vRP.GetWeight(Passport) then
					Plants[Number] = nil
					Player(source)["state"]["Cancel"] = true
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("dynamic:closeSystem",source)
					TriggerClientEvent("Progress",source,"Clonando",10000)
					vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

					Wait(10000)

					local Points = parseInt(Temporary["Points"]) + 1
					if Points > 100 then
						Points = 100
					end

					vRP.GenerateItem(Passport,"weedclone-"..Points,2,true)
					TriggerClientEvent("plants:Remover",-1,Number)
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					vRPC.Destroy(source)
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Informations(Number)
	if Plants[Number] then
		if (os.time() - Plants[Number]["Time"]) > 3600 then
			Plants[Number] = nil
			TriggerClientEvent("plants:Remover",-1,Number)
			TriggerClientEvent("dynamic:closeSystem",source)
			TriggerClientEvent("Notify",source,"Aviso","A plantação apodreceu.","vermelho",5000)
		else
			local Collect = "A coleta está disponível"
			if os.time() < Plants[Number]["Time"] then
				Collect = "Aguarde "..Calculate(Plants[Number]["Time"] - os.time())
			end

			local Cloning = "A clonagem está disponível"
			if (Plants[Number]["Time"] - os.time()) > 5400 then
				Cloning = "Aguarde "..Calculate(Plants[Number]["Time"] - os.time() - 5400)
			end

			return { Collect,Cloning }
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer",function(Silenced)
	vRP.SetSrvData("Plants",Plants)

	if not Silenced then
		print("O resource Plants salvou os dados.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Plants = vRP.GetSrvData("Plants")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("plants:Table",source,Plants)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALCULATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Calculate(Seconds)
	local Days = math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	local Hours = math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	if Days > 0 then
		return string.format("%d Dia, %d Hora, %d Minutos",Days,Hours,Minutes)
	elseif Hours > 0 then
		return string.format("%d Hora, %d Minutos e %d Segundos",Hours,Minutes,Seconds)
	elseif Minutes > 0 then
		return string.format("%d Minutos e %d Segundos",Minutes,Seconds)
	elseif Seconds > 0 then
		return string.format("%d Segundos",Seconds)
	end
end