function widget:GetInfo()
   return {
      name = "Smartguard Pro",
	  desc = "Build creator will be guarded by any selected lower tech builders who would otherwise idle (eg t1 will auto guard a t2 making mex). Only the creator builder will remain selected. (for selections up to 10 units)",
	  author = "Ares",
      license = "GNU GPL, v2 or later",
      layer = 0,
      enabled = true
   }
end

local seabuilding = {}
for unitDefID, unitDef in pairs(UnitDefs) do
   if unitDef.minWaterDepth > 0 then
      seabuilding[unitDefID] = true
   end
end

local canonlybuildonland = {
   [UnitDefNames["corck"].id] = true,
   [UnitDefNames["armck"].id] = true,
   [UnitDefNames["corack"].id] = true,
   [UnitDefNames["armack"].id] = true,
   [UnitDefNames["corcv"].id] = true,
   [UnitDefNames["armcv"].id] = true,
   [UnitDefNames["coracv"].id] = true,
   [UnitDefNames["armacv"].id] = true,
   [UnitDefNames["corfast"].id] = true,
   [UnitDefNames["armfark"].id] = true,
   [UnitDefNames["consul"].id] = true
}

local canonlybuildonsea = {
   [UnitDefNames["corcs"].id] = true,
   [UnitDefNames["armcs"].id] = true,
   [UnitDefNames["armmls"].id] = true,
   [UnitDefNames["cormls"].id] = true,
   [UnitDefNames["armacsub"].id] = true,
   [UnitDefNames["coracsub"].id] = true
}

local canbuildonlandorsea = {
   [UnitDefNames["corca"].id] = true,
   [UnitDefNames["armca"].id] = true,
   [UnitDefNames["coraca"].id] = true,
   [UnitDefNames["armaca"].id] = true,
   [UnitDefNames["armcom"].id] = true,
   [UnitDefNames["corcom"].id] = true,
   [UnitDefNames["armdecom"].id] = true,
   [UnitDefNames["cordecom"].id] = true,
   [UnitDefNames["corcsa"].id] = true,
   [UnitDefNames["armcsa"].id] = true,
   [UnitDefNames["cormuskrat"].id] = true,
   [UnitDefNames["armbeaver"].id] = true,
   [UnitDefNames["corch"].id] = true,
   [UnitDefNames["armch"].id] = true
}

function widget:CommandNotify(id, params, cmdOptions)
   local numunits = Spring.GetSelectedUnitsCount()
   if (numunits > 1 and numunits < 11 and id < 0) then
      local units = Spring.GetSelectedUnits()
      local buildersthatcanguard = {}
      local buildersthatcanguardcounter = 0
      local abuildertoguardisfound = false
      local buildertype
      local selectedbuilders = {}
      buildersthatcanguardcounter = 1
      for i = 1, #units do
         local unitisbuilding = false
         local unitdefid = Spring.GetUnitDefID(units[i])
         if(buildertype == unitdefid) then
            unitisbuilding = true
            selectedbuilders[units[i]] = true
         end
         local unit = UnitDefs[unitdefid]
		 local found = false
         for j, option in ipairs(unit.buildOptions) do
			if found == true then break end
            if (option == -id) then
               selectedbuilders[units[i]] = true
               unittoguard = units[i]
               unitisbuilding = true
               abuildertoguardisfound = true
               buildertype = unitdefid
			   found = true
            end
         end 
         if (not unitisbuilding) then
            if seabuilding[-id] then
               if canbuildonlandorsea[unitdefid] or canonlybuildonsea[unitdefid] then
                  buildersthatcanguard[buildersthatcanguardcounter] = units[i]
                  buildersthatcanguardcounter = buildersthatcanguardcounter + 1
               end
            else
               if canbuildonlandorsea[unitdefid] or canonlybuildonland[unitdefid] then
                  buildersthatcanguard[buildersthatcanguardcounter] = units[i]
                  buildersthatcanguardcounter = buildersthatcanguardcounter + 1
               end
            end
         end
      end
      if (#buildersthatcanguard > 0) then
         Spring.GiveOrderToUnitArray(buildersthatcanguard, CMD.STOP,{}, 0)
         Spring.SelectUnitMap(selectedbuilders, false)
         Spring.GiveOrderToUnitArray(buildersthatcanguard, CMD.GUARD, unittoguard, 0)
      end
   end
end

function widget:Initialize()
   if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
      widget:PlayerChanged()
   end
end

function widget:PlayerChanged(playerID)
   if Spring.IsReplay() or (Spring.GetSpectatingState() and Spring.GetGameFrame() > 0) then
      widgetHandler:RemoveWidget()
   end
end