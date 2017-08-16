function gadget:GetInfo()
	return {
		name = "AutoAreaRepair Gadget",
		desc = "Passive area repair depending on customParams",
		author = "[Fx]Doo",
		date = "1st of July 2017",
		license = "Free",
		layer = 0,
		enabled = true
	}
end


if (gadgetHandler:IsSyncedCode()) then
    PASSIVEREPAIRER = {}
	PassiveRepair = {}
	
function gadget:Initialize()
    for uDefID, uDef in pairs(UnitDefs) do
			PassiveRepair[uDefID] = {}
			PassiveRepair[uDefID].active = uDef.customParams and uDef.customParams.passiverepaireractive or 0
			PassiveRepair[uDefID].range = uDef.customParams and uDef.customParams.passiverepairerrange or 0				
			PassiveRepair[uDefID].ratio = uDef.customParams and uDef.customParams.passiverepairerratio or 0	
    end
end

    function gadget:UnitCreated(unitID)
		UnitDefID = Spring.GetUnitDefID(unitID)
		if (PassiveRepair[UnitDefID]) then
			if (PassiveRepair[UnitDefID].active == "1") then
				PASSIVEREPAIRER[unitID] = {
				active = tonumber(PassiveRepair[UnitDefID].active) or 1,
				range = tonumber(PassiveRepair[UnitDefID].range) or 350,			
				ratio = tonumber(PassiveRepair[UnitDefID].ratio) or 0.5,
				}
			end
		end
    end

    function gadget:GameFrame(f)
        for unitID, repairer in pairs(PASSIVEREPAIRER) do
			x,y,z = Spring.GetUnitPosition(unitID)
			local unittable = Spring.GetUnitsInSphere(x, y, z, repairer.range)
				for _, uid in pairs(unittable) do
					if uid ~= unitID then
						if Spring.AreTeamsAllied(Spring.GetUnitTeam(unitID), Spring.GetUnitTeam(uid)) == true then
							local oldhp2, maxhp2,_,_,bprog = Spring.GetUnitHealth(uid)
							if oldhp2 / maxhp2 <= bprog then
								if oldhp2 >0 then
									local unit2DefID = Spring.GetUnitDefID(uid)
									local unit1DefID = Spring.GetUnitDefID(unitID)
									local buildTime2S = UnitDefs[unit2DefID].buildTime
									local workerTime1S = UnitDefs[unit1DefID].buildSpeed
									local workerTime1F = workerTime1S / 30
									local areaRepairTime1 = repairer.ratio * workerTime1F
									local HPRepairPerFrame = (maxhp2 / buildTime2S) * areaRepairTime1
									local newhp2 = oldhp2 + HPRepairPerFrame
									if newhp2 > maxhp2*bprog then
										newhp2 = maxhp2
									end
									Spring.SetUnitHealth(uid, newhp2)	
								end
							end
						end
					end
				end
					
		end
    end

    function gadget:UnitDestroyed(unitID)
		if PASSIVEREPAIRER[unitID] then
			PASSIVEREPAIRER[unitID] = nil
		end
    end
end

