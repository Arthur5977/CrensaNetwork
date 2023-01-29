local vehiclesClass = {
    [7] = 'carros',
    [8] = 'motos',
    [9] = 'carros',
    [13] = 'bike',
    [12] = 'utilitario',
    [14] = 'barcos',
    [15] = 'helicopteros',
    [16] = 'avioes',
    [20] = 'serviço'
  }
function getVehicleClass(model)
    local retval = GetVehicleClassFromName(GetHashKey(model))
    return vehiclesClass[retval] or 'outros'
end

local vehiclesWeight = {
    ['carros'] = '60',
    ['motos'] = '20',
    ['carros'] = '75',
    ['bike'] = '2',
    ['utilitario'] = '250',
    ['barcos'] = '50',
    ['helicopteros'] = '20',
    ['avioes'] = '350',
    ['serviço'] = '300'
}
function getVehicleWeight(type)
    return vehiclesWeight[type] or '15'
end

function modules()
    local veh = GetAllVehicleModels()
    local tabela = {}

    for k,v in pairs(veh) do
        local type_veh = getVehicleClass(v)
        local price_veh = GetVehicleModelValue(v)
        table.insert(tabela,("['"..v.."'] = { ['name'] = '"..v.."', ['price'] = "..price_veh..", ['tipo'] = '"..type_veh.."' },"))
    end
    TriggerServerEvent("generation",tabela, "modules")
end

function client()
    local veh = GetAllVehicleModels()
    local tabela = {}
    for k,v in pairs(veh) do
        local hash_veh = GetHashKey(v)
        table.insert(tabela,("{ ['name'] = '"..v.."', ['hash'] = "..hash_veh..", ['banned'] = false },"))
    end
    TriggerServerEvent("generation",tabela, "client")
end

function nation()
    local veh = GetAllVehicleModels()
    local tabela = {}
    for k,v in pairs(veh) do
        local hash_veh = GetHashKey(v)
        local price_veh = GetVehicleModelValue(v)
        local type_veh = getVehicleClass(v)
        local weight_veh = getVehicleWeight(type_veh)
        table.insert(tabela,("{ hash = "..hash_veh..", name = '"..v.."', price = "..price_veh..", banido = false, modelo = '"..v.."', capacidade = "..weight_veh..", tipo = '"..type_veh.."' },"))
    end
    TriggerServerEvent("generation",tabela, "nation")
end

RegisterCommand("gerar",function(source,args,rawCommand)
    if args[1] == "modules" then
        modules()
    elseif args[1] == "client" then
        client()
    elseif args[1] == "nation" then
        nation()
    else
        print("^5[UNDERGROUND] ^1ERROR ^7tipo inexistente. ^5[ TIPOS DE GERAÇÃO : ^2nation^5, ^2client^5, ^2modules^5 ]^7")
    end
end)

RegisterNetEvent("printGeneration")
AddEventHandler("printGeneration", function(types, lines)
    print("^5[UNDERGROUND]^7 Lista de veiculos gerada com sucesso. ^5[ TIPO DE GERAÇÃO : ^2"..types.."^5 ]^7")
end)
