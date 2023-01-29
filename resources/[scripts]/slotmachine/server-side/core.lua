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
Tunnel.bindInterface("slotmachine",Creative)
vCLIENT = Tunnel.getInterface("slotmachine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Players = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MACHINES
-----------------------------------------------------------------------------------------------------------------------------------------
local Machines = {
	["1"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(981.6,48.9,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["2"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(984.56,45.92,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["3"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(990.98,48.85,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["4"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(995.54,50.05,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["5"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(994.5,44.73,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["6"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(995.68,40.01,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["7"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(999.53,37.76,70.07),
		["prop"] = "vw_prop_casino_slot_04a_reels"
	},
	["8"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(982.3,49.16,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["9"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(984.79,46.8,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["10"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(991.32,47.99,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["11"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(995.54,50.05,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["12"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(994.73,45.61,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["13"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(996.02,39.16,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["14"] = {
		["win"] = {},
		["bet"] = 750,
		["use"] = false,
		["Coords"] = vec3(999.53,37.76,70.07),
		["prop"] = "vw_prop_casino_slot_05a_reels"
	},
	["15"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(985.33,45.43,70.07),
		["prop"] = "vw_prop_casino_slot_03a_reels"
	},
	["16"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(994.27,50.83,70.07),
		["prop"] = "vw_prop_casino_slot_03a_reels"
	},
	["17"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(995.27,44.24,70.07),
		["prop"] = "vw_prop_casino_slot_03a_reels"
	},
	["18"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(999.58,39.24,70.07),
		["prop"] = "vw_prop_casino_slot_03a_reels"
	},
	["19"] = {
		["win"] = {},
		["bet"] = 500,
		["use"] = false,
		["Coords"] = vec3(982.9,49.6,70.07),
		["prop"] = "vw_prop_casino_slot_06a_reels"
	},
	["20"] = {
		["win"] = {},
		["bet"] = 500,
		["use"] = false,
		["Coords"] = vec3(990.61,47.41,70.07),
		["prop"] = "vw_prop_casino_slot_06a_reels"
	},
	["21"] = {
		["win"] = {},
		["bet"] = 500,
		["use"] = false,
		["Coords"] = vec3(996.27,49.92,70.07),
		["prop"] = "vw_prop_casino_slot_06a_reels"
	},
	["22"] = {
		["win"] = {},
		["bet"] = 500,
		["use"] = false,
		["Coords"] = vec3(995.31,38.58,70.07),
		["prop"] = "vw_prop_casino_slot_06a_reels"
	},
	["23"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(986.04,46.01,70.07),
		["prop"] = "vw_prop_casino_slot_02a_reels"
	},
	["24"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(993.84,51.44,70.07),
		["prop"] = "vw_prop_casino_slot_02a_reels"
	},
	["25"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(995.97,44.82,70.07),
		["prop"] = "vw_prop_casino_slot_02a_reels"
	},
	["26"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(999.88,39.92,70.07),
		["prop"] = "vw_prop_casino_slot_02a_reels"
	},
	["27"] = {
		["win"] = {},
		["bet"] = 1250,
		["use"] = false,
		["Coords"] = vec3(985.71,46.86,70.07),
		["prop"] = "vw_prop_casino_slot_01a_reels"
	},
	["28"] = {
		["win"] = {},
		["bet"] = 1250,
		["use"] = false,
		["Coords"] = vec3(993.57,52.14,70.07),
		["prop"] = "vw_prop_casino_slot_01a_reels"
	},
	["29"] = {
		["win"] = {},
		["bet"] = 1250,
		["use"] = false,
		["Coords"] = vec3(995.64,45.67,70.07),
		["prop"] = "vw_prop_casino_slot_01a_reels"
	},
	["30"] = {
		["win"] = {},
		["bet"] = 1250,
		["use"] = false,
		["Coords"] = vec3(1000.35,40.49,70.07),
		["prop"] = "vw_prop_casino_slot_01a_reels"
	},
	["31"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(983.38,50.17,70.07),
		["prop"] = "vw_prop_casino_slot_07a_reels"
	},
	["32"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(989.84,47.91,70.07),
		["prop"] = "vw_prop_casino_slot_07a_reels"
	},
	["33"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(997.01,49.99,70.07),
		["prop"] = "vw_prop_casino_slot_07a_reels"
	},
	["34"] = {
		["win"] = {},
		["bet"] = 1000,
		["use"] = false,
		["Coords"] = vec3(994.54,39.07,70.07),
		["prop"] = "vw_prop_casino_slot_07a_reels"
	},
	["35"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(983.69,50.85,70.07),
		["prop"] = "vw_prop_casino_slot_08a_reels"
	},
	["36"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(990.07,48.79,70.07),
		["prop"] = "vw_prop_casino_slot_08a_reels"
	},
	["37"] = {
		["win"] = {},
		["bet"] = 250,
		["use"] = false,
		["Coords"] = vec3(994.77,39.95,70.07),
		["prop"] = "vw_prop_casino_slot_08a_reels"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local winTable = { "2","3","6","2","4","1","6","5","2","1","3","6","7","1","4","5" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- MULTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local mulTable = {
	["1"] = 2,
	["2"] = 4,
	["3"] = 6,
	["4"] = 8,
	["5"] = 10,
	["6"] = 12,
	["7"] = 14
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Machines[Table] then
		if not Machines[Table]["use"] then
			Machines[Table]["use"] = true
			Players[Passport] = Table
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Clean(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Machines[Table] then
		if Machines[Table]["use"] then
			Machines[Table]["win"] = {}
			Machines[Table]["use"] = false
		end

		if Players[Passport] then
			Players[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Players[Passport] then
		local Table = Players[Passport]
		if Machines[Table] then
			if Machines[Table]["use"] then
				Machines[Table]["win"] = {}
				Machines[Table]["use"] = false
			end
		end

		Players[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Machines[Table] then
		if vRP.PaymentBank(Passport,Machines[Table]["bet"]) then
			return true
		else
			TriggerClientEvent("Notify",source,"Aviso","<b>Dólares</b> insuficientes.","vermelho",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSLOTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StartSlots(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Machines[Table] then
		local Result = {
			["a"] = math.random(16),
			["b"] = math.random(16),
			["c"] = math.random(16)
		}

		Machines[Table]["win"] = Result
		vCLIENT.MachineSlots(source,Result)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINNER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Winner(Table,Result)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Machines[Table] then
		Active[Passport] = true

		if Machines[Table]["win"] then
			if Machines[Table]["win"]["a"] == Result["a"] and Machines[Table]["win"]["b"] == Result["b"] and Machines[Table]["win"]["c"] == Result["c"] then
				local Total = 0
				local Spin01 = winTable[Result["a"]]
				local Spin02 = winTable[Result["b"]]
				local Spin03 = winTable[Result["c"]]

				if Spin01 == Spin02 and Spin01 == Spin03 then
					if mulTable[Spin01] then
						Total = Machines[Table]["bet"] * mulTable[Spin01]
					end
				elseif Spin01 == Spin02 or Spin02 == Spin03 or Spin01 == Spin03 then
					Total = Machines[Table]["bet"] * 2
				end

				if Total > 0 then
					vRP.GiveBank(Passport,Total)
				end
			end

			Machines[Table]["win"] = {}
		end

		Active[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	vCLIENT.UpdateMachines(source,Machines)
end)