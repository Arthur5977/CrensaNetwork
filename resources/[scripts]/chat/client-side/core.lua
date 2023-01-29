-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Chat",function()
	if not IsPauseMenuActive() then
		SetNuiFocus(true,true)
		SetCursorLocation(0.15,0.36)

		local Tags = {}
		for Index,v in pairs(ClientState) do
			if LocalPlayer["state"][Index] then
				Tags[#Tags + 1] = Index
			end
		end

		SendNUIMessage({ Action = "Chat", Data = Tags, Block = Block })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:ClientMessage")
AddEventHandler("chat:ClientMessage",function(Author,Message,Mode)
	SendNUIMessage({ Action = "Message", Author = Author, Message = Message, Type = Mode })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATSUBMIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatSubmit",function(Data,Callback)
	SetNuiFocus(false,false)
	if Data["message"] ~= "" and MumbleIsConnected() then
		if Data["message"]:sub(1,1) == "/" then
			ExecuteCommand(Data["message"]:sub(2))
		else
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) > 100 then
                if #Data["message"] > 255 then
                    TriggerEvent("Notify","vermelho","Mensagem muito longa.",5000)
                    return
                else
                    TriggerServerEvent("chat:ServerMessage",Data["tag"],Data["message"])
                end
			end
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Chat","Abrir o chat.","keyboard","T")