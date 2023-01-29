-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = {}
local Objects = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("objects:Table")
AddEventHandler("objects:Table",function(Table)
	Objects = Table

	for k,v in pairs(Objects) do
        if tonumber(k) <= 61 then
			local Blip = AddBlipForRadius(v["x"],v["y"],v["z"],10.0)
			SetBlipAlpha(Blip,200)
			SetBlipColour(Blip,2)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS:ADICIONAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("objects:Adicionar")
AddEventHandler("objects:Adicionar",function(Number,Table)
	Objects[Number] = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function targetLabel(x,y,z,Number,Item,Mode,Perm)
	if Mode == "Spray" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 1.5,
			options = {
				{
					event = "objects:Guardar",
					label = "Remover",
					tunnel = "shop"
				}
			}
		})
	elseif Mode == "1" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 1.5,
			options = {
				{
					event = "objects:Guardar",
					label = "Guardar",
					tunnel = "shop"
				},{
					event = "inventory:MakeProducts",
					label = "Produzir",
					tunnel = "products",
					service = Item
				}
			}
		})
	elseif Mode == "2" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 2.5,
			options = {
				{
					event = "inventory:MakeProducts",
					label = "Cozinhar Filé de Peixe",
					tunnel = "police",
					service = "fishfillet"
				},{
					event = "inventory:MakeProducts",
					label = "Cozinhar Carne Animal",
					tunnel = "police",
					service = "animalmeat"
				},{
					event = "inventory:MakeProducts",
					label = "Assar Marshmallow",
					tunnel = "police",
					service = "marshmallow"
				}
			}
		})
	elseif Mode == "3" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 1.5,
			options = {
				{
					event = "objects:Guardar",
					label = "Guardar",
					tunnel = "shop"
				}
			}
		})
	elseif Mode == "4" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 1.5,
			options = {
				{
					event = "objects:Guardar",
					label = "Guardar",
					tunnel = "shop"
				},{
					event = "shops:Medic",
					label = "Abrir",
					tunnel = "client"
				}
			}
		})
	elseif Mode == "Medic" or Mode == "Weapons" or Mode == "Supplies" then
		exports["target"]:AddCircleZone("Objects:"..Number,vec3(x,y,z),0.75,{
			name = "Objects:"..Number,
			heading = 3374176,
			useZ = true
		},{
			shop = Number,
			Distance = 1.5,
			options = {
				{
					event = "inventory:Loot",
					label = "Abrir",
					tunnel = "shop",
					service = Mode
				}
			}
		})
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number,v in pairs(Objects) do
			local Distance = #(Coords - vec3(v["x"],v["y"],v["z"]))
			if Distance <= v["Distance"] then
				if Init[Number] == nil then
					local mHash = GetHashKey(v["object"])

					RequestModel(mHash)
					while not HasModelLoaded(mHash) do
						Wait(1)
					end

					if HasModelLoaded(mHash) then
						if v["mode"] then
							targetLabel(v["x"],v["y"],v["z"],Number,v["item"],v["mode"],v["perm"])
						end

						Init[Number] = CreateObjectNoOffset(mHash,v["x"],v["y"],v["z"],false,false,false)
						FreezeEntityPosition(Init[Number],true)
						SetEntityHeading(Init[Number],v["h"])
						SetEntityLodDist(Init[Number],0xFFFF)
						SetModelAsNoLongerNeeded(mHash)
					end
				end
			else
				if Init[Number] then
					exports["target"]:RemCircleZone("Objects:"..Number)

					if DoesEntityExist(Init[Number]) then
						DeleteEntity(Init[Number])
						Init[Number] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS:GUARDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("objects:Guardar")
AddEventHandler("objects:Guardar",function(Number)
	TriggerEvent("inventory:StoreObjects",Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("objects:Remover")
AddEventHandler("objects:Remover",function(Number)
	Objects[Number] = nil

	if Init[Number] then
		exports["target"]:RemCircleZone("Objects:"..Number)

		if DoesEntityExist(Init[Number]) then
			DeleteEntity(Init[Number])
			Init[Number] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local Rotation = GetGameplayCamRot()
	local Adjusted = vec3((math.pi / 180) * Rotation["x"],(math.pi / 180) * Rotation["y"],(math.pi / 180) * Rotation["z"])
	local Direction = vec3(-math.sin(Adjusted[3]) * math.abs(math.cos(Adjusted[1])),math.cos(Adjusted[3]) * math.abs(math.cos(Adjusted[1])),math.sin(Adjusted[1]))

	return vec3(Coords[1] + Direction[1] * Distance, Coords[2] + Direction[2] * Distance, Coords[3] + Direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.objectCoords(Model)
	local Ped = PlayerPedId()
	local Progress = true
	local Aplication = false
	local mHash = GetHashKey(Model)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	local Coords = GetEntityCoords(Ped)
	local Heading = GetEntityHeading(Ped)
	local NextObject = CreateObjectNoOffset(mHash,Coords["x"],Coords["y"],Coords["z"],false,false,false)
	SetEntityCollision(NextObject,false,false)
	SetEntityHeading(NextObject,Heading)
	SetEntityAlpha(NextObject,100,false)
	SetModelAsNoLongerNeeded(mHash)

	while Progress do
		local Ped = PlayerPedId()
		local Cam = GetGameplayCamCoord()
		local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam,GetCoordsFromCam(10.0,Cam),-1,Ped,4)
		local _,_,Coords = GetShapeTestResult(Handle)

		if Model == "prop_ld_binbag_01" then
			SetEntityCoords(NextObject,Coords["x"],Coords["y"],Coords["z"] + 0.9,false,false,false,false)
		else
			SetEntityCoords(NextObject,Coords["x"],Coords["y"],Coords["z"],false,false,false,false)
		end

		DwText("~g~F~w~  CANCELAR",4,0.015,0.86,0.38,255,255,255,255)
		DwText("~g~E~w~  COLOCAR OBJETO",4,0.015,0.89,0.38,255,255,255,255)
		DwText("~y~SCROLL UP~w~  GIRA ESQUERDA",4,0.015,0.92,0.38,255,255,255,255)
		DwText("~y~SCROLL DOWN~w~  GIRA DIREITA",4,0.015,0.95,0.38,255,255,255,255)

		if IsControlJustPressed(1,38) then
			Aplication = true
			Progress = false
		end

		if IsControlJustPressed(0,49) then
			Progress = false
		end

		if IsControlJustPressed(0,180) then
			local ObjectHeading = GetEntityHeading(NextObject)
			SetEntityHeading(NextObject,ObjectHeading + 2.5)
		end

		if IsControlJustPressed(0,181) then
			local ObjectHeading = GetEntityHeading(NextObject)
			SetEntityHeading(NextObject,ObjectHeading - 2.5)
		end

		Wait(1)
	end

	local ObjectCoords = GetEntityCoords(NextObject)
	local ObjectHeading = GetEntityHeading(NextObject)

	DeleteEntity(NextObject)

	return Aplication,ObjectCoords,ObjectHeading
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DwText(Text,Font,x,y,Scale,R,G,B,A)
	SetTextFont(Font)
	SetTextScale(Scale,Scale)
	SetTextColour(R,G,B,A)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(Text)
	DrawText(x,y)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:EXPLOSION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Explosion")
AddEventHandler("vRP:Explosion",function(Coords)
	AddExplosion(Coords,2,1.0,true,false,false)
end)