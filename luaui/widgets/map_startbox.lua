--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    minimap_startbox.lua
--  brief:   shows the startboxes in the minimap
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "Start Boxes",
        desc = "Displays Start Boxes and Start Points",
        author = "trepan, jK",
        date = "2007-2009",
        license = "GNU GPL, v2 or later",
        layer = 0,
        enabled = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if Game.startPosType ~= 2 then
    return false
end

if Spring.GetGameFrame() > 1 then
    widgetHandler:RemoveWidget(self)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  config options
--

local fontfile = "fonts/" .. Spring.GetConfigString("ba_font", "FreeSansBold.otf")
local vsx, vsy = Spring.GetViewGeometry()
local fontfileScale = 0.5 + (vsx * vsy / 5700000)
local fontfileSize = 50
local fontfileOutlineSize = 8
local fontfileOutlineStrength = 1.65
local fontfileOutlineStrength2 = 10
local font = gl.LoadFont(fontfile, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)
local shadowFont = gl.LoadFont(fontfile, fontfileSize * fontfileScale, 35 * fontfileScale, 1.5)
local fontfile2 = "fonts/" .. Spring.GetConfigString("ba_font2", "FreeSansBold.otf")
local font2 = gl.LoadFont(fontfile2, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength2)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local useThickLeterring = false
local heightOffset = 120
local fontSize = 18
local fontShadow = true        -- only shows if font has a white outline
local shadowOpacity = 0.35

local infotext = "Pick a starting position and click the Ready button"
local infotextBoxes = "Pick a starting position within the green area, and click the Ready button"
local infotextFontsize = 13

local drawShadow = fontShadow
local usedFontSize = fontSize

local widgetScale = (1 + (vsx * vsy / 5500000))

local shaderPoint
local shaderPointViewLocation
local shaderPointProjLocation

local shaderCone
local shaderConeViewLocation
local shaderConeProjLocation

local gl = gl  --  use a local copy for faster access

local msx = Game.mapSizeX
local msz = Game.mapSizeZ

local isSpec = Spring.GetSpectatingState() or Spring.IsReplay()
local myTeamID = Spring.GetMyTeamID()

local placeVoiceNotifTimer = os.clock() + 35
local amPlaced = false

local gaiaTeamID
local gaiaAllyTeamID

local startTimer = Spring.GetTimer()

--------------------------------------------------------------------------------

local stencilBit1 = 0x01
local stencilBit2 = 0x10
local hasStartbox = false

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:PlayerChanged(playerID)
    isSpec = Spring.GetSpectatingState()
    myTeamID = Spring.GetMyTeamID()
end

local function DrawMyBox(minX, minY, minZ, maxX, maxY, maxZ, color)
    color = color or {1,1,1,1}

    local p1 = {minX, maxY, maxZ}
    local p2 = {maxX, maxY, maxZ}
    local p3 = {maxX, maxY, minZ}
    local p4 = {minX, maxY, minZ}
    local p5 = {minX, minY, maxZ}
    local p6 = {maxX, minY, maxZ}
    local p7 = {maxX, minY, minZ}
    local p8 = {minX, minY, minZ}

    -- top
    Spring.Draw.Rectangle(p1, p2, p3, p4, {color=color})
    -- bottom
    Spring.Draw.Rectangle(p8, p7, p6, p5, {color=color})
    -- front
    Spring.Draw.Rectangle(p5, p6, p2, p1, {color=color})
    -- back
    Spring.Draw.Rectangle(p7, p8, p4, p3, {color=color})
    -- left
    Spring.Draw.Rectangle(p8, p5, p1, p4, {color=color})
    -- right
    Spring.Draw.Rectangle(p6, p7, p3, p2, {color=color})
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function CreateShaders()
    shaderPoint = gl.CreateShader({
        vertex = [[
            //VERTEX SHADER
            #version 400

            uniform mat4 viewMatrix;
            uniform mat4 projMatrix;

            layout(location = 0) in vec3 inPosition;
            layout(location = 1) in vec4 inColor;
            layout(location = 2) in float inSize;

            out VertexData {
                vec4 color;
            } outData;

            void main() {
                gl_Position = projMatrix * viewMatrix * vec4(inPosition, 1.0f);
                gl_PointSize = inSize;
                outData.color = inColor;
            }
        ]],

        fragment = [[
            //FRAGMENT SHADER
            #version 400

            in VertexData {
                vec4 color;
            } inData;

            layout(location = 0) out vec4 outColor;

            void main() {
                outColor = inData.color;
            }
        ]],
    })

    if (shaderPoint == nil) then
        Spring.Echo("Point shader log: ".. gl.GetShaderLog())
    end

    shaderPointViewLocation = gl.GetUniformLocation(shaderPoint, "viewMatrix")
    shaderPointProjLocation = gl.GetUniformLocation(shaderPoint, "projMatrix")

    shaderCone = gl.CreateShader({
        vertex = [[
            //VERTEX SHADER
            #version 400

            layout(location = 0) in vec3 inPosition;
            layout(location = 1) in vec4 inColor;

            out VertexData {
                vec4 color;
            } outData;

            void main() {
                gl_Position = vec4(inPosition, 1.0f);
                outData.color = inColor;
            }
        ]],

        geometry = [[
            //GEOMETRY SHADER
            #version 400

            #define pi 3.14159265358979

            uniform mat4 viewMatrix;
            uniform mat4 projMatrix;

            layout (points) in;
            layout (triangle_strip, max_vertices = 96) out;

            in VertexData {
                vec4 color;
            } inData[1];

            out VertexData {
                vec4 color;
            } outData;

            void main() {
                outData.color = inData[0].color;

                float h = 100.0f;
                float r = 25.0f;
                int divs = 32;

                vec4 top = projMatrix * viewMatrix * (gl_in[0].gl_Position + vec4(0.0f, h, 0.0f, 0.0f));
                float a;

                for (int i=0; i<divs; ++i) {
                    gl_Position = top;
                    EmitVertex();

                    a = i * (pi * 2 / divs);
                    gl_Position = projMatrix * viewMatrix * (gl_in[0].gl_Position + vec4(r * sin(a), 0, r * cos(a), 0.0f));
                    EmitVertex();

                    a = (i + 1) * (pi * 2 / divs);
                    gl_Position = projMatrix * viewMatrix * (gl_in[0].gl_Position + vec4(r * sin(a), 0, r * cos(a), 0.0f));
                    EmitVertex();

                    EndPrimitive();
                }
            }
        ]],

        fragment = [[
            //FRAGMENT SHADER
            #version 400

            in VertexData {
                vec4 color;
            } inData;

            layout(location = 0) out vec4 outColor;

            void main() {
                outColor = inData.color;
            }
        ]],
    })

    if (shaderCone == nil) then
        Spring.Echo("Cone shader log: ".. gl.GetShaderLog())
    end

    shaderConeViewLocation = gl.GetUniformLocation(shaderCone, "viewMatrix")
    shaderConeProjLocation = gl.GetUniformLocation(shaderCone, "projMatrix")
end

function widget:Initialize()
    -- only show at the beginning
    if (Spring.GetGameFrame() > 1) then
        widgetHandler:RemoveWidget(self)
        return
    end

    -- get the gaia teamID and allyTeamID
    gaiaTeamID = Spring.GetGaiaTeamID()
    if (gaiaTeamID) then
        gaiaAllyTeamID = select(6, Spring.GetTeamInfo(gaiaTeamID, false))
    end

    CreateShaders()
end

function widget:Shutdown()
    gl.DeleteFont(font)
    gl.DeleteFont(font2)
    gl.DeleteFont(shadowFont)

    gl.DeleteShader(shaderPoint)
    gl.DeleteShader(shaderCone)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local teamColors = {}

local function GetTeamColor(teamID)
    local color = teamColors[teamID]
    if (color) then
        return color
    end
    local r, g, b = Spring.GetTeamColor(teamID)

    color = { r, g, b }
    teamColors[teamID] = color
    return color
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local teamColorStrs = {}

local function GetTeamColorStr(teamID)
    local colorSet = teamColorStrs[teamID]
    if (colorSet) then
        return colorSet[1], colorSet[2]
    end

    local outlineChar = ''
    local r, g, b = GetTeamColor(teamID)
    if (r and g and b) then
        local function ColorChar(x)
            local c = math.floor(x * 255)
            c = ((c <= 1) and 1) or ((c >= 255) and 255) or c
            return string.char(c)
        end
        local colorStr
        colorStr = '\255'
        colorStr = colorStr .. ColorChar(r)
        colorStr = colorStr .. ColorChar(g)
        colorStr = colorStr .. ColorChar(b)
        local i = (r * 0.299) + (g * 0.587) + (b * 0.114)
        outlineChar = ((i > 0.25) and 'o') or 'O'
        teamColorStrs[teamID] = { colorStr, outlineChar }
        return colorStr, "s", outlineChar
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function DrawStartBoxes()
    -- FIXME: Something keeps a texture mapped.
    gl.Texture(false)

    -- Show the ally startboxes.
    local minY, maxY = Spring.GetGroundExtremes()
    minY = minY - 200;
    maxY = maxY + 500;

    gl.DepthMask(false);
    gl.DepthClamp(true);
    gl.DepthTest(true);
    gl.StencilTest(true);
    gl.ColorMask(false, false, false, false);
    gl.Culling(false);
    gl.StencilOp(GL.KEEP, GL.INVERT, GL.KEEP);

    for _, at in ipairs(Spring.GetAllyTeamList()) do
        if (at ~= gaiaAllyTeamID) then
            local xn, zn, xp, zp = Spring.GetAllyTeamStartBox(at)
            if (xn and ((xn ~= 0) or (zn ~= 0) or (xp ~= msx) or (zp ~= msz))) then
                if (at == Spring.GetMyAllyTeamID()) then
                    gl.StencilMask(stencilBit2);
                    gl.StencilFunc(GL.ALWAYS, 0, stencilBit2);
                else
                    gl.StencilMask(stencilBit1);
                    gl.StencilFunc(GL.ALWAYS, 0, stencilBit1);
                end
                DrawMyBox(xn - 1, minY, zn - 1, xp + 1, maxY, zp + 1)
            end
        end
    end

    gl.Culling(GL.FRONT);
    gl.DepthTest(false);
    gl.ColorMask(true, true, true, true);

    for _, at in ipairs(Spring.GetAllyTeamList()) do
        if (at ~= gaiaAllyTeamID) then
            local xn, zn, xp, zp = Spring.GetAllyTeamStartBox(at)
            if (xn and ((xn ~= 0) or (zn ~= 0) or (xp ~= msx) or (zp ~= msz))) then
                local color
                if (at == Spring.GetMyAllyTeamID()) then
                    color = {0,1,0,0.22}
                    gl.StencilMask(stencilBit2);
                    gl.StencilFunc(GL.NOTEQUAL, 0, stencilBit2);
                    hasStartbox = true
                else
                    color = {1,0,0,0.22}
                    gl.StencilMask(stencilBit1);
                    gl.StencilFunc(GL.NOTEQUAL, 0, stencilBit1);
                end
                DrawMyBox(xn - 1, minY, zn - 1, xp + 1, maxY, zp + 1, color)
            end
        end
    end

    gl.DepthClamp(false);
    gl.StencilTest(false);
    gl.DepthTest(true);
    gl.Culling(false);

    -- Cleanup stencil buffer.
    gl.StencilMask(0xFF);
    gl.Clear(GL.STENCIL_BUFFER_BIT, 0)
end

local function DrawStartCones()
    gl.UseShader(shaderCone)
    gl.UniformMatrix(shaderConeViewLocation, "view")
    gl.UniformMatrix(shaderConeProjLocation, "projection")

    -- Show the team start positions.
    local time = Spring.DiffTimers(Spring.GetTimer(), startTimer)
    for _, teamID in ipairs(Spring.GetTeamList()) do
        local _, _, spec = Spring.GetPlayerInfo(select(2, Spring.GetTeamInfo(teamID, false)), false)
        if ((not spec) and (teamID ~= gaiaTeamID)) then
            local x, y, z = Spring.GetTeamStartPosition(teamID)
            local isNewbie = (Spring.GetTeamRulesParam(teamID, 'isNewbie') == 1) -- =1 means the startpoint will be replaced and chosen by initial_spawn
            if (x ~= nil and x > 0 and z > 0 and y > -500) and not isNewbie then
                local color = GetTeamColor(teamID)
                local alpha = 0.5 + math.abs(((time * 3) % 1) - 0.5)

                Spring.Draw.Vertices(1, {x, y+20, z}, {color[1], color[2], color[3], alpha})

                if teamID == myTeamID then
                    amPlaced = true
                end
            end
        end
    end

    gl.UseShader(0)
end

function widget:DrawWorld()
    DrawStartBoxes()
    DrawStartCones()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:DrawScreenEffects()
    -- show the names over the team start positions
    for _, teamID in ipairs(Spring.GetTeamList()) do
        local name, _, spec = Spring.GetPlayerInfo(select(2, Spring.GetTeamInfo(teamID, false)), false)
        local isNewbie = (Spring.GetTeamRulesParam(teamID, 'isNewbie') == 1) -- =1 means the startpoint will be replaced and chosen by initial_spawn
        if (name ~= nil) and ((not spec) and (teamID ~= gaiaTeamID)) and not isNewbie then
            local colorStr, outlineStr = GetTeamColorStr(teamID)
            local x, y, z = Spring.GetTeamStartPosition(teamID)
            if (x ~= nil and x > 0 and z > 0 and y > -500) then
                local sx, sy, sz = Spring.WorldToScreenCoords(x, y + heightOffset, z)
                if (sz < 1) then
                    local color = GetTeamColor(teamID)
                    local outlineColor = { 0, 0, 0, 1 }
                    if (color[1] + color[2] * 1.2 + color[3] * 0.4) < 0.8 then
                        outlineColor = { 1, 1, 1, 1 }
                    end

                    if useThickLeterring then
                        if outlineColor[1] == 1 and fontShadow then
                            shadowFont:Begin()
                            shadowFont:SetTextColor({ 0, 0, 0, shadowOpacity })
                            shadowFont:SetOutlineColor({ 0, 0, 0, shadowOpacity })
                            shadowFont:Print(name, sx, sy - (usedFontSize / 44), usedFontSize, "con")
                            shadowFont:End()
                        end
                        font2:Begin()
                        font2:SetTextColor(outlineColor)
                        font2:SetOutlineColor(outlineColor)
                        font2:Print(name, sx - (usedFontSize / 38), sy - (usedFontSize / 33), usedFontSize, "con")
                        font2:Print(name, sx + (usedFontSize / 38), sy - (usedFontSize / 33), usedFontSize, "con")
                        font2:End()
                    end

                    font2:Begin()
                    font2:SetTextColor(color)
                    font2:SetOutlineColor(outlineColor)
                    font2:Print(name, sx, sy, usedFontSize, "con")
                    font2:End()
                end
            end
        end
    end
end

function widget:DrawScreen()
    if not isSpec then
        font:Begin()
        font:SetTextColor(0.9, 0.9, 0.9, 1)
        font:Print(hasStartbox and infotextBoxes or infotext, vsx/2, vsy/6.2, infotextFontsize * widgetScale, "cno")
        font:End()
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:DrawInMiniMap(sx, sz)
    -- only show at the beginning
    if (Spring.GetGameFrame() > 1) then
        widgetHandler:RemoveWidget(self)
        return
    end

    local minY, maxY = Spring.GetGroundExtremes()
    minY = minY - 200;
    maxY = maxY + 500;
    local y = maxY

    -- FIXME: Something keeps a texture mapped.
    gl.Texture(false)

    -- show all start boxes
    for _, at in ipairs(Spring.GetAllyTeamList()) do
        if (at ~= gaiaAllyTeamID) then
            local xn, zn, xp, zp = Spring.GetAllyTeamStartBox(at)
            if (xn and ((xn ~= 0) or (zn ~= 0) or (xp ~= msx) or (zp ~= msz))) then
                local color
                if (at == Spring.GetMyAllyTeamID()) then
                    color = { 0, 1, 0, 0.1 }  --  green
                else
                    color = { 1, 0, 0, 0.1 }  --  red
                end

                Spring.Draw.Rectangle({xn, y, zp}, {xp, y, zp}, {xp, y, zn}, {xn, y, zn}, {color=color})

                local bordercolor = {color[1], color[2], color[3], 0.5}
                Spring.Draw.Lines({xn, y, zp}, {xp, y, zp}, {xp, y, zn}, {xn, y, zn}, {width=2, color=bordercolor, loop=true})
            end
        end
    end

    gl.UseShader(shaderPoint)
    gl.UniformMatrix(shaderPointViewLocation, "mmview")
    gl.UniformMatrix(shaderPointProjLocation, "mmproj")

    -- show the team start positions
    for _, teamID in ipairs(Spring.GetTeamList()) do
        local _, _, spec = Spring.GetPlayerInfo(select(2, Spring.GetTeamInfo(teamID, false)), false)
        if ((not spec) and (teamID ~= gaiaTeamID)) then
            local x, y, z = Spring.GetTeamStartPosition(teamID)
            local isNewbie = (Spring.GetTeamRulesParam(teamID, 'isNewbie') == 1) -- =1 means the startpoint will be replaced and chosen by initial_spawn
            if (x ~= nil and x > 0 and z > 0 and y > -500) and not isNewbie then
                local color = GetTeamColor(teamID)
                local time = Spring.DiffTimers(Spring.GetTimer(), startTimer)
                local i = 2 * math.abs(((time * 3) % 1) - 0.5)

                Spring.Draw.Vertices(2, {{x, y, z}, {x, y, z}}, {{i, i, i, 1}, {color[1], color[2], color[3], 1}}, {{11}, {7}})
            end
        end
    end

    gl.UseShader(0)
end

function widget:ViewResize(x, y)
    vsx, vsy = x, y
    widgetScale = (0.75 + (vsx * vsy / 7500000))
    usedFontSize = fontSize * widgetScale
    local newFontfileScale = (0.5 + (vsx * vsy / 5700000))
    if (fontfileScale ~= newFontfileScale) then
        fontfileScale = newFontfileScale
        gl.DeleteFont(font)
        gl.DeleteFont(font2)
        gl.DeleteFont(shadowFont)
        font = gl.LoadFont(fontfile, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)
        font2 = gl.LoadFont(fontfile2, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength2)
        shadowFont = gl.LoadFont(fontfile, fontfileSize * fontfileScale, 35 * fontfileScale, 1.6)
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Update(dt)
    if not isSpec and not amPlaced and placeVoiceNotifTimer < os.clock() and WG['notifications'] then
        WG['notifications'].addEvent('ChooseStartLoc')
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
