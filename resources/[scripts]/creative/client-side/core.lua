-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {
	{ 1239.87,-3257.2,7.09,67,62,"Caminhoneiro",0.5 },
	{ 280.38,-584.45,43.29,80,38,"Hospital",0.5 },
	{ -247.42,6331.39,32.42,80,38,"Hospital",0.5 },
	{ 1185.21,-1461.05,34.88,106,38,"Bombeiros",0.5 },
	{ 55.43,-876.19,30.66,357,65,"Garagem",0.6 },
	{ 598.04,2741.27,42.07,357,65,"Garagem",0.6 },
	{ -136.36,6357.03,31.49,357,38,"Garagem",0.6 },
	{ 275.23,-345.54,45.17,357,65,"Garagem",0.6 },
	{ 596.40,90.65,93.12,357,65,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,65,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,65,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,65,"Garagem",0.6 },
	{ 214.02,-808.44,31.01,357,65,"Garagem",0.6 },
	{ -348.88,-874.02,31.31,357,65,"Garagem",0.6 },
	{ 67.74,12.27,69.21,357,65,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,65,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,65,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,65,"Garagem",0.6 },
	{ 453.27,-1146.76,29.52,357,65,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,65,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,65,"Garagem",0.6 },
	{ 101.22,-1073.68,29.38,357,65,"Garagem",0.6 },
	{ 1725.21,4711.77,42.11,357,65,"Garagem",0.6 },
	{ 1624.05,3566.14,35.15,357,38,"Garagem",0.6 },
	{ -73.35,-2004.6,18.27,357,65,"Garagem",0.6 },
	{ 824.66,-1290.05,28.22,60,18,"Departamento Policial",0.6 },
	{ 426.57,-981.71,30.7,60,18,"Departamento Policial",0.6 },
	{ 1839.67,3667.94,33.87,60,18,"Departamento Policial",0.6 },
	{ -448.18,6011.68,31.71,60,18,"Departamento Policial",0.6 },
	{ 387.0,787.88,187.47,60,18,"Departamento Policial",0.6 },
	{ 382.92,-1590.65,29.27,60,18,"Departamento Policial",0.6 },
	{ 29.2,-1351.89,29.34,52,36,"Loja de Departamento",0.5 },
	{ 2561.74,385.22,108.61,52,36,"Loja de Departamento",0.5 },
	{ 1160.21,-329.4,69.03,52,36,"Loja de Departamento",0.5 },
	{ -711.99,-919.96,19.01,52,36,"Loja de Departamento",0.5 },
	{ -54.56,-1758.56,29.05,52,36,"Loja de Departamento",0.5 },
	{ 375.87,320.04,103.42,52,36,"Loja de Departamento",0.5 },
	{ -3237.48,1004.72,12.45,52,36,"Loja de Departamento",0.5 },
	{ 1730.64,6409.67,35.0,52,36,"Loja de Departamento",0.5 },
	{ 543.51,2676.85,42.14,52,36,"Loja de Departamento",0.5 },
	{ 1966.53,3737.95,32.18,52,36,"Loja de Departamento",0.5 },
	{ 2684.73,3281.2,55.23,52,36,"Loja de Departamento",0.5 },
	{ 1696.12,4931.56,42.07,52,36,"Loja de Departamento",0.5 },
	{ -1820.18,785.69,137.98,52,36,"Loja de Departamento",0.5 },
	{ 1395.35,3596.6,34.86,52,36,"Loja de Departamento",0.5 },
	{ -2977.14,391.22,15.03,52,36,"Loja de Departamento",0.5 },
	{ -3034.99,590.77,7.8,52,36,"Loja de Departamento",0.5 },
	{ 1144.46,-980.74,46.19,52,36,"Loja de Departamento",0.5 },
	{ 1166.06,2698.17,37.95,52,36,"Loja de Departamento",0.5 },
	{ -1493.12,-385.55,39.87,52,36,"Loja de Departamento",0.5 },
	{ -1228.6,-899.7,12.27,52,36,"Loja de Departamento",0.5 },
	{ 157.82,6631.8,31.68,52,36,"Loja de Departamento",0.5 },
	{ -154.06,6329.28,31.56,52,36,"Loja de Departamento",0.5 },
	{ 817.24,-785.81,26.18,52,36,"Loja de Departamento",0.5 },
	{ 1702.78,3748.82,34.05,76,6,"Loja de Armas",0.4 },
	{ 240.06,-43.74,69.71,76,6,"Loja de Armas",0.4 },
	{ 843.95,-1020.43,27.53,76,6,"Loja de Armas",0.4 },
	{ -322.19,6072.86,31.27,76,6,"Loja de Armas",0.4 },
	{ -664.03,-949.22,21.53,76,6,"Loja de Armas",0.4 },
	{ -1318.83,-389.19,36.43,76,6,"Loja de Armas",0.4 },
	{ -1110.11,2687.5,18.62,76,6,"Loja de Armas",0.4 },
	{ 2569.23,309.46,108.46,76,6,"Loja de Armas",0.4 },
	{ -3159.91,1080.64,20.69,76,6,"Loja de Armas",0.4 },
	{ 15.42,-1120.47,28.81,76,6,"Loja de Armas",0.4 },
	{ 811.81,-2145.58,29.34,76,6,"Loja de Armas",0.4 },
	{ -815.12,-184.15,37.57,71,62,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,62,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,62,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,62,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,62,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,62,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,62,"Barbearia",0.5 },
	{ -1117.26,-1438.74,5.11,366,62,"Loja de Roupas",0.5 },
	{ 86.06,-1391.64,29.23,366,62,"Loja de Roupas",0.5 },
	{ -719.94,-158.18,37.0,366,62,"Loja de Roupas",0.5 },
	{ -152.79,-306.79,38.67,366,62,"Loja de Roupas",0.5 },
	{ -816.39,-1081.22,11.12,366,62,"Loja de Roupas",0.5 },
	{ -1206.51,-781.5,17.12,366,62,"Loja de Roupas",0.5 },
	{ -1458.26,-229.79,49.2,366,62,"Loja de Roupas",0.5 },
	{ -2.41,6518.29,31.48,366,62,"Loja de Roupas",0.5 },
	{ 1682.59,4819.98,42.04,366,62,"Loja de Roupas",0.5 },
	{ 129.46,-205.18,54.51,366,62,"Loja de Roupas",0.5 },
	{ 618.49,2745.54,42.01,366,62,"Loja de Roupas",0.5 },
	{ 1197.93,2698.21,37.96,366,62,"Loja de Roupas",0.5 },
	{ -3165.74,1061.29,20.84,366,62,"Loja de Roupas",0.5 },
	{ -1093.76,2703.99,19.04,366,62,"Loja de Roupas",0.5 },
	{ 414.86,-807.57,29.34,366,62,"Loja de Roupas",0.5 },
	{ -1728.06,-1050.69,1.71,356,62,"Embarcações",0.6 },
	{ -776.72,-1495.02,2.29,356,62,"Embarcações",0.6 },
	{ -893.97,5687.78,3.29,356,62,"Embarcações",0.6 },
	{ 1509.64,3788.7,33.51,356,62,"Embarcações",0.6 },
	{ 356.42,274.61,103.14,67,62,"Transportador",0.5 },
	{ 2433.45,5013.46,46.99,285,62,"Lenhador",0.5 },
	{ -172.21,6385.85,31.49,403,5,"Farmácia",0.7 },
	{ 1690.07,3581.68,35.62,403,5,"Farmácia",0.7 },
	{ 315.12,-1068.58,29.39,403,5,"Farmácia",0.7 },
	{ 114.45,-4.89,67.82,403,5,"Farmácia",0.7 },
	{ 46.66,-1749.79,29.64,78,11,"Mercado Central",0.5 },
	{ 2747.28,3473.04,55.67,78,11,"Mercado Central",0.5 },
	{ 82.54,-1553.28,29.59,318,62,"Lixeiro",0.6 },
	{ 287.36,2843.6,44.7,318,62,"Lixeiro",0.6 },
	{ -413.97,6171.58,31.48,318,62,"Lixeiro",0.6 },
	{ -428.56,-1728.33,19.79,467,11,"Reciclagem",0.6 },
	{ 180.07,2793.29,45.65,467,11,"Reciclagem",0.6 },
	{ -195.42,6264.62,31.49,467,11,"Reciclagem",0.6 },
	{ -142.24,-1174.19,23.76,357,9,"Impound",0.6 },
	{ 800.87,-821.43,26.18,402,26,"Mecânica",0.7 },
	{ 1174.98,2640.4,37.74,402,26,"Mecânica",0.7 },
	{ 110.63,6626.54,31.78,402,26,"Mecânica",0.7 },
	{ 713.02,164.22,80.74,354,47,"Departamento de Energia",0.9 },
	{ 2953.93,2787.49,41.5,617,62,"Minerador",0.6 },
	{ 562.3,2741.61,42.87,273,10,"Animal Ark",0.6 },
	{ 1322.93,-1652.29,52.27,75,13,"Loja de Tatuagem",0.5 },
	{ -1154.42,-1425.9,4.95,75,13,"Loja de Tatuagem",0.5 },
	{ 322.84,180.16,103.58,75,13,"Loja de Tatuagem",0.5 },
	{ -3169.62,1075.8,20.83,75,13,"Loja de Tatuagem",0.5 },
	{ 1864.07,3747.9,33.03,75,13,"Loja de Tatuagem",0.5 },
	{ -293.57,6199.85,31.48,75,13,"Loja de Tatuagem",0.5 },
	{ 2057.89,5109.83,46.34,76,62,"Agricultor: Frutas",0.4 },
	{2281.31,5067.08,45.98,76,62,"Agricultor: Trigo",0.4 },
	{ -580.93,-1074.92,22.33,408,62,"UwU Café",0.6 },
	{ 789.67,-758.2,26.72,408,62,"Pizza This",0.6 },
	{ 117.06,-1021.67,29.28,408,62,"Bean Machine",0.6 },
	{ -70.49,-1104.59,26.12,225,62,"Concessionária",0.4 },
	{ 1225.05,2724.07,38.0,225,62,"Concessionária",0.4 },
	{ 919.38,-182.83,74.02,198,62,"Taxista",0.5 },
	{ 1696.19,4785.25,42.02,198,62,"Taxista",0.5 },
	{ -680.9,5832.41,17.32,141,62,"Caçador",0.7 },
	{ -535.04,-221.34,37.64,267,5,"Prefeitura",0.6 },
	{ 918.69,50.33,80.9,617,62,"Cassino",0.6 },
	{ 454.73,-600.83,28.56,513,62,"Motorista",0.6 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleport = {
	{ vec3(330.19,-601.21,43.29),vec3(343.65,-581.77,28.8) },
	{ vec3(343.65,-581.77,28.8),vec3(330.19,-601.21,43.29) },

	{ vec3(327.16,-603.53,43.29),vec3(338.97,-583.85,74.16) },
	{ vec3(338.97,-583.85,74.16),vec3(327.16,-603.53,43.29) },

	{ vec3(-741.07,5593.13,41.66),vec3(446.19,5568.79,781.19) },
	{ vec3(446.19,5568.79,781.19),vec3(-741.07,5593.13,41.66) },

	{ vec3(-740.78,5597.04,41.66),vec3(446.37,5575.02,781.19) },
	{ vec3(446.37,5575.02,781.19),vec3(-740.78,5597.04,41.66) },

	{ vec3(-71.05,-801.01,44.23),vec3(-75.0,-824.54,321.29) },
	{ vec3(-75.0,-824.54,321.29),vec3(-71.05,-801.01,44.23) },

	{ vec3(236.23,229.27,97.11),vec3(234.24,229.94,97.11) },
	{ vec3(234.24,229.94,97.11),vec3(236.23,229.27,97.11) }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetPedInfiniteAmmoClip(PlayerPedId(),false)

		SetVehicleModelIsSuppressed(GetHashKey("jet"),true)
		SetVehicleModelIsSuppressed(GetHashKey("besra"),true)
		SetVehicleModelIsSuppressed(GetHashKey("luxor"),true)
		SetVehicleModelIsSuppressed(GetHashKey("blimp"),true)
		SetVehicleModelIsSuppressed(GetHashKey("polmav"),true)
		SetVehicleModelIsSuppressed(GetHashKey("buzzard2"),true)
		SetVehicleModelIsSuppressed(GetHashKey("mammatus"),true)
		SetPedModelIsSuppressed(GetHashKey("s_m_y_prismuscl_01"),true)
		SetPedModelIsSuppressed(GetHashKey("u_m_y_prisoner_01"),true)
		SetPedModelIsSuppressed(GetHashKey("s_m_y_prisoner_01"),true)

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for Number = 1,22 do
			if Number ~= 14 and Number ~= 16 then
				HideHudComponentThisFrame(Number)
			end
		end

		BlockWeaponWheelThisFrame()
		DisableControlAction(0,37,true)

		DisableControlAction(0,204,true)
		DisableControlAction(0,211,true)
		DisableControlAction(0,349,true)
		DisableControlAction(0,192,true)
		DisableControlAction(0,157,true)
		DisableControlAction(0,158,true)
		DisableControlAction(0,159,true)
		DisableControlAction(0,160,true)
		DisableControlAction(0,161,true)
		DisableControlAction(0,162,true)
		DisableControlAction(0,163,true)
		DisableControlAction(0,164,true)
		DisableControlAction(0,165,true)

		if LocalPlayer["state"]["Route"] > 0 then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetAmbientVehicleRangeMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
			SetPedDensityMultiplierThisFrame(0.0)
		else
			SetVehicleDensityMultiplierThisFrame(0.5)
			SetRandomVehicleDensityMultiplierThisFrame(0.5)
			SetParkedVehicleDensityMultiplierThisFrame(1.0)
			SetAmbientVehicleRangeMultiplierThisFrame(1.0)
			SetScenarioPedDensityMultiplierThisFrame(1.0,1.0)
			SetPedDensityMultiplierThisFrame(1.0)
		end

		if IsPedArmed(PlayerPedId(),6) then
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
		end

		SetPauseMenuActive(false)
		DisablePlayerVehicleRewards(PlayerId())

		SetWeatherTypeNow(GlobalState["Weather"])
		SetWeatherTypePersist(GlobalState["Weather"])
		SetWeatherTypeNowPersist(GlobalState["Weather"])

		if LocalPlayer["state"]["Active"] then
			NetworkOverrideClockTime(GlobalState["Hours"],GlobalState["Minutes"],00)
		else
			NetworkOverrideClockTime(12,00,00)
		end

		if GlobalState["Blackout"] > 0 then
			SetArtificialLightsState(true)
			SetArtificialLightsStateAffectsVehicles(false)
		else
			SetArtificialLightsState(false)
			SetArtificialLightsStateAffectsVehicles(true)
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number = 1,#Blips do
		local Blip = AddBlipForCoord(Blips[Number][1],Blips[Number][2],Blips[Number][3])
		SetBlipSprite(Blip,Blips[Number][4])
		SetBlipDisplay(Blip,4)
		SetBlipAsShortRange(Blip,true)
		SetBlipColour(Blip,Blips[Number][5])
		SetBlipScale(Blip,Blips[Number][7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Blips[Number][6])
		EndTextCommandSetBlipName(Blip)
	end

	local Tables = {}

	for Number = 1,#Teleport do
		Tables[#Tables + 1] = { Teleport[Number][1]["x"],Teleport[Number][1]["y"],Teleport[Number][1]["z"],2.5,"E","Porta de Acesso","Pressione para acessar" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number = 1,#Teleport do
					if #(Coords - Teleport[Number][1]) <= 1 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) then
							SetEntityCoords(Ped,Teleport[Number][2])
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local Island = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAYO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local CayoPerico = false

	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not CayoPerico then
				for _,v in pairs(Island) do
					RequestIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
				SetDeepOceanScaler(0.0)
				LoadGlobalWaterType(1)
				CayoPerico = true
			end
		else
			if CayoPerico then
				for _,v in pairs(Island) do
					RemoveIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
				SetDeepOceanScaler(1.0)
				LoadGlobalWaterType(0)
				CayoPerico = false
			end
		end

		Wait(1000)
	end
end)