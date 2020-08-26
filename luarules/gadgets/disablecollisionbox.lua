function gadget:GetInfo()
  return {
	name 	= "Aim sphere Fixer",
	desc	= "Sets aimi spheres to sane values",
	author	= "ashdnazg",
	date	= "",
	license	= "Public Domain",
	layer	= 0,
	enabled = true,
  }
end

local spGetUnitRadius = Spring.GetUnitRadius
local spGetUnitHeight = Spring.GetUnitHeight
	
if (gadgetHandler:IsSyncedCode()) then 


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)

if  (UnitDefNames["armflea"].id == unitDefID) then
	  Spring.SetUnitRadiusAndHeight(unitID, 3, 1)
elseif (UnitDefNames["armfav"].id == unitDefID) or (UnitDefNames["corfav"].id == unitDefID) or (UnitDefNames["armrectr"].id == unitDefID) or  (UnitDefNames["cornecro"].id == unitDefID) then
	  Spring.SetUnitRadiusAndHeight(unitID, 5, 1)
elseif (UnitDefNames["armhawk"].id == unitDefID) or (UnitDefNames["corvamp"].id == unitDefID) or (UnitDefNames["corpyro"].id == unitDefID) or (UnitDefNames["armanac"].id == unitDefID)  or (UnitDefNames["corsnap"].id == unitDefID)  or (UnitDefNames["armca"].id == unitDefID) or (UnitDefNames["coraca"].id == unitDefID) or (UnitDefNames["armaca"].id == unitDefID) or (UnitDefNames["corca"].id == unitDefID) or (UnitDefNames["corcrash"].id == unitDefID) or (UnitDefNames["armpw"].id == unitDefID) or (UnitDefNames["armjeth"].id == unitDefID) or  (UnitDefNames["corak"].id == unitDefID)  or  (UnitDefNames["armfark"].id == unitDefID) or (UnitDefNames["armmls"].id == unitDefID) or (UnitDefNames["cormls"].id == unitDefID)  or (UnitDefNames["corcs"].id == unitDefID) or (UnitDefNames["armcs"].id == unitDefID) then
  Spring.SetUnitRadiusAndHeight(unitID, 6, 1)
elseif   (UnitDefNames["corraid"].id == unitDefID) or (UnitDefNames["armstump"].id == unitDefID) or (UnitDefNames["armfast"].id == unitDefID) or (UnitDefNames["corfast"].id == unitDefID) or (UnitDefNames["corfink"].id == unitDefID)  or (UnitDefNames["armpeep"].id == unitDefID)  then
	  Spring.SetUnitRadiusAndHeight(unitID, 7, 1)
end
end
end

--[[ 
if  (UnitDefNames["armflea"].id == unitDefID) then
	  Spring.SetUnitRadiusAndHeight(unitID, 3, 1)
elseif (UnitDefNames["armfav"].id == unitDefID) or (UnitDefNames["corfav"].id == unitDefID) or (UnitDefNames["armrectr"].id == unitDefID) or  (UnitDefNames["cornecro"].id == unitDefID) or (UnitDefNames["cordrag"].id == unitDefID)   or  (UnitDefNames["armdrag"].id == unitDefID)  then
	  Spring.SetUnitRadiusAndHeight(unitID, 5, 1)
elseif (UnitDefNames["armhawk"].id == unitDefID) or (UnitDefNames["corvamp"].id == unitDefID) or (UnitDefNames["corpyro"].id == unitDefID) or (UnitDefNames["armanac"].id == unitDefID)  or (UnitDefNames["corsnap"].id == unitDefID)  or  (UnitDefNames["corsh"].id == unitDefID) or  (UnitDefNames["armsh"].id == unitDefID) or (UnitDefNames["armca"].id == unitDefID) or (UnitDefNames["coraca"].id == unitDefID) or (UnitDefNames["armaca"].id == unitDefID) or (UnitDefNames["corca"].id == unitDefID) or (UnitDefNames["corcrash"].id == unitDefID) or (UnitDefNames["armpw"].id == unitDefID) or (UnitDefNames["armjeth"].id == unitDefID) or  (UnitDefNames["corak"].id == unitDefID)  or  (UnitDefNames["armfark"].id == unitDefID) or (UnitDefNames["armmls"].id == unitDefID) or (UnitDefNames["cormls"].id == unitDefID)  or (UnitDefNames["corcs"].id == unitDefID) or (UnitDefNames["armcs"].id == unitDefID) then
  Spring.SetUnitRadiusAndHeight(unitID, 6, 1)
elseif  (UnitDefNames["armck"].id == unitDefID) or (UnitDefNames["corck"].id == unitDefID) or (UnitDefNames["corraid"].id == unitDefID) or (UnitDefNames["armstump"].id == unitDefID) or  (UnitDefNames["armfig"].id == unitDefID) or (UnitDefNames["corveng"].id == unitDefID)or (UnitDefNames["armfast"].id == unitDefID) or (UnitDefNames["armzeus"].id == unitDefID)or (UnitDefNames["corfast"].id == unitDefID) or (UnitDefNames["corfink"].id == unitDefID)  or (UnitDefNames["armpeep"].id == unitDefID)  then
	  Spring.SetUnitRadiusAndHeight(unitID, 7, 1)
end
]]--