function gadget:GetInfo()
	return {
		name = "Dance",
		desc = "",
		author = "silver",
		version = "",
		date = "2021",
		license = "free",
		layer = 0,
		enabled = true,
	}
end

local coreComDefID = UnitDefNames.corcom.id
local armComDefID = UnitDefNames.armcom.id

if (gadgetHandler:IsSyncedCode()) then
	function gadget:RecvLuaMsg(msg, playerID)
		if msg:sub(1, 2) == "%%" then
			unitID = tonumber(msg:sub(4, 12))

			if unitID then
				unitDefID = Spring.GetUnitDefID(unitID)
				unitTeam = Spring.GetUnitTeam(unitID)

				if armComDefID == unitDefID and unitTeam == playerID then
					if msg:sub(3, 3) == "1" then
						Spring.CallCOBScript(unitID, "dance", 1)
					end

					if msg:sub(3, 3) == "0" then
						Spring.CallCOBScript(unitID, "dab", 1)
					end
				end

				if coreComDefID == unitDefID and unitTeam == playerID then
					if msg:sub(3, 3) == "1" then
						Spring.CallCOBScript(unitID, "dance", 1)
					end

					if msg:sub(3, 3) == "2" then
						Spring.CallCOBScript(unitID, "dance2", 1)
					end
				end
			end
		end
	end
end