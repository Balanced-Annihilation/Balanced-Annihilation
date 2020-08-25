
local base = piece("base")
local GetUnitPosition 	= Spring.GetUnitPosition
local unitDefID = Spring.GetUnitDefID(unitID)
local triggerRange = tonumber(UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.detonaterange) or 1

-- Author: Doo
-- Requires customParams.detonaterange in unitDefs or 64 elmos range will be used
-- Possible enhancements: Use GetUnitsInCylinder(or sphere) of detonaterange and check for any restriction on target units

function GetClosestEnemyDistance()
	targetID = Spring.GetUnitNearestEnemy(unitID, triggerRange)
	if targetID then
	local tx,ty,tz = Spring.GetUnitPosition(targetID)
	local dis = distance(ux,uy,uz,tx,ty,tz)
	return dis
	else
	return math.huge
	end
end

function distance(x1,y1,z1,x2,y2,z2)
	local dist = math.sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2)
	return dist
end

function script.AimWeapon()
	return false
end

function script.QueryWeapon()
	return base
end

function script.AimFromWeapon()
	return base
end

function script.FireWeapon()
end

function script.Create()
	ux,uy,uz = Spring.GetUnitPosition(unitID)
	StartThread(EnemyDetect)
end

function EnemyDetect()
	while true do
		_,_,_,_,buildprogress = Spring.GetUnitHealth(unitID)
		if buildprogress >= 1 and Spring.GetUnitStates(unitID) and Spring.GetUnitStates(unitID).firestate > 0 and GetClosestEnemyDistance() <= triggerRange then
			StartThread(Detonate)
			break
		else
		Sleep(1)
		end
	end
end

function Detonate()
	Sleep(500)
	Spring.DestroyUnit(unitID, false, false)
end

function script.Killed()
return 3
end