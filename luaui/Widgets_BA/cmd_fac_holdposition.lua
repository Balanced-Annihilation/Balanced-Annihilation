--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_fac_holdposition.lua
--  brief:   Sets new factories to hold position
--  author:  Masta Ali
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Factory hold position",
    desc      = "Sets new factories, and all units they build, to hold position automatically (except aircraft)",
    author    = "Masta Ali",
    date      = "Mar 20, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local unitSet = {}

local unitArray = {
  "armlab",
  "armalab",
  "armvp",
  "armavp",
  "armsy",
  "armasy",
  "armhp",
  "armfhp",
  "armshltx",
  "armshltxuw",
  "armcom",
  "armamsub",
  "corlab",
  "coralab",
  "corvp",
  "coravp",
  "corsy",
  "corasy",
  "corhp",
  "corfhp",
  "corgant",
  "corgantuw",
  "coramsub",
  "corcom",
}


----------------------------------------------
------------------------------------------

function widget:PlayerChanged(playerID)
  if Spring.GetSpectatingState() then
    widgetHandler:RemoveWidget(self)
  end
end

function widget:Initialize()
  if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
    widget:PlayerChanged()
  end
  for i, v in pairs(unitArray) do
    unitSet[v] = true
  end
end

function widget:GameStart()
  widget:PlayerChanged()
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
   if ((ud ~= nil) and (unitTeam == Spring.GetMyTeamID())) then
    for i, v in pairs(unitSet) do
      if (unitSet[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, {})
      end
    end
  end
end

--------------------------------------------------------------------------------
