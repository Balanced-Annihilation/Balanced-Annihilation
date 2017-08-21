local torso, ruparm, luparm, bigflsh, nanospray, pelvis, mlasflsh, head, lthigh, rthigh, nanogun, biggun, rleg, lleg, rdirt, ldirt, lfoot, rfoot = piece ("torso", "ruparm", "luparm", "bigflsh", "nanospray", "pelvis", "mlasflsh", "head", "lthigh", "rthigh", "nanogun", "biggun", "rleg", "lleg", "rdirt", "ldirt", "lfoot", "rfoot")
local piecetable ={torso, ruparm, luparm, bigflsh, nanospray, pelvis, mlasflsh, head, lthigh, rthigh, nanogun, biggun, rleg, lleg, rdirt, ldirt, lfoot, rfoot}
local SIG_WALK = 2
local PlaySoundFile 	= Spring.PlaySoundFile
local GetUnitPosition 	= Spring.GetUnitPosition
local GetGameFrame 		= Spring.GetGameFrame
common = include("headers/common_includes_lus.lua")

function GetAngleSpeed(angle,anglediff)
newangle = (currentSpeed/(300+randomness*4)) * (angle+randomness/15) * 0.0174533 * 2
newspeed = (currentSpeed/(200+randomness*4)) * 0.0174533 * 2 * anglediff*100/45
return newangle, newspeed
end

function GetIsTerrainWater()
x,y,z = Spring.GetUnitPosition(unitID)
if Spring.GetGroundHeight(x,z)<= -8 then
return true
else
return false
end
end

function Emit(pieceName, effectName)
local x,y,z,dx,dy,dz	= Spring.GetUnitPiecePosDir(unitID, pieceName)
dx, dy, dz = 1, 0, 1
Spring.SpawnCEG(effectName, x,y,z, dx, dy, dz)
end

function UnitTurns()
t = 0
heading = {}
while (true) do
difference = 0
heading[t] = Spring.GetUnitHeading(unitID)
if heading[t-1] then
	if heading[t-1] ~= heading[t] then
		difference = heading[t] - heading[t-1]

		else
		difference = 0
	end
	if math.abs(difference * 8 * 360 / 65536) <= 15 then
	difference = 0
	end
	difference = difference * 8 * 360 / 65536
	if difference > 50 then 
	difference = 50
	elseif difference < -50 then
	difference = -50
	end
	if difference ~= 0 then
		-- Spring.Echo("turning")
		-- Spring.Echo(difference)
	end

	if heading[t-2] then
		heading[t-2] = nil
	end
	difference = difference + randomness/10
end
t = t+1
Sleep (1)
end
end

function GetSurroundingTerrain(frontfoot)
x,y,z = Spring.GetUnitPosition(unitID)
dx, dy, dz = Spring.GetUnitDirection(unitID)
GroundHeightUnderFoot = Spring.GetGroundHeight(x+8*dx, z+8*dz)
GroundHeightUnderCom = Spring.GetGroundHeight(x, z)
HeightDifference = GroundHeightUnderFoot - GroundHeightUnderCom
if HeightDifference <= 0 then 
AdditiveAngle = -math.abs(math.atan(HeightDifference/math.sqrt(64*dx^2+64*dz^2)))*(300/currentSpeed)* 1/0.0174533 * 1/2
else
AdditiveAngle = math.abs(math.atan(HeightDifference/math.sqrt(64*dx^2+64*dz^2)))*(300/currentSpeed)* 1/0.0174533 * 1/2
end

if y < 0 then
	if y < -35 then
		y = -35
	end
	AdditiveAngle = AdditiveAngle*2
end

-- Spring.Echo(AdditiveAngle)
if AdditiveAngle <= 0 or randomness*0.1 + AdditiveAngle  <= 0 then 
AdditiveAngle = (AdditiveAngle + randomness*0.1)/2
else
AdditiveAngle = AdditiveAngle + randomness*0.1
end
-- Spring.Echo(AdditiveAngle)
return AdditiveAngle
end

function walk()
		if( moving )then
		if side == 0 then
		Addangle = GetSurroundingTerrain("left")
		
		Move (pelvis, 3, -10, 37.5*(currentSpeed/200)*0.75)
		-- turning rightlegground
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))

		
		Turn (lthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(-difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(difference/4,0.5))	

		
		Turn (torso, 1, GetAngleSpeed(5+Addangle,5))
		Turn (pelvis, 3, GetAngleSpeed(1.25,1.25))
		Turn (lthigh, 1, GetAngleSpeed(-45-Addangle,45))
		Turn (rthigh, 1, GetAngleSpeed(11.25-Addangle,11.25))
		Turn (lleg, 1, GetAngleSpeed(45+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(-2.5+Addangle,2.5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(15-Addangle/2,15))
		Turn (nanogun, 1, GetAngleSpeed(-5-Addangle/2,15))
		Turn (ruparm, 1, GetAngleSpeed(-15-Addangle/2,15))
		Turn (luparm, 3, GetAngleSpeed(0,5))
		Turn (ruparm, 3, GetAngleSpeed(-5,5))
		Turn (biggun, 1, GetAngleSpeed(-15-Addangle/2,15))
		Move (rfoot, 2, 1, 5)
		Move (lfoot, 2, -1, 5)
		Move (rleg, 2, 1, 5)
		Move (lleg, 2, -1, 5)
		Move (rthigh, 2, 1, 5)
		Move (lthigh, 2, -1, 5)
		Move(pelvis, 2, -3 + addheight, 15) 

		Sleep(420*(200+randomness*4)/(300+randomness*4))
		end
end
		if( moving )then
			if side == 0 then
		Addangle = GetSurroundingTerrain("left")
		Move (pelvis, 3, 0, 37.5*(currentSpeed/200)*0.75/2)
		-- turning rightlegground
		--upperbody
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))

		
		Turn (lthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(-difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(difference/4,0.5))					
		
		Turn (torso, 1, GetAngleSpeed(5+Addangle/2,5))
		Turn (pelvis, 3, GetAngleSpeed(0,1.25))
		Turn (lthigh, 3, GetAngleSpeed(0,1.25))
		Turn (rthigh, 3, GetAngleSpeed(0,1.25))
		Turn (lthigh, 2, GetAngleSpeed(0,50))
		Turn (rthigh, 2, GetAngleSpeed(-difference,50))
		Turn (lthigh, 1, GetAngleSpeed(-20-Addangle,25))
		Turn (rthigh, 1, GetAngleSpeed(22.5-Addangle,11.25))
		Turn (lleg, 1, GetAngleSpeed(20+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(-5+Addangle,2.5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(10-Addangle/2,5))
		Turn (nanogun, 1, GetAngleSpeed(-5-Addangle/2,5))
		Turn (ruparm, 1, GetAngleSpeed(-30-Addangle/2,15))
		Turn (luparm, 3, GetAngleSpeed(0,1))
		Turn (ruparm, 3, GetAngleSpeed(-5,1))
		Turn (biggun, 1, GetAngleSpeed(-30-Addangle/2,15))

				Move (rfoot, 2, 0, 5)
		Move (lfoot, 2, 0, 5)
		Move (rleg, 2, 0, 5)
		Move (lleg, 2, 0, 5)
		Move (rthigh, 2, 0, 5)
		Move (lthigh, 2, 0, 5)
		Move(pelvis, 2, 0+ addheight, 15) 
		
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		if GetIsTerrainWater() == false then
		Emit(ldirt, 'dirtsmall')
		-- Spring.Echo("leftfoot")
		-- Spring.Echo("landed")
		-- Spring.Echo(Addangle)
		end
		end
		end
		if( moving )then
		if side == 0 then
		Addangle = GetSurroundingTerrain("none")

		-- turning leftlegground
		--upperbody
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))
		--lowerbody
		--
		Turn (lthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(-difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(-difference/4,0.5))	
		
		Turn (torso, 1, GetAngleSpeed(5+Addangle/2,5))
		Turn (pelvis, 3, GetAngleSpeed(-1.25,1))
		Turn (lthigh, 3, GetAngleSpeed(1.25,1))
		Turn (rthigh, 3, GetAngleSpeed(1.25,1))
		Turn (lthigh, 2, GetAngleSpeed(-difference,50))
		Turn (rthigh, 2, GetAngleSpeed(0,50))
		Turn (lthigh, 1, GetAngleSpeed(0-Addangle,30))
		Turn (rthigh, 1, GetAngleSpeed(0-Addangle,22.5))
		Turn (lleg, 1, GetAngleSpeed(0+Addangle,1))
		Turn (rleg, 1, GetAngleSpeed(40+Addangle,45))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(0-Addangle/2,10))
		Turn (nanogun, 1, GetAngleSpeed(-5-Addangle/2,10))
		Turn (ruparm, 1, GetAngleSpeed(0-Addangle/2,30))
		Turn (luparm, 3, GetAngleSpeed(0,1))
		Turn (ruparm, 3, GetAngleSpeed(0,5))
		Turn (biggun, 1, GetAngleSpeed(-5-Addangle/2,30))

				Move (rfoot, 2, -1, 5)
		Move (lfoot, 2, 1, 5)
		Move (rleg, 2, -1, 5)
		Move (lleg, 2, 1, 5)
		Move (rthigh, 2, -1, 5)
		Move (lthigh, 2, 1, 5)
		Move(pelvis, 2, -3+ addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		side = 1
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("right")
				Move (pelvis, 3, -10, 37.5*(currentSpeed/200)*0.75)
				-- turning leftlegground
		--upperbody
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))
		--lowerbody
		--
		Turn (lthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(-difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(-difference/4,0.5))	
		
		Turn (torso, 1, GetAngleSpeed(5+Addangle/2,5))
		Turn (pelvis, 3, GetAngleSpeed(-1.25,1))
		Turn (lthigh, 3, GetAngleSpeed(1.25,1))
		Turn (rthigh, 3, GetAngleSpeed(1.25,1))		
		Turn (lthigh, 2, GetAngleSpeed(-difference,50))
		Turn (rthigh, 2, GetAngleSpeed(0,50))
		Turn (lthigh, 1, GetAngleSpeed(11.25-Addangle,11.25))
		Turn (rthigh, 1, GetAngleSpeed(-45-Addangle,45))
		Turn (lleg, 1, GetAngleSpeed(-2.5+Addangle,2.5))
		Turn (rleg, 1, GetAngleSpeed(45+Addangle,5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(-15-Addangle/2,15))
		Turn (nanogun, 1, GetAngleSpeed(-15-Addangle/2,15))
		Turn (ruparm, 1, GetAngleSpeed(15-Addangle/2,15))
		Turn (luparm, 3, GetAngleSpeed(5,1))
		Turn (ruparm, 3, GetAngleSpeed(0,1))
		Turn (biggun, 1, GetAngleSpeed(-5-Addangle/2,15))

				Move (rfoot, 2, -1, 5)
		Move (lfoot, 2, 1, 5)
		Move (rleg, 2, -1, 5)
		Move (lleg, 2, 1, 5)
		Move (rthigh, 2, -1, 5)
		Move (lthigh, 2, 1, 5)
		Move(pelvis, 2, -3+ addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("right")
		Move (pelvis, 3, 0, 37.5*(currentSpeed/200)*0.75/2)		
				-- turning leftlegground
		--upperbody
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))
		--lowerbody
		--
		Turn (lthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(-difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(-difference/4,0.5))		
		
		Turn (torso, 1, GetAngleSpeed(5+Addangle/2,5))
		Turn (pelvis, 3, GetAngleSpeed(0,1.25))
		Turn (lthigh, 3, GetAngleSpeed(0,1.25))
		Turn (rthigh, 3, GetAngleSpeed(0,1.25))
		Turn (lthigh, 2, GetAngleSpeed(-difference,50))
		Turn (rthigh, 2, GetAngleSpeed(0,50))
		Turn (lthigh, 1, GetAngleSpeed(22.5-Addangle,11.25))
		Turn (rthigh, 1, GetAngleSpeed(-20-Addangle,25))
		Turn (lleg, 1, GetAngleSpeed(-5+Addangle,2.5))
		Turn (rleg, 1, GetAngleSpeed(20+Addangle,45))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(-30-Addangle/2,15))
		Turn (nanogun, 1, GetAngleSpeed(-30-Addangle/2,15))
		Turn (ruparm, 1, GetAngleSpeed(10-Addangle/2,5))
		Turn (luparm, 3, GetAngleSpeed(5,1))
		Turn (ruparm, 3, GetAngleSpeed(0,1))
		Turn (biggun, 1, GetAngleSpeed(-5-Addangle/2,5))

		Move (rfoot, 2, 0, 5)
		Move (lfoot, 2, 0, 5)
		Move (rleg, 2, 0, 5)
		Move (lleg, 2, 0, 5)
		Move (rthigh, 2, 0, 5)
		Move (lthigh, 2, 0, 5)
		Move(pelvis, 2, 0+ addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		if GetIsTerrainWater() == false then
		Emit(rdirt, 'dirtsmall')
		-- Spring.Echo("rightfoot")
		-- Spring.Echo("landed")
		-- Spring.Echo(Addangle)
		end
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("none")
		
				-- turning rightlegground
		--upperbody
		Turn (pelvis, 2, GetAngleSpeed(-difference/2,1))
		Turn (torso, 2, GetAngleSpeed(difference/4,0.5))
		Turn (head, 2, GetAngleSpeed(difference/4,0.5))

		
		Turn (lthigh, 2, GetAngleSpeed(difference/8,0.25))
		Turn (lleg, 2, GetAngleSpeed(difference/8,0.25))		
		Turn (rthigh, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rleg, 2, GetAngleSpeed(-difference/8,0.25))
		Turn (rfoot, 2, GetAngleSpeed(-difference/4,0.5))		
		Turn (lfoot, 2, GetAngleSpeed(difference/4,0.5))		
		
		Turn (torso, 1, GetAngleSpeed(5+Addangle/2,5))
		Turn (pelvis, 3, GetAngleSpeed(1.25,1))
		Turn (lthigh, 3, GetAngleSpeed(-1.25,1))
		Turn (rthigh, 3, GetAngleSpeed(-1.25,1))
		Turn (lthigh, 2, GetAngleSpeed(0,50))
		Turn (rthigh, 2, GetAngleSpeed(-difference,50))
		Turn (lthigh, 1, GetAngleSpeed(-0-Addangle,22.5))
		Turn (rthigh, 1, GetAngleSpeed(0-Addangle,30))
		Turn (lleg, 1, GetAngleSpeed(40+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(0+Addangle,1))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (luparm, 1, GetAngleSpeed(0-Addangle/2,30))
		Turn (nanogun, 1, GetAngleSpeed(-5-Addangle,30))
		Turn (ruparm, 1, GetAngleSpeed(0-Addangle/2,10))
		Turn (luparm, 3, GetAngleSpeed(0,5))
		Turn (ruparm, 3, GetAngleSpeed(0,1))
		Turn (biggun, 1, GetAngleSpeed(-5-Addangle/2,10))
		Move (rfoot, 2, 1, 5)
		Move (lfoot, 2, -1, 5)
		Move (rleg, 2, 1, 5)
		Move (lleg, 2, -1, 5)
		Move (rthigh, 2, 1, 5)
		Move (lthigh, 2, -1, 5)
		Move(pelvis, 2, -3+ addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		side = 0
		end
		end
end

function walklegs()

		if( moving )then
		if side == 0 then
		Addangle = GetSurroundingTerrain("left")
				Move (pelvis, 3, -10, 37.5*(currentSpeed/200)*0.75)
		Turn (lthigh, 1, GetAngleSpeed(-45-Addangle,45))
		Turn (rthigh, 1, GetAngleSpeed(11.25-Addangle,11.25))
		Turn (lleg, 1, GetAngleSpeed(45+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(-2.5+Addangle,2.5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, 1, 5)
		Move (lfoot, 2, -1, 5)
		Move (rleg, 2, 1, 5)
		Move (lleg, 2, -1, 5)
		Move (rthigh, 2, 1, 5)
		Move (lthigh, 2, -1, 5)
		Move(pelvis, 2, -3 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))

		end
		end
		if( moving )then
		if side == 0 then
		Addangle = GetSurroundingTerrain("left")
		Move (pelvis, 3, 0, 37.5*(currentSpeed/200)*0.75/2)
		Turn (lthigh, 1, GetAngleSpeed(-20-Addangle,25))
		Turn (rthigh, 1, GetAngleSpeed(22.5-Addangle,11.25))
		Turn (lleg, 1, GetAngleSpeed(0+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(-5+Addangle,2.5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, 0, 5)
		Move (lfoot, 2, 0, 5)
		Move (rleg, 2, 0, 5)
		Move (lleg, 2, 0, 5)
		Move (rthigh, 2, 0, 5)
		Move (lthigh, 2, 0, 5)
		Move(pelvis, 2, 0 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		Emit(ldirt, 'dirtsmall')
		end
		end
		if( moving )then
		if side == 0 then
		Addangle = GetSurroundingTerrain("none")
		Turn (lthigh, 1, GetAngleSpeed(0-Addangle,30))
		Turn (rthigh, 1, GetAngleSpeed(0-Addangle,22.5))
		Turn (lleg, 1, GetAngleSpeed(0+Addangle,1))
		Turn (rleg, 1, GetAngleSpeed(40+Addangle,45))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, -1, 5)
		Move (lfoot, 2, 1, 5)
		Move (rleg, 2, -1, 5)
		Move (lleg, 2, 1, 5)
		Move (rthigh, 2, -1, 5)
		Move (lthigh, 2, 1, 5)
		Move(pelvis, 2, -3 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		side = 1
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("right")
		Move (pelvis, 3, -10, 37.5*(currentSpeed/200)*0.75)
		Turn (lthigh, 1, GetAngleSpeed(11.25-Addangle,11.25))
		Turn (rthigh, 1, GetAngleSpeed(-45-Addangle,45))
		Turn (lleg, 1, GetAngleSpeed(-2.5+Addangle,2.5))
		Turn (rleg, 1, GetAngleSpeed(45+Addangle,5))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, -1, 5)
		Move (lfoot, 2, 1, 5)
		Move (rleg, 2, -1, 5)
		Move (lleg, 2, 1, 5)
		Move (rthigh, 2, -1, 5)
		Move (lthigh, 2, 1, 5)
		Move(pelvis, 2, -3 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("right")
				Move (pelvis, 3, 0, 37.5*(currentSpeed/200)*0.75/2)
		Turn (lthigh, 1, GetAngleSpeed(22.5-Addangle,11.25))
		Turn (rthigh, 1, GetAngleSpeed(-20-Addangle,25))
		Turn (lleg, 1, GetAngleSpeed(-5+Addangle,2.5))
		Turn (rleg, 1, GetAngleSpeed(0+Addangle,45))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, 0, 5)
		Move (lfoot, 2, 0, 5)
		Move (rleg, 2, 0, 5)
		Move (lleg, 2, 0, 5)
		Move (rthigh, 2, 0, 5)
		Move (lthigh, 2, 0, 5)
		Move(pelvis, 2, 0 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		Emit(rdirt, 'dirtsmall')
		end
		end
		if( moving )then
		if side == 1 then
		Addangle = GetSurroundingTerrain("none")
		Turn (lthigh, 1, GetAngleSpeed(-0-Addangle,22.5))
		Turn (rthigh, 1, GetAngleSpeed(0-Addangle,30))
		Turn (lleg, 1, GetAngleSpeed(40+Addangle,45))
		Turn (rleg, 1, GetAngleSpeed(0+Addangle,1))
		Turn (lfoot, 1, GetAngleSpeed(-Addangle,45))
		Turn (rfoot, 1, GetAngleSpeed(-Addangle,45))
		Move (rfoot, 2, 1, 5)
		Move (lfoot, 2, -1, 5)
		Move (rleg, 2, 1, 5)
		Move (lleg, 2, -1, 5)
		Move (rthigh, 2, 1, 5)
		Move (lthigh, 2, -1, 5)
		Move(pelvis, 2, -3 + addheight, 15) 
		Sleep(420*(200+randomness*4)/(300+randomness*4))
		side = 0
		end
		end
end

function stopwalk()
end

function UnitSpeed()
		vx,vy,vz,Speed = Spring.GetUnitVelocity(unitID)
	while (true) do
		vx,vy,vz,Speed = Spring.GetUnitVelocity(unitID)
		currentSpeed = Speed*100*60/moveSpeed
		if (currentSpeed < 100) then currentSpeed = 100 end
		randomness = math.random(-25,25)
		currentSpeed = currentSpeed + randomness
-- Spring.Echo(Shield)
	if UnitDefs[Spring.GetUnitDefID(unitID)].name == "corcom5" or UnitDefs[Spring.GetUnitDefID(unitID)].name == "corcom6" then
	if Shield == true then
		Spring.SetUnitArmored(unitID, true)
	else
		Spring.SetUnitArmored(unitID,false)
	end
	end
		Sleep (142)
		-- Spring.Echo(currentSpeed)
	end
end

function MotionControl()

	justmoved = true
	while (true) do
	-- Spring.Echo(aiming)
		if (moving) then
			-- Spring.Echo("moving")
			dgunning = 0
			if (aiming) then
				walklegs()
			else
				walk()
			end
			justmoved = true
		else
			if( justmoved ) then
				Move (pelvis, 2, 0)

				-- side = math.random(0,1)
				if side == 0 then
				Move (rfoot, 2, 1, 5)
				Move (lfoot, 2, -1, 5)
				Move (rleg, 2, 1, 5)
				Move (lleg, 2, -1, 5)
				Move (rthigh, 2, 1, 5)
				Move (lthigh, 2, -1, 5)
				Move (pelvis, 2, -3, 15) 
				Turn (rthigh, 1, GetAngleSpeed(0,45))
				Turn (rthigh, 2, GetAngleSpeed(0,45))
				Turn (rthigh, 3, GetAngleSpeed(0,45))
				Turn (rleg, 1, GetAngleSpeed(0,45))
				Turn (lthigh, 2, GetAngleSpeed(0,45))
				Turn (lthigh, 3, GetAngleSpeed(0,45))
				Turn (lthigh, 1, GetAngleSpeed(-60,45))
				Turn (lleg, 1, GetAngleSpeed(120,45))
				Turn (lfoot, 1, GetAngleSpeed(-60,45))
				else
				Turn (rthigh, 2, GetAngleSpeed(0,45))
				Turn (rthigh, 3, GetAngleSpeed(0,45))
				Turn (lthigh, 2, GetAngleSpeed(0,45))
				Turn (lthigh, 3, GetAngleSpeed(0,45))
				Turn (lthigh, 1, GetAngleSpeed(0,45))
				Turn (lleg, 1, GetAngleSpeed(0,45))
				Move (lfoot, 2, 2, 5)
				Move (rfoot, 2, -1, 5)
				Move (lleg, 2, 2, 5)
				Move (rleg, 2, -1, 5)
				Move (lthigh, 2, 2, 5)
				Move (rthigh, 2, -1, 5)
				Move (pelvis, 2, -6, 15) 
				Turn (rthigh, 1, GetAngleSpeed(-60,45))
				Turn (rleg, 1, GetAngleSpeed(120,45))
				Turn (rfoot, 1, GetAngleSpeed(-60,45))				
				end
				if not (aiming) then
					Turn (torso, 1, GetAngleSpeed(0,5))
					Turn (luparm, 1, GetAngleSpeed(0,30))
					Turn (ruparm, 1, GetAngleSpeed(0,30))
				end
				justmoved = false
			end
			Sleep (100)
		end
		Sleep (1)
	end
end

function script.Create()
	Hide (bigflsh)
	addheight = 0
	side = math.random(0,1)
	randomness = math.random(-25,25)
	Hide (mlasflsh)
	Turn (mlasflsh, 1 , (1/(6.28*8))*90 )
	Move (mlasflsh, 1 , 0.5 )
	Move (mlasflsh, 3 , 0.25 )
	Turn (bigflsh, 1 , (1/(6.28*8))*90 )
	Move (bigflsh, 1 , 0.5 )
	Move (bigflsh , 2 , -0.35 )
	Hide (nanospray)
	moving = false
	aiming = false
	building = false
	justfired = false
	dgunning = 0
	buildy = 0
	buildx = 0
	moveSpeed = UnitDefs[Spring.GetUnitDefID(unitID)].speed
	currentSpeed = 100
	Spring.UnitScript.StartThread(MotionControl)
	Spring.UnitScript.StartThread(UnitTurns)
	Spring.UnitScript.StartThread(UnitSpeed)
	Spring.SetUnitNanoPieces(unitID, {mlasflsh})
	Shield = false
end

function script.StartMoving()
	moving = true
	dgunning = false
	building = false
end
	
function script.StopMoving()
	moving = false
end

function Restore()
-- Spring.Echo("restoring")
Spring.UnitScript.SetSignalMask(31)
Sleep(3000)
	if building == false then
	Turn (torso, 2, GetAngleSpeed(0,20))
	Turn (torso, 1, GetAngleSpeed(0,4))
	Turn (torso, 3, GetAngleSpeed(0,4))
	Turn (pelvis, 2, GetAngleSpeed(0,4))
	Turn (pelvis, 1, GetAngleSpeed(0,4))
	Turn (pelvis, 3, GetAngleSpeed(0,4))
	Turn (ruparm, 1, GetAngleSpeed(0,30))
	Turn (ruparm, 2, GetAngleSpeed(0,30))
	Turn (ruparm, 3, GetAngleSpeed(0,30))
	Turn (luparm, 1, GetAngleSpeed(0,4))
	Turn (luparm, 3, GetAngleSpeed(0,4))
	Turn (nanogun, 1, GetAngleSpeed(0,30))
	Turn (biggun, 1, GetAngleSpeed(0,30))
	Turn (biggun, 2, GetAngleSpeed(0,30))
	Spring.UnitScript.WaitForTurn ( ruparm, 1 )
	Spring.UnitScript.WaitForTurn ( ruparm, 3 )
	Spring.UnitScript.WaitForTurn ( ruparm, 2 )
	Spring.UnitScript.WaitForTurn ( biggun, 1 )
	Spring.UnitScript.WaitForTurn ( biggun, 2 )
	Shield = false
	-- Spring.UnitScript.WaitForTurn ( torso, 1 )
	-- Spring.UnitScript.WaitForTurn ( torso, 2 )
	-- Spring.UnitScript.WaitForTurn ( torso, 3 )
	-- Spring.UnitScript.WaitForTurn ( pelvis, 1 )
	-- Spring.UnitScript.WaitForTurn ( pelvis, 2 )
	-- Spring.UnitScript.WaitForTurn ( pelvis, 3 )
	-- Spring.UnitScript.WaitForTurn ( ruparm, 1 )
	-- Spring.UnitScript.WaitForTurn ( ruparm, 3 )
	-- Spring.UnitScript.WaitForTurn ( luparm, 3 )
	-- Spring.UnitScript.WaitForTurn ( luparm, 1 )
	dgunning = false
	aiming = false
	building = false
end

end

function script.QueryWeapon1()
return mlasflsh
end

function script.AimFromWeapon1()
return torso
 end

function script.AimWeapon1( heading, pitch )
if dgunning == true then
	return (false)
else
	Spring.UnitScript.Signal(31)
	Spring.UnitScript.StartThread(Restore)
	aiming = true
	Turn (torso, 1, GetAngleSpeed(0,4))
	Turn (torso, 2, heading, 3)
	Turn (luparm, 1, ((-math.pi/2)-pitch)/4, 250*0.0174533 * 2)
	Turn (nanogun, 1, ((-math.pi/2)-pitch)*3/4, 250*0.0174533 * 2)
	if UnitDefs[Spring.GetUnitDefID(unitID)].name == "corcom5" or UnitDefs[Spring.GetUnitDefID(unitID)].name == "corcom6" then
	Turn (ruparm, 1, -30* 0.0174533 ,60*0.0174533 * 2)
	Turn (ruparm, 2, 45* 0.0174533 ,90*0.0174533 * 2)
	Turn (biggun, 1, (30+20)*0.0174533 ,60*0.0174533 * 2)
	Turn (biggun, 2, 30*0.0174533 ,60*0.0174533 * 2)
	end
	WaitForTurn (torso, 2)
	WaitForTurn (torso, 1)
	WaitForTurn (luparm, 1)
	WaitForTurn (nanogun, 1)
	justfired = true
	Shield = true
		building = false
	return (true)
end
end

function script.Shot1()
	justfired = false
	Spring.UnitScript.Signal(31)
	Spring.UnitScript.StartThread(Restore)
end

function script.QueryWeapon3()
return bigflsh
end

function script.AimFromWeapon3()
return torso
 end

function script.AimWeapon3( heading, pitch )
	dgunning = true
		Spring.UnitScript.Signal(31)
		Spring.UnitScript.StartThread(Restore)
	Turn (torso, 1, GetAngleSpeed(0,4))
	Turn (torso, 2, heading, 3)
	Turn (luparm, 1, (0-pitch)/8, 250*0.0174533 * 2)
	Turn (nanogun, 1, (0-pitch)*3/8, 250*0.0174533 * 2)
	Turn (ruparm, 2, 0 ,90*0.0174533 * 2)
	Turn (biggun, 2, 0 ,60*0.0174533 * 2)
	Turn (ruparm, 1, (-1.57-pitch)/4, 250*0.0174533 * 2)
	Turn (ruparm, 3, GetAngleSpeed(0,4))
	Turn (biggun, 1, (-1.57-pitch)*3/4, 250*0.0174533 * 2)
	WaitForTurn (torso, 2)
	WaitForTurn (torso, 1)
	WaitForTurn (ruparm, 1)
	WaitForTurn (biggun, 1)
	WaitForTurn (ruparm, 2)
	WaitForTurn (biggun, 2)
	Shield = false
	justfired = true
		building = false
	return (1)
end

function script.Shot3()
	justfired = false
	Spring.UnitScript.Signal(31)
	Spring.UnitScript.StartThread(Restore)
	dgunning = false
end
function script.StartBuilding(heading, pitch)
	Spring.UnitScript.Signal(31)
	Spring.UnitScript.StartThread(Restore)
	aiming = true
	building = true
	dgunning = false
	Turn (torso, 1, GetAngleSpeed(0,4))
	Turn (torso, 2, heading, 3)
	Turn (luparm, 1, (0-pitch)/4, 250*0.0174533 * 2)
	Turn (nanogun, 1, (0-pitch)*3/4, 250*0.0174533 * 2)
	WaitForTurn (torso, 2)
	WaitForTurn (torso, 1)
	WaitForTurn (luparm, 1)
	WaitForTurn (nanogun, 1)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.StopBuilding()
	SetUnitValue(COB.INBUILDSTANCE, 0)
	Spring.UnitScript.Signal(31)
	building = false
	dgunning = false
	Spring.UnitScript.StartThread(Restore)
end
function script.Killed()
for count, piece in pairs(piecetable) do
Explode(piece, SFX.EXPLODE_ON_HIT)
Hide(piece)
end
return 1
end
