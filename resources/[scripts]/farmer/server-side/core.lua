-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Objects = {
	["1"] = { ["Coords"] = vec3(2119.2,5084.76,44.84), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["2"] = { ["Coords"] = vec3(2109.66,5068.44,42.82), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman",["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["3"] = { ["Coords"] = vec3(2093.25,5061.21,42.26), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["4"] = { ["Coords"] = vec3(2070.85,5045.16,41.59), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["5"] = { ["Coords"] = vec3(2059.65,5057.95,41.67), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["6"] = { ["Coords"] = vec3(2074.84,5073.35,42.92), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["7"] = { ["Coords"] = vec3(2090.34,5086.86,44.2), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["8"] = { ["Coords"] = vec3(2098.11,5104.5,45.54), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["9"] = { ["Coords"] = vec3(2101.43,5084.17,44.31), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["10"] = { ["Coords"] = vec3(2077.39,5057.99,42.07), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["11"] = { ["Coords"] = vec3(2059.51,5074.25,42.09), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["12"] = { ["Coords"] = vec3(2071.15,5089.27,43.42), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["13"] = { ["Coords"] = vec3(2081.41,5104.78,44.85), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["14"] = { ["Coords"] = vec3(2077.64,5122.9,46.39), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["15"] = { ["Coords"] = vec3(2058.41,5104.29,45.43), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["16"] = { ["Coords"] = vec3(2040.45,5083.23,42.66), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["17"] = { ["Coords"] = vec3(2041.4,5103.3,44.50), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["18"] = { ["Coords"] = vec3(2060.3,5121.8,45.38), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["19"] = { ["Coords"] = vec3(2062.81,5143.47,47.74), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["20"] = { ["Coords"] = vec3(2040.35,5128.36,46.19), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["21"] = { ["Coords"] = vec3(2020.92,5107.65,44.06), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["22"] = { ["Coords"] = vec3(2017.53,5125.19,45.26), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["23"] = { ["Coords"] = vec3(2043.34,5146.59,47.38), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["24"] = { ["Coords"] = vec3(2036.87,5160.81,48.8), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["25"] = { ["Coords"] = vec3(2022.78,5149.14,47.52), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["26"] = { ["Coords"] = vec3(1999.98,5134.99,45.17), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["27"] = { ["Coords"] = vec3(2026.46,5137.55,46.57), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["28"] = { ["Coords"] = vec3(2024.05,5089.22,42.75), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["29"] = { ["Coords"] = vec3(2045.23,5064.06,41.45), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["30"] = { ["Coords"] = vec3(2115.17,5104.75,46.17), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["31"] = { ["Coords"] = vec3(2099.65,5128.21,48.7), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["32"] = { ["Coords"] = vec3(2081.11,5143.14,50.2), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["33"] = { ["Coords"] = vec3(2063.54,5166.11,51.43), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.0, ["Show"] = 150.0, ["Model"] = "prop_veg_crop_orange", ["Event"] = "farmer:Fruitman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },

	["34"] = { ["Coords"] = vec3(2952.07,2819.73,42.58), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["35"] = { ["Coords"] = vec3(2923.9,2809.09,43.35), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["36"] = { ["Coords"] = vec3(2921.64,2793.9,40.61), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["37"] = { ["Coords"] = vec3(2934.44,2779.35,39.07), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["38"] = { ["Coords"] = vec3(2949.26,2770.88,39.02), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["39"] = { ["Coords"] = vec3(2959.64,2775.72,39.92), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["40"] = { ["Coords"] = vec3(2972.0,2779.34,38.64), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["41"] = { ["Coords"] = vec3(2976.44,2787.3,39.9), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["42"] = { ["Coords"] = vec3(2968.12,2796.86,40.94), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["43"] = { ["Coords"] = vec3(2952.52,2847.42,47.11), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["44"] = { ["Coords"] = vec3(2967.8,2840.11,45.41), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["45"] = { ["Coords"] = vec3(2979.78,2821.56,44.74), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["46"] = { ["Coords"] = vec3(2991.88,2802.39,43.93), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["47"] = { ["Coords"] = vec3(3003.04,2780.11,43.41), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["48"] = { ["Coords"] = vec3(3001.14,2763.14,42.97), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["49"] = { ["Coords"] = vec3(2992.83,2756.31,42.82), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["50"] = { ["Coords"] = vec3(2968.98,2738.39,43.74), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["51"] = { ["Coords"] = vec3(2939.29,2751.12,43.39), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["52"] = { ["Coords"] = vec3(2967.54,2758.4,43.08), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["53"] = { ["Coords"] = vec3(2989.76,2770.21,42.87), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["54"] = { ["Coords"] = vec3(2937.02,2799.51,41.01), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["55"] = { ["Coords"] = vec3(2954.26,2802.48,41.74), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_e", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["56"] = { ["Coords"] = vec3(2964.23,2786.72,39.75), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_d", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },
	["57"] = { ["Coords"] = vec3(2947.96,2783.56,39.93), ["Heading"] = 3374176, ["Height"] = 1.25, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_rock_1_f", ["Event"] = "farmer:Minerman", ["Label"] = "Mineirar", ["Time"] = 0, ["Distance"] = 2.0 },

	["58"] = { ["Coords"] = vec3(2386.34,5099.58,47.55), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["59"] = { ["Coords"] = vec3(2397.96,5087.04,47.31), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["60"] = { ["Coords"] = vec3(2401.23,5099.75,46.4), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["61"] = { ["Coords"] = vec3(2391.37,5110.17,46.39), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["62"] = { ["Coords"] = vec3(2410.42,5089.48,46.51), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["63"] = { ["Coords"] = vec3(2420.39,5070.15,46.62), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["64"] = { ["Coords"] = vec3(2424.72,5082.12,46.71), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["65"] = { ["Coords"] = vec3(2434.98,5062.41,46.34), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["66"] = { ["Coords"] = vec3(2411.24,5079.37,46.88), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["67"] = { ["Coords"] = vec3(2433.39,5074.77,46.32), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["68"] = { ["Coords"] = vec3(2410.41,5127.09,47.25), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["69"] = { ["Coords"] = vec3(2416.61,5116.57,46.88), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["70"] = { ["Coords"] = vec3(2426.6,5122.74,46.98), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["71"] = { ["Coords"] = vec3(2434.38,5111.16,47.08), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["72"] = { ["Coords"] = vec3(2436.03,5098.54,46.45), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["73"] = { ["Coords"] = vec3(2444.76,5087.11,46.34), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["74"] = { ["Coords"] = vec3(2452.11,5073.92,46.32), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["75"] = { ["Coords"] = vec3(2459.98,5082.81,46.94), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["76"] = { ["Coords"] = vec3(2475.47,5086.5,46.13), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["77"] = { ["Coords"] = vec3(2463.86,5101.53,46.45), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["78"] = { ["Coords"] = vec3(2450.84,5107.65,46.89), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["79"] = { ["Coords"] = vec3(2461.8,5063.75,46.78), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["80"] = { ["Coords"] = vec3(2473.81,5048.59,46.44), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["81"] = { ["Coords"] = vec3(2487.0,5035.03,46.79), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["82"] = { ["Coords"] = vec3(2487.67,5053.43,49.29), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_cedar_s_01", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["83"] = { ["Coords"] = vec3(2504.84,5049.0,51.44), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_w_r_cedar_dead", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },
	["84"] = { ["Coords"] = vec3(2502.22,5069.15,46.51), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_tree_pine_02", ["Event"] = "farmer:Lumberman", ["Label"] = "Derrubar", ["Time"] = 0, ["Distance"] = 1.5 },

	["85"] = { ["Coords"] = vec3(228.48,235.48,97.12), ["Heading"] = 32.44, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["86"] = { ["Coords"] = vec3(228.71,235.44,97.12), ["Heading"] = 7.44, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["87"] = { ["Coords"] = vec3(228.44,235.3,97.12), ["Heading"] = 22.44, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["88"] = { ["Coords"] = vec3(228.72,235.28,97.12), ["Heading"] = 357.44, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["89"] = { ["Coords"] = vec3(229.02,235.32,97.12), ["Heading"] = 346.67, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["90"] = { ["Coords"] = vec3(229.31,235.26,97.12), ["Heading"] = 358.04, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["91"] = { ["Coords"] = vec3(229.58,235.15,97.12), ["Heading"] = 331.58, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["92"] = { ["Coords"] = vec3(229.89,235.06,97.12), ["Heading"] = 346.58, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["93"] = { ["Coords"] = vec3(229.03,235.15,97.12), ["Heading"] = 199.87, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["94"] = { ["Coords"] = vec3(229.3,235.08,97.12), ["Heading"] = 207.43, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["95"] = { ["Coords"] = vec3(229.61,235.0,97.12), ["Heading"] = 199.93, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["96"] = { ["Coords"] = vec3(227.32,234.62,97.12), ["Heading"] = 41.08, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["97"] = { ["Coords"] = vec3(227.17,234.37,97.12), ["Heading"] = 48.62, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["98"] = { ["Coords"] = vec3(227.4,234.43,97.12), ["Heading"] = 48.62, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["99"] = { ["Coords"] = vec3(227.08,234.14,97.12), ["Heading"] = 33.62, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["100"] = { ["Coords"] = vec3(227.29,234.19,97.12), ["Heading"] = 39.18, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["101"] = { ["Coords"] = vec3(227.59,234.42,97.12), ["Heading"] = 39.85, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["102"] = { ["Coords"] = vec3(232.0,234.28,97.12), ["Heading"] = 315.85, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["103"] = { ["Coords"] = vec3(231.74,234.38,97.12), ["Heading"] = 319.51, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["104"] = { ["Coords"] = vec3(231.47,234.42,97.12), ["Heading"] = 319.51, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["105"] = { ["Coords"] = vec3(232.05,233.99,97.12), ["Heading"] = 304.51, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["106"] = { ["Coords"] = vec3(231.8,234.15,97.12), ["Heading"] = 319.51, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["107"] = { ["Coords"] = vec3(231.52,234.24,97.12), ["Heading"] = 332.01, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["108"] = { ["Coords"] = vec3(231.24,234.5,97.12), ["Heading"] = 315.84, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["109"] = { ["Coords"] = vec3(230.98,234.67,97.12), ["Heading"] = 341.86, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["110"] = { ["Coords"] = vec3(230.7,234.76,97.12), ["Heading"] = 348.41, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["111"] = { ["Coords"] = vec3(230.4,234.87,97.12), ["Heading"] = 350.93, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["112"] = { ["Coords"] = vec3(231.03,234.48,97.12), ["Heading"] = 325.93, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["113"] = { ["Coords"] = vec3(230.77,234.61,97.12), ["Heading"] = 350.93, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["114"] = { ["Coords"] = vec3(230.46,234.7,97.12), ["Heading"] = 348.43, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["115"] = { ["Coords"] = vec3(231.27,234.32,97.12), ["Heading"] = 319.74, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["116"] = { ["Coords"] = vec3(228.46,235.11,97.12), ["Heading"] = 220.57, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["117"] = { ["Coords"] = vec3(228.23,234.91,97.12), ["Heading"] = 28.05, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["118"] = { ["Coords"] = vec3(228.04,234.71,97.12), ["Heading"] = 41.37, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["119"] = { ["Coords"] = vec3(227.83,234.5,97.12), ["Heading"] = 56.37, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["120"] = { ["Coords"] = vec3(230.12,234.93,97.12), ["Heading"] = 332.08, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["121"] = { ["Coords"] = vec3(229.86,234.9,97.12), ["Heading"] = 354.13, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },
	["122"] = { ["Coords"] = vec3(230.15,234.78,97.12), ["Heading"] = 339.13, ["Height"] = 1.0, ["Width"] = 0.25, ["Show"] = 20.0, ["Model"] = "prop_money_bag_01", ["Event"] = "farmer:Transporter", ["Label"] = "Pegar", ["Time"] = 0, ["Distance"] = 0.75 },

	["123"] = { ["Coords"] = vec3(2295.92,5064.95,46.37), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["124"] = { ["Coords"] = vec3(2293.8,5067.14,46.54), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["125"] = { ["Coords"] = vec3(2291.75,5069.28,46.69), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["126"] = { ["Coords"] = vec3(2289.82,5071.4,46.84), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["127"] = { ["Coords"] = vec3(2287.77,5073.64,47.01), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["128"] = { ["Coords"] = vec3(2285.02,5076.56,47.18), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["129"] = { ["Coords"] = vec3(2282.33,5079.04,47.24), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["130"] = { ["Coords"] = vec3(2279.87,5081.56,47.35), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["131"] = { ["Coords"] = vec3(2277.08,5084.23,47.45), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["132"] = { ["Coords"] = vec3(2274.59,5086.94,47.83), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["133"] = { ["Coords"] = vec3(2271.21,5083.77,46.99), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["134"] = { ["Coords"] = vec3(2273.74,5081.23,46.91), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["135"] = { ["Coords"] = vec3(2276.23,5078.6,46.94), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["136"] = { ["Coords"] = vec3(2278.77,5076.02,46.87), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["137"] = { ["Coords"] = vec3(2281.35,5073.42,46.74), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["138"] = { ["Coords"] = vec3(2284.08,5070.68,46.55), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["139"] = { ["Coords"] = vec3(2286.32,5068.42,46.47), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["140"] = { ["Coords"] = vec3(2288.38,5066.38,46.39), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["141"] = { ["Coords"] = vec3(2290.48,5064.27,46.3), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["142"] = { ["Coords"] = vec3(2292.53,5062.15,46.20), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["143"] = { ["Coords"] = vec3(2289.37,5058.53,45.73), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["144"] = { ["Coords"] = vec3(2287.34,5060.77,45.81), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["145"] = { ["Coords"] = vec3(2285.25,5062.94,45.87), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["146"] = { ["Coords"] = vec3(2283.34,5064.88,45.92), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["147"] = { ["Coords"] = vec3(2281.23,5067.01,45.97), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["148"] = { ["Coords"] = vec3(2278.48,5069.65,46.12), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["149"] = { ["Coords"] = vec3(2275.85,5072.31,46.22), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["150"] = { ["Coords"] = vec3(2273.2,5075.1,46.3), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["151"] = { ["Coords"] = vec3(2270.63,5077.6,46.35), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["152"] = { ["Coords"] = vec3(2268.22,5080.12,46.42), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["153"] = { ["Coords"] = vec3(2264.55,5077.09,46.37), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["154"] = { ["Coords"] = vec3(2267.13,5074.58,46.28), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["155"] = { ["Coords"] = vec3(2269.68,5072.01,46.17), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["156"] = { ["Coords"] = vec3(2272.24,5069.44,46.05), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["157"] = { ["Coords"] = vec3(2274.91,5066.72,45.91), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["158"] = { ["Coords"] = vec3(2277.57,5064.04,45.73), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["159"] = { ["Coords"] = vec3(2279.65,5061.88,45.66), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["160"] = { ["Coords"] = vec3(2281.6,5059.89,45.63), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["161"] = { ["Coords"] = vec3(2283.83,5057.62,45.59), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["162"] = { ["Coords"] = vec3(2285.91,5055.53,45.54), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["163"] = { ["Coords"] = vec3(2283.01,5051.97,45.17), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["164"] = { ["Coords"] = vec3(2280.89,5053.97,45.26), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["165"] = { ["Coords"] = vec3(2278.69,5056.37,45.32), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["166"] = { ["Coords"] = vec3(2276.64,5058.28,45.37), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["167"] = { ["Coords"] = vec3(2274.56,5060.46,45.44), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["168"] = { ["Coords"] = vec3(2271.93,5063.1,45.53), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["169"] = { ["Coords"] = vec3(2269.32,5065.73,45.69), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["170"] = { ["Coords"] = vec3(2266.67,5068.45,45.88), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["171"] = { ["Coords"] = vec3(2264.29,5070.97,46.07), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 },
	["172"] = { ["Coords"] = vec3(2261.75,5073.62,46.25), ["Heading"] = 3374176, ["Height"] = 1.5, ["Width"] = 1.5, ["Show"] = 150.0, ["Model"] = "prop_grass_dry_02", ["Event"] = "farmer:Wheat", ["Label"] = "Colher", ["Time"] = 0, ["Distance"] = 1.5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FRUITMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Fruitman")
AddEventHandler("farmer:Fruitman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_HATCHET") then
					local Amount = math.random(3,5)
					local Items = { "acerola","banana","guarana","tomato","passion","grape","tange","orange","apple","strawberry","coffee2" }
					local Select = math.random(#Items)

					if (vRP.InventoryWeight(Passport) + itemWeight(Items[Select]) * Amount) <= vRP.GetWeight(Passport) then
						vRPC.playAnim(source,false,{"lumberjackaxe@idle","idle"},true)
						TriggerClientEvent("Progress",source,"Colhendo",11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 25
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true

						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							TriggerClientEvent("sounds:Private",source,"lumberman",0.1)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,Items[Select],Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>Machado</b> não encontrado.","amarelo",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Minerman")
AddEventHandler("farmer:Minerman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				if vRP.ConsultItem(Passport,"pickaxe",1) then
					local Amount = math.random(2)
					if (vRP.InventoryWeight(Passport) + itemWeight("geode") * Amount) <= vRP.GetWeight(Passport) then
						vRPC.createObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)
						TriggerClientEvent("Progress",source,"Mineirando",10000)
						Objects[Number]["Time"] = GlobalState["Work"] + 15
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							Wait(1000)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(1000)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"geode",Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>Picareta</b> não encontrada.","amarelo",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUMBERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Lumberman")
AddEventHandler("farmer:Lumberman",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_HATCHET") then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight("woodlog") * Amount) <= vRP.GetWeight(Passport) then
						vRPC.playAnim(source,false,{"lumberjackaxe@idle","idle"},true)
						TriggerClientEvent("Progress",source,"Cortando",11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 15
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							TriggerClientEvent("sounds:Private",source,"lumberman",0.1)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"woodlog",Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>Machado</b> não encontrado.","amarelo",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Transporter")
AddEventHandler("farmer:Transporter",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				if (vRP.InventoryWeight(Passport) + itemWeight("pouch")) <= vRP.GetWeight(Passport) then
					vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
					TriggerClientEvent("Progress",source,"Coletando",1000)
					Objects[Number]["Time"] = GlobalState["Work"] + 10
					Player(source)["state"]["Buttons"] = true
					Player(source)["state"]["Cancel"] = true

					Wait(1000)

					TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					vRP.GenerateItem(Passport,"pouch",1,true)
					vRP.UpgradeStress(Passport,1)
					vRPC.Destroy(source)
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Wheat")
AddEventHandler("farmer:Wheat",function(Number)
	if Objects[Number] then
		if GlobalState["Work"] >= Objects[Number]["Time"] then
			local source = source
			local Passport = vRP.Passport(source)
			if Passport and not Active[Passport] then
				Active[Passport] = true

				local Ped = GetPlayerPed(source)
				if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_MACHETE") then
					local Amount = math.random(3,5)
					if (vRP.InventoryWeight(Passport) + itemWeight("wheat") * Amount) <= vRP.GetWeight(Passport) then
						vRPC.playAnim(source,false,{"amb@world_human_gardener_plant@female@base","base_female"},true)
						TriggerClientEvent("Progress",source,"Colhendo",11000)
						Objects[Number]["Time"] = GlobalState["Work"] + 15
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						local timeProgress = 10

						repeat
							if timeProgress ~= 10 then
								Wait(400)
							end

							Wait(700)
							timeProgress = timeProgress - 1
						until timeProgress <= 0

						Wait(400)

						TriggerClientEvent("farmer:Remover",-1,Number,Objects[Number]["Time"])
						vRP.GenerateItem(Passport,"wheat",Amount,true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRP.UpgradeStress(Passport,1)
						vRPC.Destroy(source)
					else
						TriggerClientEvent("Notify",source,"Aviso","Mochila cheia.","vermelho",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>"..itemName("WEAPON_MACHETE").."</b> não encontrado.","amarelo",5000)
				end

				Active[Passport] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("farmer:Table",source,Objects)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)