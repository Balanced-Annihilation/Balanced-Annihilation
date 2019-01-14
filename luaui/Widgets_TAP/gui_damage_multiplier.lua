--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_damage_multiplier.lua
--  version: 1.00
--  brief:   Displays red circles corresponding to damage multipliers, when SHIFT is held
--  original author: Adriano Lima (adrianulima)
--  Date: 2018
--  Public Domain.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        version   = "0.1",
        name      = "GUI Damage Multiplier",
        desc      = "",
        author    = "Adrianulima",
        date      = "WIP",
        license   = "GNU GPL, v2 or later",
        enabled   = true  --  loaded by default?
    }
end

local damageMults = VFS.Include("gamedata/configs/damagemultipliers.lua")
local weaponDmgTypes = VFS.Include("gamedata/configs/weapondamagetypes.lua")

local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glPopMatrix = gl.PopMatrix
local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glScale = gl.Scale
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList
local glBeginEnd = gl.BeginEnd
local glVertex = gl.Vertex
local GL_LINE_LOOP = GL.LINE_LOOP

local PI = math.pi
local cos = math.cos
local sin = math.sin
local circleDivs = 16
local circleList

local vlowDmgColor  = { 1, 0, 0, 0.35}
local lowDmgColor   = { 1, 0.5, 0, 0.35}
local avgDmgColor   = { 0.25, 0.25, 0.25, 0.5}
local goodDmgColor  = { 0, 0.75, 0, 0.4}
local vgoodDmgColor = { 0, 1, 0, 0.5}

--------------------------------------------------------------------------------

local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spGetUnitDefID = Spring.GetUnitDefID
local spGetVisibleUnits = Spring.GetVisibleUnits
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetModKeyState = Spring.GetModKeyState
local spTraceScreenRay = Spring.TraceScreenRay
local spGetMouseState = Spring.GetMouseState

local uDefs = UnitDefs
local wDefs = WeaponDefs

--------------------------------------------------------------------------------
local function UnitCircleVertices()
    for i = 1, circleDivs do
        local theta = 2 * PI * i / circleDivs
        glVertex(cos(theta), 0, sin(theta))
    end
end
local function DrawUnitCircle()
    glBeginEnd(GL_LINE_LOOP, UnitCircleVertices)
end
local function SetupDisplayLists()
    circleList = glCreateList(DrawUnitCircle)
end
local function DrawCircle(x, y, z, radius)
    glPushMatrix()
    glTranslate(x, y, z)
    glScale(radius, radius, radius)
    glCallList(circleList)
    glPopMatrix()
end

--------------------------------------------------------------------------------
function widget:Initialize()
    SetupDisplayLists()
end

function widget:DrawWorld()
    local _, _, _, shift = spGetModKeyState()
    if not shift then
        return true end
    local mx, my = spGetMouseState()
    local rType, unitID = spTraceScreenRay(mx, my)
    local uID
    if rType == 'unit' then uID = unitID end
    if not uID then
        local selUnits = spGetSelectedUnits()
        if #selUnits >= 1 then uID = selUnits[1]
        else
            return true end
    end

    local uDefID = spGetUnitDefID(uID)
    local uDef = uDefs[uDefID]

    if not uDef then
        return end

    local wepCounts = {}
    local wepsCompact = {}
    local weaponNums = {}
    local uWeps = uDef.weapons
    for i = 1, #uWeps do
        local wDefID = uWeps[i].weaponDef
        local wCount = wepCounts[wDefID]
        if wCount then
            wepCounts[wDefID] = wCount + 1
        else
            wepCounts[wDefID] = 1
            wepsCompact[#wepsCompact + 1] = wDefID
            weaponNums[#wepsCompact] = i
        end
    end

    local visibleUnits = spGetVisibleUnits(Spring.ENEMY_UNITS, nil, false)
    for i=1, #visibleUnits do
        local unit = visibleUnits[i]
        local unitDefID = spGetUnitDefID(unit)
        local unitDef = uDefs[unitDefID]

        if #wepsCompact == 0 then return true end
        local damage = 0
        for i = 1, #wepsCompact do
            local wDefId = wepsCompact[i]
            local uWep = wDefs[wDefId]
            local weapDmgType = weaponDmgTypes[uDef.name] and weaponDmgTypes[uDef.name][uWep.description]

            if damageMults[weapDmgType] then
                local dmg = damageMults[weapDmgType][Game.armorTypes[unitDef.armorType or 0]] or 0
                damage = math.max(dmg, damage)
            end
        end

        local color = vlowDmgColor
        if (damage > 0.3 and damage <= 0.5) then
            color = lowDmgColor
        elseif (damage > 0.51 and damage <= 1.1) then
            color = avgDmgColor
        elseif (damage > 1.1 and damage <= 2) then
            color = goodDmgColor
        elseif (damage > 2) then
            color = vgoodDmgColor
        end

        local ux, uy, uz = spGetUnitViewPosition(unit)
        glColor(color)
        glLineWidth(16)
        DrawCircle(ux, uy, uz, 16)
    end
end

function widget:Shutdown()
    glDeleteList(circleList)
end
