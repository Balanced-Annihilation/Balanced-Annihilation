
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

--config --
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
		counter = counter + 1 		
	end
end

function gadget:GameFrame(frame)
	
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
			table.remove(centers, counter)
		end
	end
end

end
