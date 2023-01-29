-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
REQUEST = Tunnel.getInterface("request")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVICE_REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("smartphone:service_request",function(Data)
	local Answered = false
	local Service = vRP.NumPermission(Data["service"]["permission"])

	for Passport,Sources in pairs(Service) do
		async(function()
			TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Chamado de "..Data["name"], text = Data["content"], x = Data["location"][1], y = Data["location"][2], z = Data["location"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 2 })

			if vRP.Request(Sources,"Aceitar o chamado de <b>"..Data["name"].."?","Sim","Não") then
				if not Answered then
					Answered = true
					TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_RESPONSE",{})
					TriggerClientEvent("smartphone:pusher",Sources,"GPS",{ location = Data["location"] })
				else
					TriggerClientEvent("Notify",Sources,"Sucesso","Chamado atendido.","verde",5000)
				end
			end
		end)
	end

	SetTimeout(30000,function()
		if not Answered then
			TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_REJECT",{})
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Request(source,Message,Accept,Reject)
	return REQUEST.Function(source,Message,Accept or "Sim",Reject or "Não")
end