function widget:GetInfo()
  return {
    name      = "Keep Target",
    desc      = "Simple and slowest usage of target on the move",
    author    = "Google Frog",
    date      = "29 Sep 2011",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local CMD_UNIT_SET_TARGET = 34923
local CMD_UNIT_CANCEL_TARGET = 34924

local SpGetSelectedUnits = Spring.GetSelectedUnits
local SpValidUnitID = Spring.ValidUnitID
local SpGetUnitDefID = Spring.GetUnitDefID
local SpGetCommandQueue = Spring.GetCommandQueue
local SpGiveOrderToUnit = Spring.GiveOrderToUnit

local LICHE = UnitDefNames["armcybr"].id --liche is a bomber and should be treated as such, but its weapontype is MissileLauncher; so it has ud.isBomber=false

local function isValidType(ud, udid)
	return ud and not (ud.isBomber or ud.isFactory or (udid==LICHE) )
end

function widget:CommandNotify(id, params, options)
    if id == CMD.SET_WANTED_MAX_SPEED then
        return false -- FUCK CMD.SET_WANTED_MAX_SPEED
    end
    if id == CMD.MOVE then
        local units = SpGetSelectedUnits()
        for i = 1, #units do
            local unitID = units[i]
			if SpValidUnitID(unitID) then
			local unitDefID = SpGetUnitDefID(unitID)
				local ud = UnitDefs[unitDefID]
				if isValidType(ud, unitDefID) then 
					local cmd = SpGetCommandQueue(unitID, 1)
					if cmd and #cmd ~= 0 and cmd[1].id == CMD.ATTACK and #cmd[1].params == 1 and not cmd[1].options.internal then
						SpGiveOrderToUnit(unitID,CMD_UNIT_SET_TARGET,cmd[1].params,{})
					end
				end
			end
        end
    elseif id ~= CMD_UNIT_SET_TARGET and id ~= CMD_UNIT_CANCEL_TARGET then
        local units = SpGetSelectedUnits()
        for i = 1, #units do
            local unitID = units[i]
            if isValidType(ud) and Spring.ValidUnitID(unitID) then
                SpGiveOrderToUnit(unitID,CMD_UNIT_CANCEL_TARGET,params,{})
            end
        end
    end
    return false
end