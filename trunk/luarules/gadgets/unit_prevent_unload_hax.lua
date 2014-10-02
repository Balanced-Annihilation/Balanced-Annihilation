function gadget:GetInfo()
  return {
    name      = "Prevent Unload Hax",
    desc      = "removes unit velocity on unload (and prevents firing units across the map with 'stored' impulse)",
    author    = "Bluestone",
    date      = "12/08/2013",
    license   = "horse has fallen over, again",
    layer     = 0,
    enabled   = true
  }
end

if (not gadgetHandler:IsSyncedCode()) then return end

local COMMANDO = UnitDefNames["commando"].id

local SpSetUnitVelocity = Spring.SetUnitVelocity
local SpGetUnitVelocity = Spring.GetUnitVelocity
local SpGetGroundHeight = Spring.GetGroundHeight

function gadget:UnitUnloaded(unitID, unitDefID, teamID, transportID)
	if unitID == nil or unitDefID == nil or transportID == nil then return end

	if (unitDefID == COMMANDO) then		
		local x,y,z = SpGetUnitVelocity(transportID)
		if x > 10 then x = 10 elseif x <- 10 then x = -10 end -- 10 is well above 'normal' air-trans velocity
		if z > 10 then z = 10 elseif z <- 10 then z = -10 end		
        local bx,by,bz = Spring.GetUnitPosition(unitID)
        if by-Spring.GetGroundHeight(bx,bz) < 5 then
            x = 0; y = 0; z = 0 --in particular, don't give any velocity if the transport has placed the unit slightly underground (or wierdness...)
        end
		SpSetUnitVelocity(unitID, x, y, z)
	else
		SpSetUnitVelocity(unitID, 0,0,0)	
	end
end
	