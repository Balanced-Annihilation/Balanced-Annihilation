--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "DontMoveComs",
    desc      = "Sets pre-defined units on hold position.",
    author    = "quantum",
    date      = "Jan 8, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
local GetUnitDefID       		= Spring.GetUnitDefID
local GetAllUnits        		= Spring.GetAllUnits
local GetUnitTeam        		= Spring.GetUnitTeam
local GetSpectatingState		= Spring.GetSpectatingState
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local CheckedForSpec = false

local unitSet = {}

local unitArray = {

  --comms
  "armcom",
  "corcom",

   "armdecom",
  "cordecom",
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:DrawWorld()
  if Spring.IsGUIHidden() then return end
  -- untested fix: when you resign, to also show enemy com playernames  (because widget:PlayerChanged() isnt called anymore)
  if not CheckedForSpec and Spring.GetGameFrame() > 1 then
		CheckedForSpec = true
	  if not GetSpectatingState() then
		
		local allUnits = GetAllUnits()
		  for _, unitID in pairs(allUnits) do
			local unitDefID = GetUnitDefID(unitID)
			if (unitDefID and UnitDefs[unitDefID].customParams.iscommander) then
				local unitTeam = GetUnitTeam(unitID)
				local _, playerID, _, isAI = Spring.GetTeamInfo(unitTeam, false)
				if not isAI then
			  Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, {})
				end
			end
		  end
	  end
  end
end

function widget:Initialize() 
  for i, v in pairs(unitArray) do
    unitSet[v] = true
  end
end

function widget:UnitFromFactory(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
  if ((ud ~= nil) and (unitTeam == Spring.GetMyTeamID())) then
    if (unitSet[ud.name]) then
      Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, {})
    end 
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

