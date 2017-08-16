base, lwheels, rwheels, nanoturret1, arm1, nano1, beam1, nanoturret2, arm2, nano2, beam2, turret, launcher, hole1, hole2, turret2, sleeve2, barrel21, barrel22, flare21, flare22, tanks, radar, bridge, wake1, wake2, wake3, wake4, wake5, wake6, dust1, dust2, dust3, dust4 = piece('base', 'lwheels', 'rwheels', 'nanoturret1', 'arm1', 'nano1', 'beam1', 'nanoturret2', 'arm2', 'nano2', 'beam2', 'turret', 'launcher', 'hole1', 'hole2', 'turret2', 'sleeve2', 'barrel21', 'barrel22', 'flare21', 'flare22', 'tanks', 'radar', 'bridge', 'wake1', 'wake2', 'wake3', 'wake4', 'wake5', 'wake6', 'dust1', 'dust2', 'dust3', 'dust4')
local SIG_AIM = {}
local SIG_WALK = 2
local SIG_WATER = 4
local GetPosition = Spring.GetUnitPosition
-- state variables
local maxSpeed = UnitDefs[Spring.GetUnitDefID(unitID)].speed
-- Spring.Echo(UnitDefs[Spring.GetUnitDefID(unitID)].name)
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.25 * maxSpeed
-- Spring.Echo(maxWaterSpeed)
-- Spring.Echo(maxLandSpeed)
end
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom2" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.35 * maxSpeed
end
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom3" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.45 * maxSpeed
end
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom4" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.55 * maxSpeed
end
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom5" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.65 * maxSpeed
end
if UnitDefs[Spring.GetUnitDefID(unitID)].name == "armseacom6" then
maxWaterSpeed = 1.5 * maxSpeed
maxLandSpeed = 0.75 * maxSpeed
end
isMoving = "isMoving"
terrainType = "terrainType"
gun1 = 1
gun2 = 1

common = include("headers/common_includes_lus.lua")


function script.Create()
alpha = 0
beta = 0
Move(base, 1, 0, 1)
Spring.SetUnitNanoPieces(unitID, {beam1, beam2})
Spring.UnitScript.Spin(radar, 2, 2)
end

--This is unfortunately necessary due to the fact that the model is a 3do

function script.StartMoving()
	StartThread(walk)
end

function script.setSFXoccupy(curTerrainType)
-- Spring.Echo(curTerrainType)
if curTerrainType == 0 then
Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed",(maxWaterSpeed))
-- Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed",(0))
WheelsIn()
end
if curTerrainType == 1 then
Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed",(maxLandSpeed))
-- Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed",(maxLandSpeed))
WheelsOut()
end
if curTerrainType == 2 then
StartThread(swim)
Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed",(maxWaterSpeed))
-- Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed",(0))
WheelsIn()
end
if curTerrainType == 3 then
Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed",(maxWaterSpeed))
-- Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed",(0))
WheelsOut()
end
if curTerrainType == 4 then
Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed",(maxLandSpeed))
-- Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed",(maxLandSpeed))
Signal(SIG_WATER)
WheelsOut()
end
curTerrain = curTerrainType
end

function swim()
	Signal(SIG_WATER)
	SetSignalMask(SIG_WATER)	
	while (true) do
	-- Spring.Echo("swimming")
		if curTerrain == 2 then
			vx, vy, vz, vw = Spring.GetUnitVelocity(unitID)
			speedratio = (vw*45/(maxWaterSpeed)) + (math.random(1,100000)) / 100000
			-- Spring.Echo(speedratio)
			if vw > 0 then
			Spring.UnitScript.EmitSfx(wake1, 2)
			Spring.UnitScript.EmitSfx(wake2, 2)
			Spring.UnitScript.EmitSfx(wake3, 2)
			Spring.UnitScript.EmitSfx(wake4, 2)
			Spring.UnitScript.EmitSfx(wake5, 2)
			Spring.UnitScript.EmitSfx(wake6, 2)
			end
			Turn (base, 1, -0.025 - (0.025 * speedratio), 0.025 + 0.025 * speedratio)
			Spring.UnitScript.WaitForTurn ( base, 1 )
			if vw > 0 then
			Spring.UnitScript.EmitSfx(wake1, 2)
			Spring.UnitScript.EmitSfx(wake2, 2)
			Spring.UnitScript.EmitSfx(wake3, 2)
			Spring.UnitScript.EmitSfx(wake4, 2)
			Spring.UnitScript.EmitSfx(wake5, 2)
			Spring.UnitScript.EmitSfx(wake6, 2)
			end
			Turn (base, 1, 0.025 - (0.025 * speedratio), 0.025 + 0.025 * speedratio)
			Spring.UnitScript.WaitForTurn ( base, 1 )
			Spring.UnitScript.Sleep (1)
			if vw > 0 then
			Spring.UnitScript.EmitSfx(wake1, 2)
			Spring.UnitScript.EmitSfx(wake2, 2)
			Spring.UnitScript.EmitSfx(wake3, 2)
			Spring.UnitScript.EmitSfx(wake4, 2)
			Spring.UnitScript.EmitSfx(wake5, 2)
			Spring.UnitScript.EmitSfx(wake6, 2)
			end
		else
			Spring.UnitScript.Sleep (500)
		end
	end
end
	
	
function walk()
	Signal(SIG_WALK)
	SetSignalMask(SIG_WALK)	
	f = 0
	while (true) do
		if curTerrain == 4 then
			x,y,z = Spring.GetUnitPosition(unitID)

			dx, dy, dz = Spring.GetUnitDirection(unitID)
			frontleft = Spring.GetGroundHeight(x+45*dx+10*(-dz), z+45*dz+10*dx)
			frontright = Spring.GetGroundHeight(x+45*dx+10*(dz), z+45*dz+10*(-dx))
			rearleft = Spring.GetGroundHeight(x-45*dx+10*(-dz), z-45*dz+10*dx)
			rearright = Spring.GetGroundHeight(x-45*dx+10*(dz), z-45*dz+10*(-dx))
			
			if frontleft <= -8 then frontleft = -8 end
			if frontright <= -8 then frontright = -8 end
			if rearleft <= -8 then rearleft = -8 end
			if rearright <= -8 then rearright = -8 end
			
			mediumfront = (frontleft + frontright) / 2
			mediumrear = (rearleft + rearright) / 2
			mediumleft = (frontleft + rearleft) / 2
			mediumright = (frontright + rearright) / 2
			
			alpha = math.atan((mediumfront - mediumrear)/(2025*dx^2 + 2025*dz^2))
			beta = math.atan((mediumleft - mediumright)/(100*dx^2 + 100*dz^2))
			-- Spring.Echo(beta)

			mediumheight = (mediumfront + mediumrear) / 2
			heightdiff = y - mediumheight
	
			Turn (base, 3, -beta*5, 0.5)
			Turn (base, 1, -alpha*20, 0.5)			
			Move (base, 2, 8 - heightdiff/2, 5)
			if f%10 == 0 then
				Emit(dust1, 'dirtsmall')
				Emit(dust2, 'dirtsmall')
				Emit(dust3, 'dirtsmall')
				Emit(dust4, 'dirtsmall')
			end
		else 
			-- Spring.Echo("water")
			x,y,z = Spring.GetUnitPosition(unitID)
			if y <= 0 then y = 0 end
			dx, dy, dz = Spring.GetUnitDirection(unitID)
			frontleft = Spring.GetGroundHeight(x+45*dx+10*(-dz), z+45*dz+10*dx)
			frontright = Spring.GetGroundHeight(x+45*dx+10*(dz), z+45*dz+10*(-dx))
			rearleft = Spring.GetGroundHeight(x-45*dx, z-45*dz)
			rearright = Spring.GetGroundHeight(x-45*dx, z-45*dz)
			
			if frontleft <= -8 then frontleft = -8 end
			if frontright <= -8 then frontright = -8 end
			if rearleft <= -8 then rearleft = -8 end
			if rearright <= -8 then rearright = -8 end
			
			mediumfront = (frontleft + frontright) / 2
			mediumrear = (rearleft + rearright) / 2
			mediumleft = (frontleft + rearleft) / 2
			mediumright = (frontright + rearright) / 2
			
			alpha = math.atan((mediumfront - mediumrear)/(2025*dx^2 + 2025*dz^2))
			beta = math.atan((mediumleft - mediumright)/(100*dx^2 + 100*dz^2))

			mediumheight = (mediumfront + mediumrear) / 2
			heightdiff = y - mediumheight
			if not curTerrain == 2 then
			Turn (base, 3, -beta*5, 0.5)
			Turn (base, 1, -alpha*20, 0.5)			
			Move (base, 2, 8 - heightdiff, 5)
			else
			Turn (base, 3, -beta*5, 0.5)
			Move (base, 2, 8 - heightdiff, 5)		
			end
			end
		Spring.UnitScript.Sleep(50)
		f = f + 1
	end
end

function Emit(pieceName, effectName)
local x,y,z,dx,dy,dz	= Spring.GetUnitPiecePosDir(unitID, pieceName)
Spring.SpawnCEG(effectName, x,y,z, dx, dy, dz)
end

function WheelsIn()

	Move (lwheels, 1, -8, 2)
	Move (rwheels, 1, 8, 2)
	Move (lwheels, 2, 8, 2)
	Move (rwheels, 2, 8, 2)
	Move (base, 2, 0, 2)
end	
	
function WheelsOut()
	-- Turn (base, 1, -3.14/8, 1.5)
	-- Turn (base, 1, 0, 0.5)
	-- Turn (base, 1, 0, 11.25)
	Move (lwheels, 2, 0, 2)
	Move (rwheels, 2, 0, 2)
	Move (base, 2, 8, 2)
	Move (lwheels, 1, 0, 2)
	Move (rwheels, 1, 0, 2)
end		

function script.StopMoving()
	Signal(SIG_WALK) --stop the walk thread
end   

local function RestoreAfterDelay()
end		

function script.AimFromWeapon3(weaponID)
-- Spring.Echo("AimingPiece from weapon1")
	return turret

end

function script.QueryWeapon3(weaponID)
-- Spring.Echo("Query from weapon1")
	if gun1 == 2 then
		return hole1
	else
		return hole2
	end

end

function script.AimWeapon3(heading, pitch)
-- Spring.Echo("Aiming from weapon1")
	Spring.UnitScript.Turn(turret, 2, heading, 2)
	Spring.UnitScript.Turn(launcher, 1, 0-pitch, 2)
	while Spring.UnitScript.IsInTurn(turret, 2) == true or Spring.UnitScript.IsInTurn(launcher, 1) == true do
		Spring.UnitScript.Sleep(50)
	end
	return true
end

function script.FireWeapon3(weaponID)
	if gun1 == 1 then 
	--[[animation 1]]
	gun1 = 2
	else
	--[[animation 2]]
	gun1 = 1
	end
end

function script.AimFromWeapon1(weaponID)
-- Spring.Echo("AimingPiece from weapon2")
	return turret2

end

function script.QueryWeapon1(weaponID)
-- Spring.Echo("Query from weapon2")
	if gun2 == 2 then
		return flare21
	else
		return flare22
	end

end

function script.AimWeapon1(heading, pitch)
-- Spring.Echo("Aiming from weapon2")
	Spring.UnitScript.Turn(turret2, 2, heading, 2)
	Spring.UnitScript.Turn(sleeve2, 1, 0-pitch, 2)
	while Spring.UnitScript.IsInTurn(turret2, 2) == true or Spring.UnitScript.IsInTurn(sleeve2, 1) == true do
		Spring.UnitScript.Sleep(50)
	end
	return true
end

function script.FireWeapon1(weaponID)
	if gun2 == 1 then 
	Move (barrel21, 3, -5)	
	Move (barrel21, 3, 0,4.5)	
	gun2 = 2
	else
	Move (barrel22, 3, -5)	
	Move (barrel22, 3, 0,4.5)	
	gun2 = 1
	end
end

function script.StartBuilding(heading, pitch)
SetUnitValue(COB.INBUILDSTANCE, 1)
Turn (nanoturret1, 1, -pitch, 1)
Turn (nanoturret2, 1, -pitch, 1)
Turn (arm1, 2, 3.14/2, 1)
Turn (arm2, 2, -3.14/2, 1)
Turn (nano1, 2,  -3.14/2 - 0.28 + heading, 1)
Turn (nano2, 2,  3.14/2 + 0.28 + heading, 1)
end

function script.StopBuilding()
SetUnitValue(COB.INBUILDSTANCE, 0)
Turn (nanoturret1, 1, 0, 1)
Turn (nanoturret2, 1, 0, 1)
Turn (arm1, 2, 0, 1)
Turn (arm2, 2, 0, 1)
Turn (nano1, 2, 0, 1)
Turn (nano2, 2, 0, 1)
end

function script.Killed()

end