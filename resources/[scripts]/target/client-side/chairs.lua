-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chairs = {
	[-1235256368] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.0, ["Heading"] = 90.0 },
	[538002882] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = -0.1, ["Heading"] = 180.0 },
	[-1118419705] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[-377849416] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[-109356459] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[-1692811878] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[-729914417] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[1577885496] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[1889748069] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[1816935351] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[1037469683] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.4, ["Heading"] = 180.0 },
	[536071214] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
	[438342263] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.25, ["Heading"] = 180.0 },
	[2129125614] = { ["OffsetX"] = 0.0, ["OffsetY"] = 0.0, ["OffsetZ"] = 0.5, ["Heading"] = 180.0 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SITCHAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
local SitChairs = {
	-- PizzaThis
	{ ["Coords"] = vec3(808.50,-755.33,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(808.50,-754.45,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(806.95,-755.33,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(806.95,-754.49,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(806.38,-755.42,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(806.38,-754.52,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(804.85,-755.42,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(804.85,-754.44,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(804.28,-755.32,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(804.28,-754.50,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(802.75,-755.45,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(802.75,-754.45,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(802.2,-755.28,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(802.2,-754.39,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(800.64,-755.34,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(800.64,-754.50,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(799.34,-756.80,26.28), ["Heading"] = 180 },
	{ ["Coords"] = vec3(799.33,-758.38,26.28), ["Heading"] = 0 },
	{ ["Coords"] = vec3(799.43,-758.97,26.28), ["Heading"] = 180 },
	{ ["Coords"] = vec3(799.43,-760.52,26.28), ["Heading"] = 0 },
	{ ["Coords"] = vec3(808.13,-751.56,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(806.01,-751.53,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(804.23,-751.53,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(802.05,-751.59,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(800.12,-751.51,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(798.04,-751.58,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(799.06,-748.86,26.28), ["Heading"] = 90 },
	{ ["Coords"] = vec3(796.97,-748.79,26.28), ["Heading"] = 270 },
	{ ["Coords"] = vec3(799.48,-754.09,26.28), ["Heading"] = 160 },
	{ ["Coords"] = vec3(799.50,-756.05,26.28), ["Heading"] = 5 },
	{ ["Coords"] = vec3(795.12,-750.46,26.28), ["Heading"] = 205 },
	{ ["Coords"] = vec3(795.22,-752.64,26.28), ["Heading"] = 355 },
	-- UwuCafé
	{ ["Coords"] = vec3(-573.94,-1058.86,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.04,-1058.84,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.9,-1060.65,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-573.07,-1060.69,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-573.86,-1062.48,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.06,-1062.45,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.86,-1064.31,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-573.06,-1064.28,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-573.9,-1066.19,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.02,-1066.16,21.99), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-573.95,-1068.02,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-573.1,-1068.05,21.99), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-577.58,-1052.5,21.85), ["Heading"] = 42.41 },
	{ ["Coords"] = vec3(-579.69,-1052.49,21.85), ["Heading"] = 329 },
	{ ["Coords"] = vec3(-580.83,-1050.91,21.85), ["Heading"] = 267 },
	{ ["Coords"] = vec3(-576.91,-1050.75,21.85), ["Heading"] = 108.24 },
	{ ["Coords"] = vec3(-591.26,-1049.2,21.85), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-590.56,-1049.16,21.85), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-589.81,-1049.12,21.85), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-598.29,-1050.07,21.85), ["Heading"] = 268 },
	{ ["Coords"] = vec3(-598.28,-1050.97,21.85), ["Heading"] = 268 },
	{ ["Coords"] = vec3(-573.58,-1053.56,26.07), ["Heading"] = 270 },
	{ ["Coords"] = vec3(-573.6,-1052.84,26.07), ["Heading"] = 270 },
	{ ["Coords"] = vec3(-573.58,-1052.08,26.07), ["Heading"] = 270 },
	{ ["Coords"] = vec3(-569.87,-1066.14,26.07), ["Heading"] = 90 },
	{ ["Coords"] = vec3(-569.85,-1066.92,26.07), ["Heading"] = 90 },
	{ ["Coords"] = vec3(-569.89,-1067.76,26.07), ["Heading"] = 90 },
	{ ["Coords"] = vec3(-569.87,-1068.54,26.07), ["Heading"] = 90 },
	{ ["Coords"] = vec3(-571.01,-1069.26,26.07), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-572.6,-1069.26,26.07), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-577.0,-1062.51,26.07), ["Heading"] = 0 },
	{ ["Coords"] = vec3(-578.7,-1058.0,26.07), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-578.0,-1058.02,26.07), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-577.28,-1058.03,26.07), ["Heading"] = 180 },
	{ ["Coords"] = vec3(-577.12,-1065.24,26.07), ["Heading"] = 165 },
	{ ["Coords"] = vec3(-578.79,-1065.32,26.07), ["Heading"] = 200 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(SitChairs) do
		AddBoxZone("SitChairs:"..Number,v["Coords"],0.35,0.35,{
			name = "SitChairs:"..Number,
			heading = v["Heading"],
			minZ = v["Coords"]["z"] - 0.1,
			maxZ = v["Coords"]["z"]
		},{
			shop = Number,
			Distance = 5.25,
			options = {
				{
					event = "target:SitChair",
					label = "Sentar",
					tunnel = "client"
				}
			}
		})
	end

	AddTargetModel({ -1235256368,538002882,-1118419705,-377849416,-109356459,-1692811878,-729914417,1577885496,1889748069,1816935351,1037469683,536071214,438342263,2129125614 },{
		options = {
			{
				event = "target:Chair",
				label = "Sentar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SITCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:SitChair")
AddEventHandler("target:SitChair",function(Number)
	if not Previous then
		local Ped = PlayerPedId()
		local Coords = SitChairs[Number]["Coords"]
		TaskStartScenarioAtPosition(Ped,"PROP_HUMAN_SEAT_CHAIR_UPRIGHT",Coords["x"],Coords["y"],Coords["z"],SitChairs[Number]["Heading"] + 1.0,-1,true,true)
		Previous = GetEntityCoords(Ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpChair")
AddEventHandler("target:UpChair",function()
	if Previous then
		local Ped = PlayerPedId()
		SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
		FreezeEntityPosition(Ped,false)
		Previous = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Chair")
AddEventHandler("target:Chair",function(Vars)
	local Model = Vars[2]
	local Entitys = Vars[1]
	local Ped = PlayerPedId()

	if Chairs[Model] then
		FreezeEntityPosition(Ped,false)
		FreezeEntityPosition(Entitys,true)

		Previous = GetEntityCoords(Ped)
		SetEntityCoords(Ped,Vars[4]["x"],Vars[4]["y"],Vars[4]["z"] + 0.5)
		SetEntityHeading(Ped,GetEntityHeading(Entitys) - Chairs[Model]["Heading"])

		TaskStartScenarioAtPosition(Ped,"PROP_HUMAN_SEAT_CHAIR_UPRIGHT",Vars[4]["x"] + Chairs[Model]["OffsetX"],Vars[4]["y"] + Chairs[Model]["OffsetY"],Vars[4]["z"] + Chairs[Model]["OffsetZ"],GetEntityHeading(Entitys) - Chairs[Model]["Heading"],0,true,true)
	end
end)