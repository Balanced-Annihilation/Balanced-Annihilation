function gadget:GetInfo()
	return {
		name = "Evolving SeaCommanders",
		desc = "Evolves SeaCommanders based on xp",
		author = "[Fx]Doo",
		date = "1st of July 2017",
		license = "Free",
		layer = 0,
		enabled = true
	}
end


if (gadgetHandler:IsSyncedCode()) then
    ARMCOMMANDER1 = {}
    ARMCOMMANDER2 = {}
    ARMCOMMANDER3 = {}
    ARMCOMMANDER4 = {}
    ARMCOMMANDER5 = {}
	ARMCOMMANDER6 = {}
    CORCOMMANDER1 = {}
    CORCOMMANDER2 = {}
    CORCOMMANDER3 = {}
    CORCOMMANDER4 = {}
    CORCOMMANDER5 = {}
	CORCOMMANDER6 = {}
	COMMANDERS = {}
    function gadget:UnitCreated(unitID) -- add COMMANDER[unitID] and ARMCOMMANDER2[unitID] upon creation
        unitDefID = Spring.GetUnitDefID(unitID)
        unitName = UnitDefs[unitDefID].name
        if unitName == "armseacom" then
            ARMCOMMANDER1[unitID] = true
			COMMANDERS[unitID] = true
        end
        if unitName == "armseacom2" then
            ARMCOMMANDER2[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom3" then
            ARMCOMMANDER3[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom4" then
            ARMCOMMANDER4[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom5" then
            ARMCOMMANDER5[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom6" then
            ARMCOMMANDER6[unitID] = true
			COMMANDERS[unitID] = true
        end
		        if unitName == "armseacom" then
            CORCOMMANDER1[unitID] = true
			COMMANDERS[unitID] = true
        end
        if unitName == "armseacom2" then
            CORCOMMANDER2[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom3" then
            CORCOMMANDER3[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom4" then
            CORCOMMANDER4[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom5" then
            CORCOMMANDER5[unitID] = true
			COMMANDERS[unitID] = true
        end
		if unitName == "armseacom6" then
            CORCOMMANDER6[unitID] = true
			COMMANDERS[unitID] = true
        end
    end

    function gadget:GameFrame(f)
	-- Spring.Echo("working")
		for unitID, COMM in pairs(COMMANDERS) do
			local _,_,_,vw = Spring.GetUnitVelocity(unitID) 
			if vw then
				local a,oldexp = Spring.GetUnitExperience(unitID)
					if ARMCOMMANDER1[unitID] then
						newexp = a + (vw*0.00004)			
					end
					if ARMCOMMANDER2[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4))			
					end
					if ARMCOMMANDER3[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER4[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER5[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER6[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER1[unitID] then
						newexp = a + (vw*0.00004)			
					end
					if CORCOMMANDER2[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4))			
					end
					if CORCOMMANDER3[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER4[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER5[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER6[unitID] then
						newexp = a + (vw*0.00004*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end

				-- Spring.Echo(a)
				if newexp > a then
					Spring.SetUnitExperience(unitID, newexp)
					newexp = nil
				end
			end
			local mm, mu, em, eu = Spring.GetUnitResources(unitID)

			if eu >0 or mu >0 then
				local a,oldexp = Spring.GetUnitExperience(unitID)
							-- Spring.Echo(eu)
			-- Spring.Echo(a)
					if ARMCOMMANDER1[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005)			
					end
					if ARMCOMMANDER2[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4))			
					end
					if ARMCOMMANDER3[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER4[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER5[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if ARMCOMMANDER6[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER1[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005)			
					end
					if CORCOMMANDER2[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4))			
					end
					if CORCOMMANDER3[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER4[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER5[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
					if CORCOMMANDER6[unitID] then
						newexp = a + (((eu/60) + mu)*0.000005*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4)*(3/4))			
					end
				if newexp > a then
								-- Spring.Echo(oldexp)
								-- Spring.Echo(a)
					Spring.SetUnitExperience(unitID, newexp)
					newexp = nil
				end
				
			end
		end
		
        for unitID, ARMCOMM1 in pairs(ARMCOMMANDER1) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom2", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
		        for unitID, ARMCOMM2 in pairs(ARMCOMMANDER2) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom3", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
		        for unitID, ARMCOMM3 in pairs(ARMCOMMANDER3) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom4", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		        for unitID, ARMCOMM4 in pairs(ARMCOMMANDER4) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom5", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
				        for unitID, ARMCOMM5 in pairs(ARMCOMMANDER5) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom6", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
        for unitID, CORCOMM1 in pairs(CORCOMMANDER1) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom2", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
		        for unitID, CORCOMM2 in pairs(CORCOMMANDER2) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom3", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
		        for unitID, CORCOMM3 in pairs(CORCOMMANDER3) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom4", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		        for unitID, CORCOMM4 in pairs(CORCOMMANDER4) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom5", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
				        for unitID, CORCOMM5 in pairs(CORCOMMANDER5) do -- check all COMMANDER submarines
		null, fxp = Spring.GetUnitExperience(unitID)
		realxp = 10 * fxp
			-- Spring.Echo(realxp)
			if realxp >= 5 then
			hp,maxhp,para,capture,_ = Spring.GetUnitHealth(unitID)
			x,y,z = Spring.GetUnitPosition(unitID)
			rx, ry, rz = Spring.GetUnitRotation(unitID)
			team = Spring.GetUnitTeam(unitID)
			newid = Spring.CreateUnit("armseacom6", x, y, z, 0, team, false, false)
				if (newid) then
					Spring.DestroyUnit(unitID, false, true)
					Spring.SetUnitHealth(newid, {health = hp, capture = capture, paralyze = para})
					Spring.SetUnitRotation(newid, rx, ry, rz)
				end
			end
        end
		
    end

    function gadget:UnitDestroyed(unitID) -- Clear COMMANDER[unitID] and ARMCOMMANDER2[unitID] upon death
        if ARMCOMMANDER1[unitID] then
            ARMCOMMANDER1[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if ARMCOMMANDER2[unitID] then
            ARMCOMMANDER2[unitID] = nil
			COMMANDERS[unitID] = nil
        end
		if ARMCOMMANDER3[unitID] then
            ARMCOMMANDER3[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if ARMCOMMANDER4[unitID] then
            ARMCOMMANDER4[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if ARMCOMMANDER5[unitID] then
            ARMCOMMANDER5[unitID] = nil
			COMMANDERS[unitID] = nil
        end
		if ARMCOMMANDER6[unitID] then
		    ARMCOMMANDER6[unitID] = nil
			COMMANDERS[unitID] = nil
		end
		if CORCOMMANDER1[unitID] then
            CORCOMMANDER1[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if CORCOMMANDER2[unitID] then
            CORCOMMANDER2[unitID] = nil
			COMMANDERS[unitID] = nil
        end
		if CORCOMMANDER3[unitID] then
            CORCOMMANDER3[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if CORCOMMANDER4[unitID] then
            CORCOMMANDER4[unitID] = nil
			COMMANDERS[unitID] = nil
        end
        if CORCOMMANDER5[unitID] then
            CORCOMMANDER5[unitID] = nil
			COMMANDERS[unitID] = nil
        end
		if CORCOMMANDER6[unitID] then
		    CORCOMMANDER6[unitID] = nil
			COMMANDERS[unitID] = nil
		end
    end
end