-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("robberys",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Robberype = {}
local DevRobberys = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
local Robberys = {
	["1"] = {
		["Coords"] = vec3(31.28,-1339.31,29.49),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["2"] = {
		["Coords"] = vec3(2549.46,387.92,108.61),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["3"] = {
		["Coords"] = vec3(1159.46,-314.0,69.2),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["4"] = {
		["Coords"] = vec3(-709.78,-904.12,19.21),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["5"] = {
		["Coords"] = vec3(-43.45,-1748.32,29.42),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["6"] = {
		["Coords"] = vec3(381.09,332.5,103.56),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["7"] = {
		["Coords"] = vec3(-3249.65,1007.46,12.82),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["8"] = {
		["Coords"] = vec3(1737.49,6419.37,35.03),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["9"] = {
		["Coords"] = vec3(543.68,2662.61,42.16),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["10"] = {
		["Coords"] = vec3(1961.89,3750.24,32.33),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["11"] = {
		["Coords"] = vec3(2674.36,3289.26,55.23),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["12"] = {
		["Coords"] = vec3(1707.96,4920.45,42.06),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["13"] = {
		["Coords"] = vec3(-1829.22,798.74,138.19),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["14"] = {
		["Coords"] = vec3(-2959.66,387.08,14.04),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["15"] = {
		["Coords"] = vec3(-3048.68,588.59,7.9),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["16"] = {
		["Coords"] = vec3(1126.81,-980.07,45.41),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["17"] = {
		["Coords"] = vec3(1169.33,2717.82,37.15),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["18"] = {
		["Coords"] = vec3(-1478.9,-375.48,39.16),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["19"] = {
		["Coords"] = vec3(-1220.9,-916.02,11.32),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["20"] = {
		["Coords"] = vec3(170.97,6642.43,31.69),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["21"] = {
		["Coords"] = vec3(-168.42,6318.78,30.58),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["22"] = {
		["Coords"] = vec3(819.29,-774.6,26.17),
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card01",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["23"] = {
		["Coords"] = vec3(1698.11,3756.61,34.89),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["24"] = {
		["Coords"] = vec3(246.67,-50.70,70.14),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["25"] = {
		["Coords"] = vec3(841.66,-1028.05,28.39),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["26"] = {
		["Coords"] = vec3(-325.97,6080.37,31.65),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["27"] = {
		["Coords"] = vec3(-659.67,-940.23,22.02),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["28"] = {
		["Coords"] = vec3(-1311.33,-393.58,36.89),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["29"] = {
		["Coords"] = vec3(-1112.59,2696.53,18.75),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["30"] = {
		["Coords"] = vec3(2565.34,299.25,108.93),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["31"] = {
		["Coords"] = vec3(-3166.59,1086.19,21.03),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["32"] = {
		["Coords"] = vec3(18.52,-1108.84,29.96),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["33"] = {
		["Coords"] = vec3(812.88,-2154.50,29.78),
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 8,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card02",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["34"] = {
		["Coords"] = vec3(140.26,-1705.38,29.28),
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 6,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card04",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["35"] = {
		["Coords"] = vec3(1216.21,-474.67,66.2),
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 6,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card04",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["36"] = {
		["Coords"] = vec3(-1278.6,-1118.07,6.99),
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 6,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card04",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["37"] = {
		["Coords"] = vec3(-821.84,-183.37,37.56),
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["cooldown"] = 5400,
		["duration"] = 300,
		["group"] = "Policia",
		["population"] = 6,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card04",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "dollars2", ["min"] = 30000, ["max"] = 45000 }
		}
	},
	["38"] = {
		["Coords"] = vec3(-1210.46,-336.45,38.10),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	},
	["39"] = {
		["Coords"] = vec3(-353.54,-55.44,49.36),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	},
	["40"] = {
		["Coords"] = vec3(311.51,-284.59,54.48),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	},
	["41"] = {
		["Coords"] = vec3(147.18,-1046.23,29.68),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	},
	["42"] = {
		["Coords"] = vec3(-2956.50,482.09,16.01),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	},
	["43"] = {
		["Coords"] = vec3(1175.69,2712.89,38.41),
		["name"] = "Banco Fleeca",
		["type"] = "fleeca",
		["cooldown"] = 21600,
		["duration"] = 480,
		["group"] = "Policia",
		["population"] = 12,
		["avaiable"] = false,
		["timavaiable"] = 0,
		["need"] = {
			["item"] = "card03",
			["amount"] = 1
		},
		["payment"] = {
			{ ["item"] = "goldbar", ["min"] = 225, ["max"] = 250 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("robberys:Init")
AddEventHandler("robberys:Init",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Robberys[Number] then
			if GlobalState["Blackout"] == 1 then
				if not Robberys[Number]["avaiable"] then
					if not Robberype[Robberys[Number]["type"]] then
						Robberype[Robberys[Number]["type"]] = os.time()
					end

					if os.time() >= Robberype[Robberys[Number]["type"]] then
						local Service = vRP.NumPermission(Robberys[Number]["group"])
						if parseInt(GlobalState[Robberys[Number]["group"]]) >= Robberys[Number]["population"] then
							local Consult = vRP.InventoryItemAmount(Passport,Robberys[Number]["need"]["item"])
							if Consult[1] >= Robberys[Number]["need"]["amount"] then
								if not vRP.CheckDamaged(Consult[2]) then
									if vRP.TakeItem(Passport,Consult[2],Robberys[Number]["need"]["amount"]) then
										Robberype[Robberys[Number]["type"]] = os.time() + Robberys[Number]["cooldown"]
										Robberys[Number]["timavaiable"] = os.time() + Robberys[Number]["duration"]
										Robberys[Number]["avaiable"] = true

										for Passports,Sources in pairs(Service) do
											async(function()
												TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = Robberys[Number]["name"], x = Robberys[Number]["Coords"]["x"], y = Robberys[Number]["Coords"]["y"], z = Robberys[Number]["Coords"]["z"], time = "Recebido ??s "..os.date("%H:%M"), blipColor = 22 })
												vRPC.PlaySound(Sources,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
											end)
										end

										TriggerClientEvent("Progress",source,"Desencriptando",Robberys[Number]["duration"] * 1000)
										TriggerClientEvent("Notify",source,"Sucesso","Progresso de desencripta????o do sistema iniciado, o mesmo vai estar conclu??do em <b>"..Robberys[Number]["duration"].."</b> segundos.","verde",10000)
									end
								else
									TriggerClientEvent("Notify",source,"Aviso","<b>"..itemName(Robberys[Number]["need"]["item"]).."</b> danificado.","vermelho",5000)
								end
							else
								TriggerClientEvent("Notify",source,"Aten????o","Precisa de <b>"..Robberys[Number]["need"]["amount"].."x "..itemName(Robberys[Number]["need"]["item"]).."</b>.","amarelo",5000)
							end
						else
							TriggerClientEvent("Notify",source,"Aviso","Contingente indispon??vel.","vermelho",5000)
						end
					else
						local Cooldown = parseInt(Robberype[Robberys[Number]["type"]] - os.time())
						TriggerClientEvent("Notify",source,false,"Cofre est?? vazio, aguarde <b>"..Cooldown.."</b> segundos.","azul",5000)
					end
				else
					if os.time() >= Robberys[Number]["timavaiable"] then
						Robberys[Number]["avaiable"] = false

						for k,v in pairs(Robberys[Number]["payment"]) do
							vRP.GenerateItem(Passport,v["item"],math.random(v["min"],v["max"]),true)
						end
					else
						local Cooldown = parseInt(Robberys[Number]["timavaiable"] - os.time())
						TriggerClientEvent("Notify",source,false,"Desencripta????o em andamento, aguarde <b>"..Cooldown.."</b> segundos.","azul",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"Aten????o","Voc?? n??o pode fazer isso com as luzes acessas.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEVROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if DevRobberys then
		TriggerClientEvent("robberys:Init",-1,Robberys)
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("robberys:Init",source,Robberys)
end)