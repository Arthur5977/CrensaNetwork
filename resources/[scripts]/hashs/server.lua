if not LoadResourceFile(GetCurrentResourceName(), "hash.txt") then
    SaveResourceFile(GetCurrentResourceName(), "hash.txt", "", -1)
end

RegisterServerEvent("generation")
AddEventHandler("generation", function(table, type_generation)
    SaveResourceFile(GetCurrentResourceName(), "hash.txt", "", -1)
    for k,v in pairs(table) do
        local archive = io.open(GetResourcePath(GetCurrentResourceName()).."/hash.txt","a")
        archive:write(v.."\n")
        archive:close()
    end
    TriggerClientEvent("printGeneration", source, type_generation)
end)