
function gadget:GetInfo()
    return {
        name      = 'Juno Damage',
        desc      = 'Handles Juno damage',
        author    = 'Niobium, Bluestone',
        version   = 'v2.0',
        date      = '05/2013',
        license   = 'GNU GPL, v2 or later',
        layer     = 0,
        enabled   = true
    }
end

----------------------------------------------------------------
-- Synced only
----------------------------------------------------------------
if gadgetHandler:IsSyncedCode() then

----------------------------------------------------------------
-- Config
----------------------------------------------------------------
local tokillUnits = {
    [UnitDefNames.armarad.id] = true,
    [UnitDefNames.armaser.id] = true,
    [UnitDefNames.armason.id] = true,
    [UnitDefNames.armeyes.id] = true,
    [UnitDefNames.armfrad.id] = true,
    [UnitDefNames.armjam.id] = true,
    [UnitDefNames.armjamt.id] = true,
    [UnitDefNames.armmark.id] = true,
    [UnitDefNames.armrad.id] = true,
    [UnitDefNames.armseer.id] = true,
    [UnitDefNames.armsjam.id] = true,
    [UnitDefNames.armsonar.id] = true,
    [UnitDefNames.armveil.id] = true,
    [UnitDefNames.corarad.id] = true,
    [UnitDefNames.corason.id] = true,
    [UnitDefNames.coreter.id] = true,
    [UnitDefNames.coreyes.id] = true,
    [UnitDefNames.corfrad.id] = true,
    [UnitDefNames.corjamt.id] = true,
    [UnitDefNames.corrad.id] = true,
    [UnitDefNames.corshroud.id] = true,
    [UnitDefNames.corsjam.id] = true,
    [UnitDefNames.corsonar.id] = true,
    [UnitDefNames.corspec.id] = true,
    [UnitDefNames.corvoyr.id] = true,
    [UnitDefNames.corvrad.id] = true,
	
    [UnitDefNames.corfav.id] = true, 
    [UnitDefNames.armfav.id] = true,
    [UnitDefNames.armflea.id] = true,
}

local todenyUnits = {
    [UnitDefNames.corfav.id] = true, 
    [UnitDefNames.armfav.id] = true,
    [UnitDefNames.armflea.id] = true,
}

--config -- see also in unsynced
local radius = 450 --outer radius of area denial ring
local width = 30 --width of area denial ring
local effectlength = 30 --how long area denial lasts, in seconds
local fadetime = 2 --how long fade in/out effect lasts, in seconds

--locals
local SpGetGameSeconds = Spring.GetGameSeconds
local SpGetUnitsInCylinder = Spring.GetUnitsInCylinder
local SpDestroyUnit = Spring.DestroyUnit
local SpGetUnitDefID = Spring.GetUnitDefID
local SpValidUnitID = Spring.ValidUnitID
local Mmin = math.min


-- kill appropriate things from initial juno blast --

local junoWeapons = {
    [WeaponDefNames.ajuno_juno_pulse.id] = true,
    [WeaponDefNames.cjuno_juno_pulse.id] = true,
}

function gadget:UnitDamaged(uID, uDefID, uTeam, damage, paralyzer, weaponID, projID, aID, aDefID, aTeam)
    if junoWeapons[weaponID] and tokillUnits[uDefID] then
		if uID and SpValidUnitID(uID) then
			if aID and SpValidUnitID(aID) then
				SpDestroyUnit(uID, false, false, aID)
			else
				SpDestroyUnit(uID, false, false)
			end
		end
	end
end

-- area denial --

local centers = {} --table of where juno missiles hit etc
local counter = 1 --index each explosion of juno missile with this counter

function gadget:Initialize()
	Script.SetWatchWeapon(WeaponDefNames.ajuno_juno_pulse.id, true)
	Script.SetWatchWeapon(WeaponDefNames.cjuno_juno_pulse.id, true)
end


function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if junoWeapons[weaponID] then
		local curtime = SpGetGameSeconds()
		local junoExpl = {x=px, y=py, z=pz, t=curtime, o=ownerID}
		centers[counter] = junoExpl
		SendToUnsynced("AddToCenters",counter,px,py,pz,curtime)
		counter = counter + 1 		
	end
end

local lastupdate = - 1
local updatespersec = 30
local updategrain = 1/updatespersec
local update = true

function gadget:GameFrame(frame)

	if frame == 10 then --seems that SendToUnsynced has to happen after
		SendToUnsynced("RecieveConstants",width,radius,effectlength,fadetime)
	end
	
	local curtime = SpGetGameSeconds()
	
	for counter,expl in pairs(centers) do
		if (expl.t >= curtime - effectlength) then
			local q = 1
			if ((expl.t + effectlength - fadetime <= curtime) and (curtime <= expl.t + effectlength)) then
				q = (1/fadetime) * Mmin(curtime-expl.t, expl.t+effectlength-curtime)
			end
			
			local unitIDsBig   = SpGetUnitsInCylinder(expl.x, expl.z, q*radius)
			local unitIDsSmall = SpGetUnitsInCylinder(expl.x, expl.z, q*(radius-width))

			for _,unitID in pairs(unitIDsBig) do
				local unitDefID = SpGetUnitDefID(unitID)
				if todenyUnits[unitDefID] then
					local foundmatch = false
					for _,testUnitID in pairs(unitIDsSmall) do
						if (unitID == testUnitID) then
							foundmatch = true 
							break
						end
					end
				
					if (not foundmatch) then					
						if unitID and SpValidUnitID(unitID) then
							SpDestroyUnit(unitID,true,false) 
						end
					end
				end			
			end		
		else
			SendToUnsynced("RemoveFromCenters", counter)
			table.remove(centers, counter)
		end

		if ((expl.t + fadetime >= curtime) or (expl.t + effectlength - fadetime <= curtime) and (curtime <= expl.t + effectlength)) then
			update = true -- fast update during fade in/out
		end
	end
	
	if ((#centers ~= 0) and (curtime - lastupdate > 1)) then --slow update (to re-match ground in unsync)
		update = true
	end
	
	if ((update==true) and (curtime - lastupdate > updategrain)) then 
		lastupdate = curtime	
		SendToUnsynced("UpdateList", curtime)
		update = false
	end
end

-----------------------------------------------------
else -- UNSYNCED
------- the code here is heavily optimized, be careful 
-----------------------------------------------------

--copy of config from synced (a bit hacky, meh, SendToUnsynced doesn't work in initialize and worse hacks would be needed to cope without these constants during the unsynced init)
--TODO better way for this
local radius = 450 --outer radius of area denial ring
local width = 30 --width of area denial ring
local effectlength = 30 --how long area denial lasts, in seconds
local fadetime = 2 --how long fade in/out effect lasts, in seconds

--speedups
local glCreateList = gl.CreateList
local glBeginEnd = gl.BeginEnd
local glDepthTest = gl.DepthTest
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glCallList = gl.CallList
local glColor = gl.Color
local glVertex = gl.Vertex
local glDeleteList = gl.DeleteList
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local GL_LEQUAL = GL.LEQUAL
local SpGetGameSeconds = Spring.GetGameSeconds
local SpGetGroundHeight = Spring.GetGroundHeight
local Mmin = math.min
local Mmath = math.max
local Mcos = math.cos
local Msin = math.sin
local Mrandom = math.random
local Mpow = math.pow
local Mpi = math.pi

local FadedCircle

--setup constants for drawing small circles
local num_segs = 5
local smallcircleincr = 2 * Mpi / num_segs 
local c = Mcos(smallcircleincr) 
local s = Msin(smallcircleincr)
local alpha = 0.2
local xcoords_small = {}
local zcoords_small = {}

--setup constants for drawing the big circle
local num_segments = 60
local incr = 2 * Mpi / num_segments
local sincr = Msin(incr)
local cincr = Mcos(incr)
local fadedist = 8
local xcoords_incr = {}
local zcoords_incr = {}


--quick and dirty circle for the small circles
function DrawCircle(alpha) 
	circle = glCreateList(function()
	glBeginEnd(GL_TRIANGLE_FAN, function()	

		glColor(0, 0.8, 0.1, alpha) -- colour of effect 
		glVertex(0, 0, 0)
		glColor(0,0,0,0)

		for i=0,num_segs do 
			glVertex(xcoords_small[i],0,zcoords_small[i])						
		end
		
	end)
	end)	
	return circle	
end

--init
local runsetup = false
function gadget:Initialize()
	--register actions to SendToUnsynced messages
	gadgetHandler:AddSyncAction("UpdateList", UpdateList)
	gadgetHandler:AddSyncAction("AddToCenters",AddToCenters)
	gadgetHandler:AddSyncAction("RemoveFromCenters", RemoveFromCenters)
	
	SetupCircles()
end


--Actions called from synced
local centers = {}
function AddToCenters(_,counter,px,py,pz,curtime)
	local junoExpl = {x=px, y=py, z=pz, t=curtime}
	centers[counter] = junoExpl
end

function RemoveFromCenters(_,counter)
	table.remove(centers,counter)
end


--set up x and z coords for circle drawing
function SetupCircles()
	--compute coords for drawing small circles
	local x = width + fadedist
	local z = 0 
	
	for i=0,num_segs do
		xcoords_small[i] = x
		zcoords_small[i] = z
		
		local t = x
		x = c*x - s*z
		z = s*t + c*z
	end
	
	--set up list with small circle
	FadedCircle = DrawCircle(alpha)

	
	--compute incremental coords for placing small circles to draw a big circle
	x = radius - (width + fadedist) / 2
	z = 0
	local xcoords = {}
	local zcoords = {}
	for i=0,num_segments do
		xcoords[i] = x
		zcoords[i] = z
		
		local t = x
		x = cincr*x - sincr*z
		z = sincr*t + cincr*z
		
		if i==0 then --coord [0] stores the displacement (expl.x,expl.z) -> (expl.x,expl.z) + (center of first small circle to draw)
			xcoords_incr[0] = x
			zcoords_incr[0] = z
		else
			xcoords_incr[i] = xcoords[i] - xcoords[i-1]
			zcoords_incr[i] = zcoords[i] - zcoords[i-1]	
		end
	end
	
end

local ring 
local ran_num_table = {}
local ycoords_incr = {}
local runsetup = true

--Update display list
function UpdateList(_,curtime)
	--Spring.Echo("Updating display list")
	
	--set up constants for drawing ring
	for counter,expl in pairs(centers) do
		--set up random numbers, if needed
		if ran_num_table[counter]==nil then
			local ran_nums = {}
			for i=0,num_segments-1 do
				ran_nums[i] = Mrandom() 
			end
			ran_num_table[counter] = ran_nums				
		end		

		--set up y coords to match map height
		local q = 1
		if ((curtime-expl.t < fadetime) or (curtime > expl.t + effectlength - fadetime)) then
			q = (1/fadetime) * Mmin(curtime-expl.t, expl.t+effectlength-curtime) --controls movement outwards from center on fade in
		end
	
		local this_ycoords = {}
		local this_ycoords_incr = {}
		local x = expl.x
		local z = expl.z
		for i=0,num_segments do
			x = x + q*xcoords_incr[i]
			z = z + q*zcoords_incr[i]
			this_ycoords[i] = SpGetGroundHeight(x,z) 
		end
		this_ycoords_incr[0] = this_ycoords[0] + 9 --hover vertices a bit above ground to prevent drawing underground 
		for i=1,num_segments do
			this_ycoords_incr[i] = this_ycoords[i] - this_ycoords[i-1]
		end
		ycoords_incr[counter] = this_ycoords_incr
	end
	
	--remake list
	if ring then
		glDeleteList(ring)
	end
	ring = glCreateList(function()

	glDepthTest(GL_LEQUAL) --needed else it will draw on top of some trees/grass
	--gl.PolygonOffset(1,1)	
	
	for counter,expl in pairs(centers) do 
		local ycoords_incr = ycoords_incr[counter]
		local ran_num = ran_num_table[counter]
		
		if ((expl.t + fadetime <= curtime) and (curtime <= expl.t + effectlength - fadetime)) then --check if we are fading in/out or not
			glPushMatrix()	
			glTranslate(expl.x,0,expl.z)
			for i=0,num_segments-1 do 
				glTranslate(xcoords_incr[i], ycoords_incr[i], zcoords_incr[i])
				glCallList(FadedCircle)
			end
			glPopMatrix()
		else
			local q = (1/fadetime) * Mmin(curtime-expl.t, expl.t+effectlength-curtime) --tent function, |slope|=1/fadetime, up at expl.t and back down to expl.t+effectlength. controls 'fade' in/out.
			local p = q 
			
			if q>0 then
				if (curtime-expl.t <= fadetime) then -- controls the non-linearity in amount of tsuff drawn during the fade in/out
					p = Mpow(p,3)
				else
					p = Mmin(1,Mpow((5/2)*p,3/2))
				end
			
				glPushMatrix()	
				glTranslate(expl.x,0,expl.z)
				for i=0,num_segments-1 do 
					glTranslate(q * xcoords_incr[i], ycoords_incr[i], q * zcoords_incr[i])
					if (ran_num[i] <= p) then
						glCallList(FadedCircle)
					end
				end
				glPopMatrix()
			end
		end
	end
	
	end)

end


--draw
function gadget:DrawWorldPreUnit()
	if ring then
		glCallList(ring)
	end
end





end

