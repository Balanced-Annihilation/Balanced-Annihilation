--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_direct_control.lua
--  brief:   first person unit control
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--local allowenable = false

--if tonumber(Spring.GetModOptions().mo_allowuserwidgets) == 1 then
--	allowenable = true 
--end

function gadget:GetInfo()
  return {
    name      = "DirectControl",
    desc      = "Block direct control (FPS) for units",
    author    = "trepan",
    date      = "Jul 10, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
  return false
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local enabled = true

local badUnitDefs = {
	--UnitDefNames['cormexp'].id,
	--UnitDefNames['corvipe'].id,
	--UnitDefNames['armraven'].id,
	--UnitDefNames['armsptk'].id,
	--UnitDefNames['cortron'].id,
	--UnitDefNames['cortl'].id,
	--UnitDefNames['armtl'].id,
	--UnitDefNames['cormship'].id,
	--UnitDefNames['armmship'].id,
	--UnitDefNames['corhurc'].id,
	--UnitDefNames['corvroc'].id,
	--UnitDefNames['cormship'].id,
}


--------------------------------------------------------------------------------

local function AllowAction(playerID)
  if (playerID ~= 0) then
    Spring.SendMessageToPlayer(playerID, "Must be the host player")
    return false
  end
  if (not Spring.IsCheatingEnabled()) then
    Spring.SendMessageToPlayer(playerID, "Cheating must be enabled")
    return false
  end
  return true
end


local function ChatControl(cmd, line, words, playerID)
  if (AllowAction(playerID)) then
    if (#words == 0) then
      enabled = not enabled
    else
      enabled = (words[1] == '1')
    end
  end
  return true
end


--------------------------------------------------------------------------------
local Spring_GetTeamInfo         = Spring.GetTeamInfo
  local disableFPS = false
  
function gadget:Initialize()
	Spring.SendCommands("unbind c controlunit")
	Spring.SendCommands("unbind any+c controlunit")
  Spring.SendCommands("unbind ctrl+o controlunit")
  Spring.SendCommands("bind ctrl+o controlunit")
  local cmd  = "fpsctrl"
  local help = " [0|1]:  direct unit control blocking"
  gadgetHandler:AddChatAction(cmd, ChatControl, help)
  Script.AddActionFallback(cmd .. ' ', help)
  
  
    local allyTeamList = Spring.GetAllyTeamList()
  local numteams = #Spring.GetTeamList() - 1 -- minus gaia
  local numallyteams = #Spring.GetAllyTeamList() - 1 -- minus gaia
  
  
  if ((numteams == 2) and (numallyteams == 2)) then

  local aiFound = false
   for _, team in ipairs(Spring.GetTeamList()) do
			local _,_, isDead, isAI, tside, tallyteam = Spring_GetTeamInfo(team)
			if isAI == true then
				aiFound = true
			end
	end
  
	
	if(aiFound == false) then
		disableFPS = true
	end

 
  end
  
end


function gadget:Shutdown()
  gadgetHandler:RemoveChatAction('fpsctrl')
  Script.RemoveActionFallback('fpsctrl')
end


--------------------------------------------------------------------------------


function gadget:AllowDirectUnitControl(unitID, unitDefID, unitTeam, playerID)
  
if disableFPS then
	return false
end
  
  if (not enabled) then
    return true
  end
  
  if (select(3,Spring.GetPlayerInfo(playerID)) == true) then
    return false
  end
  
  for key, value in pairs(badUnitDefs) do
    if (value == unitDefID) then
	  Spring.SendMessageToPlayer(playerID,
	    "Direct control of " .. UnitDefs[value].name .. " is disabled")
      return false
    end
  end
  
  return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
