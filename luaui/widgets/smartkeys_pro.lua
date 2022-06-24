function widget:GetInfo()
   return {
      name = "Smartkeys pro",
      desc = "zxcv hotkeys auto select the nearest highest tech builder. First it will search next to your cursor then it will search the whole map. Based on if cursor is over land or sea",
      author = "Ares",
      license = "GNU GPL, v2 or later",
      layer = 0,
      enabled = true
   }
end

include("keysym.h.lua")
local BuilderDef = {}
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
local isT2con = {
   [UnitDefNames["armaca"].id] = true,
   [UnitDefNames["armacv"].id] = true,
   [UnitDefNames["armack"].id] = true,
   [UnitDefNames["armacsub"].id] = true,
   [UnitDefNames["coraca"].id] = true,
   [UnitDefNames["coracv"].id] = true,
   [UnitDefNames["corack"].id] = true,
   [UnitDefNames["coracsub"].id] = true
}

function widget:PlayerChanged(playerID)
   if Spring.IsReplay() or (Spring.GetSpectatingState() and Spring.GetGameFrame() > 0) then
      widgetHandler:RemoveWidget()
   end
   myTeamID = Spring.GetMyTeamID()
end

function widget:Initialize()
   if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
      widget:PlayerChanged()
   end
end

for udid, udef in pairs(UnitDefs) do
   if udef.isBuilder and not udef.isFactory and (#udef.buildOptions > 0) then
      BuilderDef[udid] = udid
   end
end

local desiredcommand
local commandframenumber = 0
local currentframenumber = 0

function widget:KeyPress(key, modifier, isRepeat)
   if not (modifier.shift or modifier.ctrl or modifier.alt or modifier.meta) then
      if (#Spring.GetSelectedUnits() == 0) then
         if key == KEYSYMS.Z or key == KEYSYMS.X or key == KEYSYMS.C or key == KEYSYMS.V then
            local mx, my = Spring.GetMouseState()
            local _, pos = Spring.TraceScreenRay(mx, my, true, true, true, true)
            local groundheight = Spring.GetGroundHeight(pos[1], pos[3])
            local wantLandBuilder = true
            if groundheight >= 0 then
               wantLandBuilder = true
            else
               wantLandBuilder = false
            end
            local bestMatchingBuilderID = bestBuilderInDistance(300, pos, wantLandBuilder, false)
            if bestMatchingBuilderID == nil then
               bestMatchingBuilderID = bestBuilderInDistance(10000, pos, wantLandBuilder, true)
            end
            if bestMatchingBuilderID ~= nil  then
               Spring.SelectUnitArray({bestMatchingBuilderID}, false)
               local unitdefid = Spring.GetUnitDefID(bestMatchingBuilderID)
               local unit = UnitDefs[unitdefid]
               local userSym, defSym = Spring.GetKeySymbol(key)
               local found = false
               for _, keybind in ipairs(Spring.GetKeyBindings(defSym)) do
                  if found == true then break end
                  if string.sub(keybind.command, 1, 10) == 'buildunit_' then
                     local uDefName = string.sub(keybind.command, 11)
                     local uDef = UnitDefNames[uDefName]
                     for j, option in ipairs(unit.buildOptions) do
                        if found == true then break end
                        if (option == uDef.id) then
                           desiredcommand = keybind.command
                           found = true
                        end
                     end
                  end
               end

            end
         end
      end
   end
   commandframenumber = currentframenumber
end

function bestBuilderInDistance(distance, pos, wantLandBuilder, selectwholemap)
   local t2BuilderForCorrectTerrainFoundExistsAlready = false
   local t1BuilderForCorrectTerrainFoundExistsAlready = false
   local t2BuilderForWrongTerrainFoundExistsAlready = false
   local t1BuilderForWrongTerrainFoundExistsAlready = false
   local bestMatchingBuilderDistance = 9999999
   local units
   local bestMatchingBuilderID = nil
   if not selectwholemap then
      units = Spring.GetUnitsInSphere(pos[1], pos[2], pos[3], distance, Spring.GetMyTeamID())
   else
      units = Spring.GetTeamUnits(Spring.GetMyTeamID())
   end
   for i = 1, #units do
      local unitID = units[i]
      local unitdefid = Spring.GetUnitDefID(unitID)
      if BuilderDef[unitdefid] then
         local t2BuilderForCorrectTerrainFound = false
         local t1BuilderForCorrectTerrainFound = false
         local t2BuilderForWrongTerrainFound = false
         local t1BuilderForWrongTerrainFound = false
         if wantLandBuilder then
            if canbuildonlandorsea[unitdefid] or canonlybuildonland[unitdefid] then
               if (isT2con[unitdefid]) then
                  t2BuilderForCorrectTerrainFound = true
               else
                  t1BuilderForCorrectTerrainFound = true
               end
            else
               if (isT2con[unitdefid]) then
                  t2BuilderForWrongTerrainFound = true
               else
                  t1BuilderForWrongTerrainFound = true
               end
            end
         else
            if canbuildonlandorsea[unitdefid] or canonlybuildonsea[unitdefid] then
               if (isT2con[unitdefid]) then
                  t2BuilderForCorrectTerrainFound = true
               else
                  t1BuilderForCorrectTerrainFound = true
               end
            else
               if (isT2con[unitdefid]) then
                  t2BuilderForWrongTerrainFound = true
               else
                  t1BuilderForWrongTerrainFound = true
               end
            end
         end
         if t2BuilderForCorrectTerrainFound or t1BuilderForCorrectTerrainFound or t2BuilderForWrongTerrainFound or t1BuilderForWrongTerrainFound then
            if t2BuilderForCorrectTerrainFound then
               local uposx, uposy, uposz = Spring.GetUnitPosition(unitID)
               local distanceFromUnitToCursor = math.sqrt(math.pow(pos[1] - uposx, 2) + math.pow(pos[3] - uposz, 2))
               if not t2BuilderForCorrectTerrainFoundExistsAlready then
                  bestMatchingBuilderDistance = distanceFromUnitToCursor
                  bestMatchingBuilderID = unitID
               else
                  if distanceFromUnitToCursor < bestMatchingBuilderDistance then
                     bestMatchingBuilderDistance = distanceFromUnitToCursor
                     bestMatchingBuilderID = unitID
                  end
               end
               t2BuilderForCorrectTerrainFoundExistsAlready = true
            elseif t1BuilderForCorrectTerrainFound and not t2BuilderForCorrectTerrainFoundExistsAlready then
               local uposx, uposy, uposz = Spring.GetUnitPosition(unitID)
               local distanceFromUnitToCursor = math.sqrt(math.pow(pos[1] - uposx, 2) + math.pow(pos[3] - uposz, 2))
               if not t1BuilderForCorrectTerrainFoundExistsAlready then
                  bestMatchingBuilderDistance = distanceFromUnitToCursor
                  bestMatchingBuilderID = unitID
               else
                  if distanceFromUnitToCursor < bestMatchingBuilderDistance then
                     bestMatchingBuilderDistance = distanceFromUnitToCursor
                     bestMatchingBuilderID = unitID
                  end
               end
               t1BuilderForCorrectTerrainFoundExistsAlready = true
            elseif t2BuilderForWrongTerrainFound and not t1BuilderForCorrectTerrainFoundExistsAlready and not t2BuilderForCorrectTerrainFoundExistsAlready  then
               local uposx, uposy, uposz = Spring.GetUnitPosition(unitID)
               local distanceFromUnitToCursor = math.sqrt(math.pow(pos[1] - uposx, 2) + math.pow(pos[3] - uposz, 2))
               if not t2BuilderForWrongTerrainFoundExistsAlready then
                  bestMatchingBuilderDistance = distanceFromUnitToCursor
                  bestMatchingBuilderID = unitID
               else
                  if distanceFromUnitToCursor < bestMatchingBuilderDistance then
                     bestMatchingBuilderDistance = distanceFromUnitToCursor
                     bestMatchingBuilderID = unitID
                  end
               end
               t2BuilderForWrongTerrainFoundExistsAlready = true
            elseif t1BuilderForWrongTerrainFound and not t2BuilderForWrongTerrainFoundExistsAlready and not t1BuilderForCorrectTerrainFoundExistsAlready and not t2BuilderForCorrectTerrainFoundExistsAlready then
               local uposx, uposy, uposz = Spring.GetUnitPosition(unitID)
               local distanceFromUnitToCursor = math.sqrt(math.pow(pos[1] - uposx, 2) + math.pow(pos[3] - uposz, 2))
               if not t1BuilderForWrongTerrainFoundExistsAlready then
                  bestMatchingBuilderDistance = distanceFromUnitToCursor
                  bestMatchingBuilderID = unitID
               else
                  if distanceFromUnitToCursor < bestMatchingBuilderDistance then
                     bestMatchingBuilderDistance = distanceFromUnitToCursor
                     bestMatchingBuilderID = unitID
                  end
               end
               t1BuilderForWrongTerrainFoundExistsAlready = true
            end
         end
      end
   end
   return bestMatchingBuilderID
end

function widget:GameFrame(framenumber)
   currentframenumber = framenumber
   if desiredcommand ~= nil and currentframenumber > commandframenumber+1 then
      Spring.SetActiveCommand(desiredcommand, 1, true, false, Spring.GetModKeyState())
      desiredcommand = nil
   end
end