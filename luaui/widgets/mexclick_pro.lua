function widget:GetInfo()
   return {
      name = "Mexclick Pro",
      desc = "left click metal to instantly build optimal mex (for selections up to 10 units). Applies smartguard logic to constructed mex.",
      author = "Ares",
      license = "GNU GPL, v2 or later",
      layer = 0,
      enabled = false,
   }
end

local seabuilding = {}
for unitDefID, unitDef in pairs(UnitDefs) do
   if unitDef.minWaterDepth > 0 then
      seabuilding[unitDefID] = true
   end
end

local ismex = {
   [UnitDefNames["armmex"].id] = true,
   [UnitDefNames["cormex"].id] = true,
   [UnitDefNames["armuwmex"].id] = true,
   [UnitDefNames["coruwmex"].id] = true,
   [UnitDefNames["armmoho"].id] = true,
   [UnitDefNames["cormoho"].id] = true,
   [UnitDefNames["coruwmme"].id] = true,
   [UnitDefNames["armuwmme"].id] = true
}

local seamex = {
   [UnitDefNames["armuwmex"].id] = true,
   [UnitDefNames["coruwmex"].id] = true,
   [UnitDefNames["coruwmme"].id] = true,
   [UnitDefNames["armuwmme"].id] = true
}

local landmex = {
   [UnitDefNames["armmex"].id] = true,
   [UnitDefNames["cormex"].id] = true,
   [UnitDefNames["armmoho"].id] = true,
   [UnitDefNames["cormoho"].id] = true
}

local isT2mex = {
   [UnitDefNames["armmoho"].id] = true,
   [UnitDefNames["cormoho"].id] = true,
   [UnitDefNames["coruwmme"].id] = true,
   [UnitDefNames["armuwmme"].id] = true
}

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

local ordermenuEdge
local BuilderDef = {}
local selectedbuilders = {}
local _, pos
local bestSpot
local mextobuild
local mextobuildland
local mextobuildlandist2 = false
local mextobuildsea
local mextobuildseaist2 = false
local selectedbuilderscount = 0
local metalSpots
local circlewidth = 0
local bestPosm

for udid, udef in pairs(UnitDefs) do
   if udef.isBuilder and not udef.isFactory and (#udef.buildOptions > 0) then
      BuilderDef[udid] = udid
   end
end

function widget:SelectionChanged(selectedunits, subselection)
   selectedbuilders = {}
   mextobuildland = nil
   mextobuildsea = nil
   mextobuildlandist2 = false
   mextobuildseaist2 = false
   local maxNumSelectedUnits = 11
   if #selectedunits < maxNumSelectedUnits then
      local highestmetalextractionamountland = 0
      local highestmetalextractionamountsea = 0
      local selectedunitscounter = 1
      for i = 1, #selectedunits do
         local unit = selectedunits[i]
         local unitdefid = Spring.GetUnitDefID(unit)
         if BuilderDef[unitdefid] then
            selectedbuilders[selectedunitscounter] = unit
            selectedunitscounter = selectedunitscounter + 1
            local unitdef = UnitDefs[unitdefid]
            for j, option in ipairs(unitdef.buildOptions) do
               if landmex[option] then
                  local buildunitdef = UnitDefs[option]
                  if buildunitdef.extractsMetal > highestmetalextractionamountland then
                     highestmetalextractionamountland = buildunitdef.extractsMetal
                     mextobuildland = option
                     if isT2mex[option] then
                        mextobuildlandist2 = true
                     end
                  end
               elseif seamex[option] then
                  local buildunitdef = UnitDefs[option]
                  if buildunitdef.extractsMetal > highestmetalextractionamountsea then
                     highestmetalextractionamountsea = buildunitdef.extractsMetal
                     mextobuildsea = option
                     if isT2mex[option] then
                        mextobuildseaist2 = true
                     end
                  end
               end
            end
         end
      end
   end
   selectedbuilderscount = #selectedbuilders
end

function widget:GameFrame(gameFrame)
   if (selectedbuilderscount > 0) then
      local mx, my = Spring.GetMouseState()
      _, pos = Spring.TraceScreenRay(mx, my, true, true, true, true)
      if mx > ordermenuEdge then
         local bestDist = math.huge
         local spot
         local dx, dz
         local dist
         for i = 1, #metalSpots do
            spot = metalSpots[i]
            dx, dz = pos[1] - spot.x, pos[3] - spot.z
            dist = dx * dx + dz * dz
            if dist < bestDist then
               bestDist = dist
               bestSpot = spot
            end
         end
         local _, cmdID = Spring.GetActiveCommand()
         local cs = Spring.GetCameraState()
         local gy = Spring.GetGroundHeight(cs.px, cs.pz)
         local cameraHeight = 0
         if cs.name == "ta" then
            cameraHeight = cs.height - gy
         else
            cameraHeight = cs.py - gy
         end
         local snapradius = 0
         if cameraHeight < 2000 then
            snapradius = 10000
            circlewidth = 70
         elseif cameraHeight >= 2000 and cameraHeight < 4000 then
            snapradius = 15000
            circlewidth = 80
         elseif cameraHeight >= 4000 and cameraHeight < 6000 then
            snapradius = 20000
            circlewidth = 90
         elseif cameraHeight >= 6000 and cameraHeight < 8000 then
            snapradius = 30000
            circlewidth = 100
         elseif cameraHeight >= 6000 then
            snapradius = 40000
            circlewidth = 110
         end
         if(bestDist < snapradius and cmdID == nil) then
            if emptyMex(bestSpot.x, bestSpot.z) then
               local groundheight = Spring.GetGroundHeight(pos[1], pos[3])
               if groundheight >= 0 then
                  mextobuild = mextobuildland
               else
                  mextobuild = mextobuildsea
               end
            end
         else
            mextobuild = nil
         end
      else
         mextobuild = nil
      end
   else
      mextobuild = nil
   end
end

function emptyMex(x, z)
   local mexesatspot = Spring.GetUnitsInCylinder(x, z, Game.extractorRadius)
   if mextobuildlandist2 or mextobuildseaist2 then
      for ct, uid in pairs(mexesatspot) do
         if isT2mex[Spring.GetUnitDefID(uid)] then
            return false
         end
      end
   else
      for ct, uid in pairs(mexesatspot) do
         if ismex[Spring.GetUnitDefID(uid)] then
            return false
         end
      end
   end
   return true
end

function widget:DrawWorld()
   if mextobuild ~= nil then
      local bestDistm = math.huge
      local positionsm = WG.GetMexPositions(bestSpot, mextobuild, Spring.GetBuildFacing(), true)
      local mpos
      local dxm, dzm
      local distm
      for i = 1, #positionsm do
         mpos = positionsm[i]
         dxm, dzm = pos[1] - mpos[1], pos[3] - mpos[3]
         distm = dxm * dxm + dzm * dzm
         if distm < bestDistm then
            bestPosm = mpos
            bestDistm = distm
         end
      end
      gl.DepthTest(false)
      gl.Color(1, 1, 1, 0.5)
      gl.PushMatrix()
      gl.Translate(bestPosm[1], bestPosm[2], bestPosm[3])
      gl.Rotate(90 * Spring.GetBuildFacing(), 0, 1, 0)
      gl.UnitShape(mextobuild, Spring.GetMyTeamID(), false, true, false)
      gl.PopMatrix()
      gl.DepthTest(false)
      gl.DepthMask(false)
      gl.LineWidth(2.5)
      gl.Color(0.15, 1, 0.2, 1)
      gl.DrawGroundCircle(bestSpot.x, 0, bestSpot.z, circlewidth, 32)
   end
end

function widget:MousePress(x, y, button)
   if button == 1 then
      local alt, ctrl, meta, shiftkey = Spring.GetModKeyState()
      if shiftkey then
         cmdOpts = {"shift"}
      else
         cmdOpts = 0
      end
      if mextobuild ~= nil and selectedbuilderscount > 0 then
         Spring.GiveOrderToUnitArray(Spring.GetSelectedUnits(),-mextobuild, {bestPosm[1], bestPosm[2], bestPosm[3]}, cmdOpts)
         local numunits = Spring.GetSelectedUnitsCount()
         if numunits > 1 and numunits < 10 then
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
                  if (option == mextobuild) then
                     selectedbuilders[units[i]] = true
                     unittoguard = units[i]
                     unitisbuilding = true
                     abuildertoguardisfound = true
                     buildertype = unitdefid
                     found = true
                  end
               end
               if not unitisbuilding then
                  if seabuilding[mextobuild] then
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
         return true
      end
   end
end

function widget:PlayerChanged(playerID)
   if Spring.IsReplay() or (Spring.GetSpectatingState() and Spring.GetGameFrame() > 0) then
      widgetHandler:RemoveWidget()
   end
end

function widget:Initialize()
   metalSpots = WG.metalSpots
   if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
      widget:PlayerChanged()
   end
   widget:ViewResize()
end

function widget:ViewResize()
   local vsx, vsy
   local width
   vsx, vsy = Spring.GetViewGeometry()
   width = 0.184
   width = width / (vsx / vsy) * 1.78
   ordermenuEdge = (width) * vsx
end
