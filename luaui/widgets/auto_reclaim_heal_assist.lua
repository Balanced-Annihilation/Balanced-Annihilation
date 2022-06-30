-----------------------------------
-- Author: Johan Hanssen Seferidis
--
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal
--					 , repair nearby units and assist in building if they have the possibility.
--					 If you select the unit while it is being idle the widget is not going to take effect on the selected unit.
--
-------------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name = "auto_reclaim_heal_assist", --coms dont patrol
		desc = "Makes idle unselected builders/rez/nanos to reclaim metal if metal bar is not full, repair nearby units and assist in building",
		author = "Pithikos",
		date = "Nov 21, 2010",
		license = "GPLv3",
        version = 3,
		layer = 0,
		enabled = false
	}
end


-- project page on github: https://github.com/jamerlan/auto_reclaim_heal_assist

--Changelog
-- v2 [teh]decay - added commander and spy to ignore units (do you like when spy uncloacks? or commander walks on llt?)
-- v3 [teh]decay - fix bug with factories pointing to itself: http://springrts.com/phpbb/viewtopic.php?f=44&t=28511



--------------------------------------------------------------------------------------
local echo           = Spring.Echo
local getUnitPos     = Spring.GetUnitPosition
local orderUnit      = Spring.GiveOrderToUnit
local getUnitTeam    = Spring.GetUnitTeam
local isUnitSelected = Spring.IsUnitSelected
local getGameSeconds = Spring.GetGameSeconds
local gameInSecs     = 0
local lastOrderGivenInSecs= 0
local idleReclaimers={} --reclaimers because they all can reclaim

myTeamID=-1;

--------------------------------------------------------------------------------------


--Initializer
function widget:Initialize()
	--disable widget if I am a spec
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  myTeamID=Spring.GetMyTeamID()                         --get my team ID
end

function widget:PlayerChanged(playerID)
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
end

local hmsx = Game.mapSizeX/2
local hmsz = Game.mapSizeZ/2
--Give reclaimers the FIGHT command every second
function widget:GameFrame()
	gameInSecs=math.floor(getGameSeconds())               --gives the time in seconds(rounded)
	--echo("Time in secs: "..gameInSecs.."    Last order given at: "..lastOrderGivenInSecs) --¤debug
	if (gameInSecs>lastOrderGivenInSecs+1) then
		for unitID in pairs(idleReclaimers) do
			local ud = UnitDefs[unitDefID]
  
		
			local x, y, z = getUnitPos(unitID)                --get unit's position
			if (not isUnitSelected(unitID)) then              --if unit is not selected
	if x and y and z then
	    if (x > hmsx) then -- avoid to issue commands outside map
	      x = x - 20
	    else
	      x = x + 20
	    end
	    if (z > hmsz) then
	      z = z - 20
	    else
	      z = z + 20
	    end	
		end
	 Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 1 }, {})
				orderUnit(unitID, CMD.PATROL, { x, y, z }, {""})    --command unit to reclaim and rez
			end
	
     

			lastOrderGivenInSecs=gameInSecs                   --record the time that command was given
		end
	end
end

local unitArray = { 
"CORCOM",
"ARMCOM",
"ARMSPY",
"CORSPY"
}

 local function IsSkirm(ud1)
  
  for i, v in pairs(unitArray) do
  --  if (v==ud1.objectname) then
	if (v:lower() == ud1.name) then
	  return true
	end
  end
  
  return false
  
end

--Add reclaimer to the register
function widget:UnitIdle(unitID, unitDefID, unitTeam)
	if (myTeamID==getUnitTeam(unitID)) then   
	--check if unit is mine
		local udef = Spring.GetUnitDefID(unitID)
		local ud = UnitDefs[udef] 
		if (UnitDefs[unitDefID]["canReclaim"] and IsSkirm(ud)==false and ud.isFactory == false) then     --check if unit can reclaim
			  idleReclaimers[unitID]=true                 --add unit to register
			  lastRegiInSecs=gameInSecs
			  --echo("Registering unit "..unitID.." as idle")
		end
		
	end
end


--Unregister reclaimer once it is given a command
function widget:UnitCommand(unitID)
	--echo("Unit "..unitID.." got a command") --¤debug
	for reclaimerID in pairs(idleReclaimers) do
		if (reclaimerID==unitID) then 
			idleReclaimers[reclaimerID]=nil
			--echo("Unregistering unit "..reclaimerID.." as idle")
		end
	end
end