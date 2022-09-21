function widget:GetInfo()
    return {
        name = "Options",
        desc = "",
        author = "Floris",
        date = "September 2016",
        license = "Dental flush",
        layer = math.huge,
        enabled = true,
        handler = true
    }
end

--local show = true
local loadedFontSize = 32
local font = gl.LoadFont(LUAUI_DIRNAME .. "Fonts/FreeSansBold.otf", loadedFontSize, 16, 2)
local bgcorner = ":n:" .. LUAUI_DIRNAME .. "Images/bgcorner.png"
local bgcorner1 = ":n:" .. LUAUI_DIRNAME .. "Images/bgcorner1.png"
local closeButtonTex = ":n:" .. LUAUI_DIRNAME .. "Images/close.dds"
local bgMargin = 6
local closeButtonSize = 30
local screenHeight = 520 - bgMargin - bgMargin -- change menu size
local screenWidth = 1050 - bgMargin - bgMargin
local customScale = 1
local vsx, vsy = Spring.GetViewGeometry()
local screenX = (vsx * 0.5) - (screenWidth / 2)
local screenY = (vsy * 0.5) + (screenHeight / 2)
local spIsGUIHidden = Spring.IsGUIHidden
local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPolygonMode = gl.PolygonMode
local glTexRect = gl.TexRect
local glRotate = gl.Rotate
local glTexture = gl.Texture
local glText = gl.Text
local glShape = gl.Shape
local glGetTextWidth = gl.GetTextWidth
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_LINE_STRIP = GL.LINE_STRIP
local widgetScale = 1
local myTeamID = Spring.GetMyTeamID()
local amNewbie = (Spring.GetTeamRulesParam(myTeamID, "isNewbie") == 1)
local gameStarted = (Spring.GetGameFrame() > 0)
local options = {}
local optionButtons = {}
local optionHover = {}
local optionSelect = {}
local fullWidgetsList = {}
local addedWidgetOptions = false
local luaShaders = tonumber(Spring.GetConfigInt("LuaShaders", 1) or 0)

function widget:ViewResize()
    vsx, vsy = Spring.GetViewGeometry()
    screenX = (vsx * 0.5) - (screenWidth / 2)
    screenY = (vsy * 0.5) + (screenHeight / 2)
    widgetScale = (0.75 + (vsx * vsy / 7500000)) * customScale

    if windowList then
        gl.DeleteList(windowList)
    end

    windowList = gl.CreateList(DrawWindow)
end

function widget:GameStart()
    gameStarted = true
end

-- button
local textSize = 0.75
local textMargin = 0.25
local posX = 0.15
local showOnceMore = false -- used because of GUI shader delay
local buttonGL

local function DrawRectRound(px, py, sx, sy, cs, tl, tr, br, bl)
    gl.TexCoord(0.8, 0.8)
    gl.Vertex(px + cs, py, 0)
    gl.Vertex(sx - cs, py, 0)
    gl.Vertex(sx - cs, sy, 0)
    gl.Vertex(px + cs, sy, 0)
    gl.Vertex(px, py + cs, 0)
    gl.Vertex(px + cs, py + cs, 0)
    gl.Vertex(px + cs, sy - cs, 0)
    gl.Vertex(px, sy - cs, 0)
    gl.Vertex(sx, py + cs, 0)
    gl.Vertex(sx - cs, py + cs, 0)
    gl.Vertex(sx - cs, sy - cs, 0)
    gl.Vertex(sx, sy - cs, 0)
    local offset = 0.07 -- texture offset, because else gaps could show

    -- bottom left
    if ((py <= 0 or px <= 0) or (bl ~= nil and bl == 0)) and bl ~= 2 then
        o = 0.5
    else
        o = offset
    end

    gl.TexCoord(o, o)
    gl.Vertex(px, py, 0)
    gl.TexCoord(o, 1 - o)
    gl.Vertex(px + cs, py, 0)
    gl.TexCoord(1 - o, 1 - o)
    gl.Vertex(px + cs, py + cs, 0)
    gl.TexCoord(1 - o, o)
    gl.Vertex(px, py + cs, 0)

    -- bottom right
    if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2 then
        o = 0.5
    else
        o = offset
    end

    gl.TexCoord(o, o)
    gl.Vertex(sx, py, 0)
    gl.TexCoord(o, 1 - o)
    gl.Vertex(sx - cs, py, 0)
    gl.TexCoord(1 - o, 1 - o)
    gl.Vertex(sx - cs, py + cs, 0)
    gl.TexCoord(1 - o, o)
    gl.Vertex(sx, py + cs, 0)

    -- top left
    if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2 then
        o = 0.5
    else
        o = offset
    end

    gl.TexCoord(o, o)
    gl.Vertex(px, sy, 0)
    gl.TexCoord(o, 1 - o)
    gl.Vertex(px + cs, sy, 0)
    gl.TexCoord(1 - o, 1 - o)
    gl.Vertex(px + cs, sy - cs, 0)
    gl.TexCoord(1 - o, o)
    gl.Vertex(px, sy - cs, 0)

    -- top right
    if ((sy >= vsy or sx >= vsx) or (tr ~= nil and tr == 0)) and tr ~= 2 then
        o = 0.5
    else
        o = offset
    end

    gl.TexCoord(o, o)
    gl.Vertex(sx, sy, 0)
    gl.TexCoord(o, 1 - o)
    gl.Vertex(sx - cs, sy, 0)
    gl.TexCoord(1 - o, 1 - o)
    gl.Vertex(sx - cs, sy - cs, 0)
    gl.TexCoord(1 - o, o)
    gl.Vertex(sx, sy - cs, 0)
end

-- (coordinates work differently than the RectRound func in other widgets)
function RectRound(px, py, sx, sy, cs, tl, tr, br, bl)
    gl.Texture(bgcorner)
    gl.BeginEnd(GL.QUADS, DrawRectRound, px, py, sx, sy, cs, tl, tr, br, bl)
    gl.Texture(false)
end

function DrawButton()
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
    RectRound(0, 0, 4.5, 1.05, 0.25, 2, 2, 0, 0)

    local vertices = {
        {
            v = {0, 1, 0}
        },
        {
            v = {0, 0, 0}
        },
        {
            v = {1, 0, 0}
        }
    }

    glShape(GL_LINE_STRIP, vertices)
    glText("Options", textMargin, textMargin, textSize, "no")
end

function DrawWindow()
    -- add widget options
    if not addedWidgetOptions then
        -- cursors
        addedWidgetOptions = true

        if (WG["darkenmap"] ~= nil) then
            table.insert(
                options,
                {
                    id = "darkenmap",
                    name = "Darken map",
                    min = 0,
                    max = 0.5,
                    step = 0.05,
                    type = "slider",
                    value = WG["darkenmap"].getMapDarkness(),
                    description = "Darkens the whole map (not the units)\n\nRemembers setting per map\nUse /resetmapdarkness if you want to reset all stored map settings"
                }
            )
        end

        local cursorsets = {}
        local cursor = 1

        if (WG["cursors"] ~= nil) then
            cursorsets = WG["cursors"].getcursorsets()
            local cursorname = WG["cursors"].getcursor()

            for i, c in pairs(cursorsets) do
                if c == cursorname then
                    cursor = i
                    break
                end
            end

            table.insert(
                options,
                {
                    id = "cursor",
                    name = "Cursor Size",
                    type = "select",
                    options = cursorsets,
                    value = cursor
                }
            )
        end
    -- Darken map
    end

    local vsx, vsy = Spring.GetViewGeometry()
    local x = screenX --rightwards
    local y = screenY --upwards
    -- background
    gl.Color(0, 0, 0, 0.8)
    RectRound(x - bgMargin, y - screenHeight - bgMargin, x + screenWidth + bgMargin, y + bgMargin, 8, 0, 1, 1, 1)
    -- content area
    gl.Color(0.33, 0.33, 0.33, 0.15)
    RectRound(x, y - screenHeight, x + screenWidth, y, 6)
    -- close button
    gl.Color(1, 1, 1, 1)
    gl.Texture(closeButtonTex)
    gl.TexRect(screenX + screenWidth - closeButtonSize, screenY, screenX + screenWidth, screenY - closeButtonSize)
    gl.Texture(false)
    -- title
    local title = "Options"
    local titleFontSize = 18
    gl.Color(0, 0, 0, 0.8)

    titleRect = {x - bgMargin, y + bgMargin, x + (glGetTextWidth(title) * titleFontSize) + 27 - bgMargin, y + 37}

    RectRound(titleRect[1], titleRect[2], titleRect[3], titleRect[4], 8, 1, 1, 0, 0)
    font:Begin()
    font:SetTextColor(1, 1, 1, 1)
    font:SetOutlineColor(0, 0, 0, 0.4)
    font:Print(title, x - bgMargin + (titleFontSize * 0.75), y + bgMargin + 8, titleFontSize, "on")
    font:End()
    local width = screenWidth / 3
    gl.Color(0.66, 0.66, 0.66, 0.08)
    RectRound(x + width + width + 6, y - screenHeight, x + width + width + width, y, 6)
    -- description background
    gl.Color(0.72, 0.5, 0.12, 0.14)
    RectRound(x, y - screenHeight, x + width + width, y - screenHeight + 90, 6)
    -- draw options
    local oHeight = 15
    local oPadding = 6
    y = y - oPadding - 11
    local oWidth = (screenWidth / 3) - oPadding - oPadding
    local yHeight = screenHeight - 102 - oPadding
    local xPos = x + oPadding + 5
    local xPosMax = xPos + oWidth - oPadding - oPadding
    local yPosMax = y - yHeight
    local boolPadding = 3.5
    local boolWidth = 40
    local sliderWidth = 110
    local selectWidth = 140
    local i = 0
    optionButtons = {}
    optionHover = {}

    for oid, option in pairs(options) do
        yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)

        if yPos - oHeight < yPosMax then
            i = 0
            xPos = x + 10 + oPadding + (screenWidth / 3)
            xPosMax = xPos + oWidth - oPadding - oPadding
            yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)
            gl.Color(0, 0, 0, 0.25)
            RectRound(xPos - oPadding - 8 - 2.5, y - screenHeight + 118, xPos - oPadding - 8 + 2.5, y, 2)
        end

        --option name
        glText("\255\230\230\230" .. option.name, xPos, yPos - (oHeight / 3) - oPadding, oHeight, "no")

        -- define hover area
        optionHover[oid] = {xPos, yPos - oHeight - oPadding, xPosMax, yPos + oPadding}

        -- option controller
        if option.type == "bool" then
            optionButtons[oid] = {}

            optionButtons[oid] = {xPosMax - boolWidth, yPos - oHeight, xPosMax, yPos}

            glColor(1, 1, 1, 0.11)
            RectRound(xPosMax - boolWidth, yPos - oHeight, xPosMax, yPos, 3)

            if option.value == true then
                glColor(0.66, 0.92, 0.66, 1)
                RectRound(
                    xPosMax - oHeight + boolPadding,
                    yPos - oHeight + boolPadding,
                    xPosMax - boolPadding,
                    yPos - boolPadding,
                    2.5
                )
            else
                glColor(0.92, 0.66, 0.66, 1)
                RectRound(
                    xPosMax - boolWidth + boolPadding,
                    yPos - oHeight + boolPadding,
                    xPosMax - boolWidth + oHeight - boolPadding,
                    yPos - boolPadding,
                    2.5
                )
            end
        elseif option.type == "slider" then
            local sliderSize = oHeight * 0.75
            local sliderPos = (option.value - option.min) / (option.max - option.min)
            glColor(1, 1, 1, 0.11)
            RectRound(
                xPosMax - (sliderSize / 2) - sliderWidth,
                yPos - ((oHeight / 7) * 4.2),
                xPosMax - (sliderSize / 2),
                yPos - ((oHeight / 7) * 2.8),
                1
            )
            glColor(0.8, 0.8, 0.8, 1)
            RectRound(
                xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) - (sliderSize / 2),
                yPos - oHeight + ((oHeight - sliderSize) / 2),
                xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) + (sliderSize / 2),
                yPos - ((oHeight - sliderSize) / 2),
                3
            )

            optionButtons[oid] = {
                xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) - (sliderSize / 2),
                yPos - oHeight + ((oHeight - sliderSize) / 2),
                xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) + (sliderSize / 2),
                yPos - ((oHeight - sliderSize) / 2)
            }

            optionButtons[oid].sliderXpos = {xPosMax - (sliderSize / 2) - sliderWidth, xPosMax - (sliderSize / 2)}
        elseif option.type == "select" then
            optionButtons[oid] = {xPosMax - selectWidth, yPos - oHeight, xPosMax, yPos}

            glColor(1, 1, 1, 0.11)
            RectRound(xPosMax - selectWidth, yPos - oHeight, xPosMax, yPos, 3)
            glText(
                option.options[tonumber(option.value)],
                xPosMax - selectWidth + 5,
                yPos - (oHeight / 3) - oPadding,
                oHeight * 0.85,
                "no"
            )
            glColor(1, 1, 1, 0.11)
            RectRound(xPosMax - oHeight, yPos - oHeight, xPosMax, yPos, 2.5)
            glColor(1, 1, 1, 0.16)
            glTexture(bgcorner1)
            glPushMatrix()
            glTranslate(xPosMax - (oHeight * 0.5), yPos - (oHeight * 0.33), 0)
            glRotate(-45, 0, 0, 1)
            glTexRect(-(oHeight * 0.25), -(oHeight * 0.25), (oHeight * 0.25), (oHeight * 0.25))
            glPopMatrix()
        end

        i = i + 1
    end
end

function correctMouseForScaling(x, y)
    local interfaceScreenCenterPosX = (screenX + (screenWidth / 2)) / vsx
    local interfaceScreenCenterPosY = (screenY - (screenHeight / 2)) / vsy
    x = x - (((x / vsx) - interfaceScreenCenterPosX) * vsx) * ((widgetScale - 1) / widgetScale)
    y = y - (((y / vsy) - interfaceScreenCenterPosY) * vsy) * ((widgetScale - 1) / widgetScale)

    return x, y
end

function widget:DrawScreen()
    if spIsGUIHidden() then
        return
    end
    if amNewbie and not gameStarted then
        return
    end
    -- draw the button
    --if not buttonGL then
    --  buttonGL = gl.CreateList(DrawButton)
    -- end
    --glLineWidth(lineWidth)
    --glPushMatrix()
    --  glTranslate(posX*vsx, posY*vsy, 0)
    --  glScale(17*widgetScale, 17*widgetScale, 1)
    --    glColor(0, 0, 0, (0.3*bgColorMultiplier))
    -- glCallList(buttonGL)
    -- glPopMatrix()
    glColor(1, 1, 1, 1)
    glLineWidth(1)

    -- draw the window
    if not windowList then
        windowList = gl.CreateList(DrawWindow)
    end

    -- update new slider value
    if sliderValueChanged then
        gl.DeleteList(windowList)
        windowList = gl.CreateList(DrawWindow)
        sliderValueChanged = nil
    end

    if show or showOnceMore then
        -- draw the options panel
        glPushMatrix()
        glTranslate(-(vsx * (widgetScale - 1)) / 2, -(vsy * (widgetScale - 1)) / 2, 0)
        glScale(widgetScale, widgetScale, 1)
        glCallList(windowList)

        showOnceMore = false
        -- draw button hover
        local usedScreenX = (vsx * 0.5) - ((screenWidth / 2) * widgetScale)
        local usedScreenY = (vsy * 0.5) + ((screenHeight / 2) * widgetScale)
        -- mouseover (highlight and tooltip)
        local description = ""
        local x, y = Spring.GetMouseState()
        local cx, cy = correctMouseForScaling(x, y)

        if not showSelectOptions then
            for i, o in pairs(optionHover) do
                if IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) and options[i].type ~= "label" then
                    RectRound(
                        o[1] - 4,
                        o[2],
                        o[3] + 4,
                        o[4],
                        2,
                        2,
                        2,
                        2,
                        2,
                        options[i].onclick and {0.5, 1, 0.2, 0.1} or {1, 1, 1, 0.045},
                        options[i].onclick and {0.5, 1, 0.2, 0.2} or {1, 1, 1, 0.09}
                    )

                    font:Begin()

                    if options[i].description ~= nil then
                        description = options[i].description
                        font:Print(
                            "\255\235\190\122" .. options[i].description,
                            screenX + 15,
                            screenY - screenHeight + 64.5,
                            16,
                            "no"
                        )
                    end

                    font:SetTextColor(0.46, 0.4, 0.3, 0.45)
                    font:Print(
                        "/option " .. options[i].id,
                        screenX + screenWidth * 0.659,
                        screenY - screenHeight + 8,
                        14,
                        "nr"
                    )
                    font:End()
                end
            end

            for i, o in pairs(optionButtons) do
                if IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                    RectRound(o[1], o[2], o[3], o[4], 1, 2, 2, 2, 2, {0.5, 0.5, 0.5, 0.22}, {1, 1, 1, 0.22})

                    if WG["tooltip"] ~= nil and options[i].type == "slider" then
                        local value = options[i].value

                        if options[i].steps then
                            value = NearestValue(options[i].steps, value)
                        else
                            local decimalValue, floatValue = math.modf(options[i].step)

                            if floatValue ~= 0 then
                                value =
                                    string.format(
                                    "%." .. string.len(string.sub("" .. options[i].step, 3)) .. "f",
                                    value
                                ) -- do rounding via a string because floats show rounding errors at times
                            end
                        end

                        WG["tooltip"].ShowTooltip("options_showvalue", value)
                    end
                end
            end
        end

        -- draw select options
        if showSelectOptions ~= nil then
            local oHeight = optionButtons[showSelectOptions][4] - optionButtons[showSelectOptions][2]
            local oPadding = 4
            y = optionButtons[showSelectOptions][4] - oPadding
            local yPos = y
            --Spring.Echo(oHeight)
            optionSelect = {}

            for i, option in pairs(options[showSelectOptions].options) do
                yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)
            end

            glColor(0.22, 0.22, 0.22, 0.85)
            RectRound(
                optionButtons[showSelectOptions][1],
                yPos - oHeight - oPadding,
                optionButtons[showSelectOptions][3],
                optionButtons[showSelectOptions][4],
                4
            )
            glColor(1, 1, 1, 0.07)
            RectRound(
                optionButtons[showSelectOptions][1],
                optionButtons[showSelectOptions][2],
                optionButtons[showSelectOptions][3],
                optionButtons[showSelectOptions][4],
                4
            )

            for i, option in pairs(options[showSelectOptions].options) do
                yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)

                if
                    IsOnRect(
                        cx,
                        cy,
                        optionButtons[showSelectOptions][1],
                        yPos - oHeight - oPadding,
                        optionButtons[showSelectOptions][3],
                        yPos + oPadding
                    )
                 then
                    glColor(1, 1, 1, 0.1)
                    RectRound(
                        optionButtons[showSelectOptions][1],
                        yPos - oHeight - oPadding,
                        optionButtons[showSelectOptions][3],
                        yPos + oPadding,
                        4
                    )
                end

                table.insert(
                    optionSelect,
                    {
                        optionButtons[showSelectOptions][1],
                        yPos - oHeight - oPadding,
                        optionButtons[showSelectOptions][3],
                        yPos + oPadding,
                        i
                    }
                )

                glText(
                    "\255\255\255\255" .. option,
                    optionButtons[showSelectOptions][1] + 7,
                    yPos - (oHeight / 2.25) - oPadding,
                    oHeight * 0.85,
                    "no"
                )
            end
        end

        glPopMatrix()
    end
end

local function SetupCommandColors(state)
    local alpha = state and 1 or 0
    local f = io.open("cmdcolors.tmp", "w+")
    if (f) then
        f:write("unitBox  0 1 0 " .. alpha)
        f:close()
        -- Spring.SendCommands({'cmdcolors cmdcolors.tmp'})
        Spring.SendCommands({'cmdcolors cmdcolors.tmp'}) -----
		--Spring.SendCommands("fps " .. value)
    end
    os.remove("cmdcolors.tmp")
end

function applyOptionValue(i)
    local id = options[i].id

    if options[i].type == "bool" then
        --[[if options[i].widget ~= nil then
         if value == 1 then
            if id == "xrayshader" or id == "snow" or id == "mapedgeextension" or id == "lighteffects" or id == "sharpen" or id == "advgraphics" or id == "mapborder" then
               if luaShaders ~= 1 and not enabledLuaShaders then
                  Spring.SetConfigInt("LuaShaders", 1)
                  enabledLuaShaders = true
               end
            end

            widgetHandler:EnableWidget(options[i].widget)
         else
            widgetHandler:DisableWidget(options[i].widget)
         end
      end]]
        options[i].value = not options[i].value
        local value = 0

        if options[i].value then
            value = 1
        end

        --if id == "advmapshading" then
        -- Spring.SendCommands("AdvMapShading "..value)
        -- Spring.SetConfigInt("AdvMapShading", value)
        --elseif id == "advmodelshading" then
        -- Spring.SendCommands("AdvModelShading "..value)
        -- Spring.SetConfigInt("AdvModelShading", value)
        --else
        if id == "shadows" then
            Spring.SendCommands("Shadows " .. value)
            Spring.SetConfigInt("Shadows", value)
        elseif id == "fullscreen" then
            Spring.SendCommands("Fullscreen " .. value)
        elseif id == "borderless" then
            Spring.SetConfigInt("WindowBorderless", value)
        elseif id == "screenedgemove" then
            Spring.SetConfigInt("FullscreenEdgeMove", value)
            Spring.SetConfigInt("WindowedEdgeMove", value)
        elseif id == "lighteffects" then
            --elseif id == "ssao" then
            --  if value == 0 then
            --		widgetHandler:DisableWidget("SSAO_alternative")
            --		Spring.SetConfigInt("ssao", 0)
            --	else
            --		widgetHandler: EnableWidget("SSAO_alternative")
            --		Spring.SetConfigInt("ssao", 1)
            --end
            if value ~= 0 then
                widgetHandler:EnableWidget("Deferred rendering")
                widgetHandler:EnableWidget("Light Effects")
            else
                widgetHandler:DisableWidget("Deferred rendering")
                widgetHandler:DisableWidget("Light Effects")
            end
        elseif id == "alwaysrenderwrecksandtrees" then
            if value == 0 then
                --	Spring.SendCommands("FeatureDrawDistance 5000")
                --  Spring.SendCommands("FeatureFadeDistance 999999")
                --  	Spring.SetConfigInt("TreeRadius", 999999)
                --Spring.SetConfigInt("3DTrees", 0)
                Spring.SetConfigInt("alwaysrenderwrecksandtrees", 0)

                Spring.SetConfigString("FeatureDrawDistance", "5000")
                Spring.SetConfigString("FeatureFadeDistance", "999999")
            else
                --Spring.SendCommands("FeatureDrawDistance 99999999")
                -- Spring.SendCommands("FeatureFadeDistance 99999999")
                --	Spring.SetConfigInt("TreeRadius", 999999)
                --Spring.SetConfigInt("3DTrees", 1)
                Spring.SetConfigInt("alwaysrenderwrecksandtrees", 1)

                Spring.SetConfigString("FeatureDrawDistance", "999999")
                Spring.SetConfigString("FeatureFadeDistance", "999999")
            end
        elseif id == "mapborder" then
            if value == 0 then
                widgetHandler:DisableWidget("Map Edge Extension Colourful")

                --widgetHandler:DisableWidget("Volumetric Clouds")
                Spring.SetConfigInt("mapborder", 0)
            elseif value == 1 then
                --widgetHandler:EnableWidget("Volumetric Clouds")
                widgetHandler:EnableWidget("Map Edge Extension Colourful")

                Spring.SetConfigInt("mapborder", 1)
            end
        elseif id == "Cursorcanleavewindow" then
            if value == 1 then
                widgetHandler:DisableWidget("Grabinput")
                Spring.SendCommands("grabinput 0")
            else
                widgetHandler:EnableWidget("Grabinput")
                Spring.SendCommands("grabinput 1")
            end

            Spring.SetConfigInt("Cursorcanleavewindow", value)
        elseif id == "newunitselectionboxstyle" then
            --classic unit selection boxes
            if value == 1 then
                SetupCommandColors(false)
                widgetHandler:EnableWidget("Fancy Selected Unit")
            else
                SetupCommandColors(true)
                widgetHandler:DisableWidget("Fancy Selected Unit")
            end

            Spring.SetConfigInt("newunitselectionboxstyle", value)
        elseif id == "nametags" then
            --classic unit selection boxes
            if value == 1 then
                widgetHandler:DisableWidget("Commander Name Tags")
                Spring.SetConfigString("nametags", "1")
            else
                widgetHandler:EnableWidget("Commander Name Tags")
                Spring.SetConfigString("nametags", "0")
            end
            Spring.SetConfigString("nametags", value)
        elseif id == "adaptive" then
            if value ~= 0 then
                widgetHandler:EnableWidget("Adaptive graphics")
            else
                widgetHandler:DisableWidget("Adaptive graphics")
            end
        elseif id == "fpstimespeed" then
            Spring.SendCommands("fps " .. value)
            Spring.SendCommands("clock " .. value)
            Spring.SendCommands("speed " .. value)
            Spring.SetConfigInt("fpstimespeed", value)
        elseif id == "3dtrees" then
            Spring.SetConfigInt("3DTrees", value)
        elseif id == "Profanity" then
            if value == 0 then
                Spring.SetConfigString("ProfanityFilter", "0")
            else
                Spring.SetConfigString("ProfanityFilter", "1")
            end
        elseif id == "chatsound" then
            if value == 0 then
                Spring.SetConfigString("chatsound", "0")
            else
                Spring.SetConfigString("chatsound", "1")
            end
        elseif id == "showchat" then
            if value == 0 then
                Spring.SetConfigInt("showchat", 0)
                widgetHandler:DisableWidget("Red Console")

                --clear maps
                Spring.SendCommands("mapmarks 0")

                Spring.SendCommands("console 0")
            elseif value == 1 then
                --clear maps
                Spring.SendCommands("mapmarks 1")

                Spring.SetConfigInt("showchat", 1)
                widgetHandler:EnableWidget("Red Console")
            end
        elseif id == "speccursors" then
            if value == 0 then
                widgetHandler:DisableWidget("AllyCursorsAll")
                Spring.SetConfigInt("speccursors", 0)
                widgetHandler:EnableWidget("AllyCursorsAll")
            else
                widgetHandler:DisableWidget("AllyCursorsAll")
                Spring.SetConfigInt("speccursors", 1)
                widgetHandler:EnableWidget("AllyCursorsAll")
            end
        elseif id == "reduceping" then
            if value == 1 then
                Spring.SetConfigInt("reduceping ", 1)
                Spring.SendCommands("UseNetMessageSmoothingBuffer " .. "0")
                Spring.SendCommands("NetworkLossFactor " .. "2")
                Spring.SendCommands("LinkOutgoingBandwidth " .. "262144")
                Spring.SendCommands("LinkIncomingSustainedBandiwdth " .. "262144")
                Spring.SendCommands("LinkIncomingPeakBandiwdth " .. "262144")
                Spring.SendCommands("LinkIncomingMaxPacketRate " .. "2048")
                Spring.SetConfigString("UseNetMessageSmoothingBuffer ", "0")
                Spring.SetConfigString("NetworkLossFactor ", "2")
                Spring.SetConfigString("LinkOutgoingBandwidth ", "262144")
                Spring.SetConfigString("LinkIncomingSustainedBandwidth ", "262144")
                Spring.SetConfigString("LinkIncomingPeakBandwidth ", "262144")
                Spring.SetConfigString("LinkIncomingMaxPacketRate ", "2048")
            else
                Spring.SetConfigInt("reduceping ", 0)
                Spring.SendCommands("UseNetMessageSmoothingBuffer " .. "1")
                Spring.SendCommands("NetworkLossFactor " .. "0")
                Spring.SendCommands("LinkOutgoingBandwidth " .. "98304")
                Spring.SendCommands("LinkIncomingSustainedBandiwdth " .. "98304")
                Spring.SendCommands("LinkIncomingPeakBandiwdth " .. "98304")
                Spring.SendCommands("LinkIncomingMaxPacketRate " .. "128")
                Spring.SetConfigString("UseNetMessageSmoothingBuffer ", "1")
                Spring.SetConfigString("NetworkLossFactor ", "0")
                Spring.SetConfigString("LinkOutgoingBandwidth ", "98304")
                Spring.SetConfigString("LinkIncomingSustainedBandwidth ", "98304")
                Spring.SetConfigString("LinkIncomingPeakBandwidth ", "98304")
                Spring.SetConfigString("LinkIncomingMaxPacketRate ", "128")
            end
        elseif id == "smoothcamid" then
            --  local valueCamSetting = tonumber(Spring.GetConfigInt("CamSetting", 1) or 1)
            if (value == 1) then
                --Spring.SetConfigString("smoothcam", "1")
                --	if(valueCamSetting == 1) then --ta
                --		 widgetHandler:EnableWidget("SmoothCam")
                --Spring.SetConfigString("smoothcam", "1")
                --elseif(valueCamSetting == 2) then --spring
                -- widgetHandler:DisableWidget("SmoothCam")
                --Spring.SetConfigString("smoothcam", "0")
                --	end
                widgetHandler:EnableWidget("SmoothCam")
                Spring.SetConfigString("smoothcam", "1")
            else
                widgetHandler:DisableWidget("SmoothCam")
                Spring.SetConfigString("smoothcam", "0")
            end
        elseif id == "advsky" then
            Spring.SetConfigInt("AdvSky", value)
        end
     --
    elseif options[i].type == "slider" then
        local value = options[i].value

        if id == "fsaa" then
            Spring.SetConfigInt("FSAALevel", value)
        elseif id == "decals" then
            Spring.SetConfigInt("GroundDecals ", value)
        elseif id == "zoomspeed" then
            Spring.SetConfigInt("ScrollWheelSpeed", value)
        elseif id == "scrollspeed" then
            Spring.SetConfigInt("OverheadScrollSpeed", value) -- spring default: 10
            Spring.SetConfigInt("RotOverheadScrollSpeed", value) -- spring default: 10
            Spring.SetConfigInt("CamFreeScrollSpeed", value * 50) -- spring default: 500
            Spring.SetConfigInt("CamSpringScrollSpeed", value) -- spring default: 10
        elseif id == "fpsspeed" then
            Spring.SetConfigString("FPSMouseScale", (value / 10000)) -- spring default: 10
        elseif id == "disticon" then
            --Spring.SetConfigInt("UnitIconDist"..value)
            Spring.SendCommands("disticon " .. value)
            Spring.SetConfigInt("UnitIconDist", value)
        elseif id == "treeradius" then
            Spring.SetConfigInt("TreeRadius", value)
        elseif id == "particles" then
            Spring.SetConfigInt("MaxParticles", value)
        elseif id == "nanoparticles" then
            Spring.SetConfigInt("MaxNanoParticles", value)
        elseif id == "grassdetail" then
            Spring.SetConfigInt("GrassDetail", value)
        elseif id == "grounddetail" then
            --Spring.SetConfigInt("GroundDetail"..value)
        elseif id == "sndvolmaster" then
            Spring.SetConfigInt("snd_volmaster", value)
        elseif id == "msaa" then
            Spring.SetConfigInt("MSAALevel", value)
        elseif id == "crossalpha" then
            -- Spring.SendCommands("cross " .. tonumber(Spring.GetConfigInt("CrossSize", 1) or 10) .. "" .. tostring(value))
            -- Spring.SetConfigInt("CrossAlpha", value)
        elseif id == "darkenmap" then
            WG["darkenmap"].setMapDarkness(value)
        end
    elseif options[i].type == "select" then
        local value = options[i].value

        if id == "advgraphics" then
            Spring.SetConfigInt("advgraphics", value - 1)
			 setGraphicsPreset(0)
            setGraphicsPreset(value - 1)
        elseif id == "Water" then
            --   options = {"basic", "reflective", "dynamic", "reflective&refractive", "bump-mapped"},

            if (value == 3) then
                value = 5
            end

            Spring.SendCommands("Water " .. tostring((value - 1)))
        elseif id == "camera" then
            if value == 0 then
                Spring.SendCommands("viewfps ")
            elseif value == 2 then
                --  Spring.SendCommands("viewta ")
                local camState = Spring.GetCameraState()
                camState.mode = 2
                Spring.SetCameraState(camState, 0)
                Spring.SetConfigInt("CamSetting", value)
            elseif value == 1 then
                local camState = Spring.GetCameraState()
                camState.mode = 1
                Spring.SetCameraState(camState, 0)
                Spring.SetConfigInt("CamSetting", value)
            elseif value == 3 then
                Spring.SendCommands("viewrot ")
            elseif value == 4 then
                Spring.SendCommands("viewfree ")
            end

            Spring.SetConfigInt("CamSetting", value)
        elseif id == "cursor" then
            WG["cursors"].setcursor(options[i].options[value])
        end
    end

    if windowList then
        gl.DeleteList(windowList)
    end

    windowList = gl.CreateList(DrawWindow)
end

function IsOnRect(x, y, BLcornerX, BLcornerY, TRcornerX, TRcornerY)
    -- check if the mouse is in a rectangle
    return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
end

local function RestartLightFXWidgets()
    widgetHandler:DisableWidget("Deferred rendering")
    widgetHandler:DisableWidget("Light Effects")
    widgetHandler:DisableWidget("Lups")
    widgetHandler:DisableWidget("LupsManager")
    widgetHandler:EnableWidget("Deferred rendering")
    widgetHandler:EnableWidget("Light Effects")
    widgetHandler:EnableWidget("Lups")
    widgetHandler:EnableWidget("LupsManager")
end

function setGraphicsPreset(value)
--Spring.Echo("setGraphicsPresetset") //light effects is launching  2x
    if ((value == 2) and not gl.CreateShader) then --check zow can launch 1st run
        Spring.Echo("Your PC doesn't support Max setting")
        value = 1
    end

    if value == 0 then
        -- Spring.SetConfigInt("ssao", 0)
				
				--if(options[9] ~= nil and options[6] ~= nil) then -- 6 min high max 9 map border
				--if(options[6].value == 1) then
				--local val = 0
				--options[9].value = val
				--applyOptionValue(9)
				--end
				--end
				
				
				
				
				
		        Spring.SendCommands("Shadows 0")
        Spring.SendCommands("luarules disablecus")
        -- widgetHandler: DisableWidget("SSAO_alternative")
        widgetHandler:DisableWidget("Deferred rendering")
        widgetHandler:DisableWidget("Light Effects")
        widgetHandler:DisableWidget("Lups")
        widgetHandler:DisableWidget("LupsManager")
        widgetHandler:DisableWidget("Contrast Adaptive Sharpen")
        --widgetHandler:DisableWidget("Bloom Shader Alternate Deferred")
           widgetHandler:DisableWidget("Bloom Shader Alternate")
        Spring.SendCommands("AdvMapShading 0")
        Spring.SetConfigInt("AdvMapShading", 0)
        Spring.SendCommands("AdvModelShading 0")
        Spring.SetConfigInt("AdvModelShading", 0)
    elseif value == 1 then
        -- Spring.SetConfigInt("ssao", 0)
        --RestartLightFXWidgets()
        --widgetHandler:DisableWidget("SSAO_alternative")

        Spring.SetConfigInt("LuaShaders", 1)
        Spring.SendCommands("luarules disablecus")
        widgetHandler:EnableWidget("Deferred rendering")
        widgetHandler:EnableWidget("Light Effects")
        widgetHandler:EnableWidget("Lups")
        widgetHandler:EnableWidget("LupsManager")

        widgetHandler:EnableWidget("Contrast Adaptive Sharpen")
       -- widgetHandler:DisableWidget("Bloom Shader Alternate Deferred")
          widgetHandler:DisableWidget("Bloom Shader Alternate")
        Spring.SendCommands("AdvMapShading 1")
        Spring.SetConfigInt("AdvMapShading", 1)
        Spring.SendCommands("AdvModelShading 1")
        Spring.SetConfigInt("AdvModelShading", 1)
        Spring.SendCommands("Shadows 1 6144") -- default is 2048, 2 - skip terrian
    elseif value == 2 then
        -- RestartLightFXWidgets()

        Spring.SendCommands("luarules reloadcus")

        Spring.SetConfigInt("LuaShaders", 1)

        widgetHandler:EnableWidget("Deferred rendering")
        widgetHandler:EnableWidget("Light Effects")
        widgetHandler:EnableWidget("Lups")
        widgetHandler:EnableWidget("LupsManager")

        widgetHandler:EnableWidget("Contrast Adaptive Sharpen")
        --widgetHandler:EnableWidget("Bloom Shader Alternate Deferred")
         widgetHandler:EnableWidget("Bloom Shader Alternate")
        Spring.SendCommands("AdvMapShading 1")
        Spring.SetConfigInt("AdvMapShading", 1)
        Spring.SendCommands("AdvModelShading 1")
        Spring.SetConfigInt("AdvModelShading", 1)
        Spring.SendCommands("Shadows 1 6144")
    --Spring.SetConfigInt("ssao", 1)
    end
    -- widgetHandler: EnableWidget("SSAO_alternative")
end

function widget:IsAbove(x, y)
    -- on window
    if show then
        local rectX1 = ((screenX - bgMargin) * widgetScale) - ((vsx * (widgetScale - 1)) / 2)
        local rectY1 = ((screenY + bgMargin) * widgetScale) - ((vsy * (widgetScale - 1)) / 2)
        local rectX2 = ((screenX + screenWidth + bgMargin) * widgetScale) - ((vsx * (widgetScale - 1)) / 2)
        local rectY2 = ((screenY - screenHeight - bgMargin) * widgetScale) - ((vsy * (widgetScale - 1)) / 2)

        return IsOnRect(x, y, rectX1, rectY2, rectX2, rectY1)
    else
        return false
    end
end

function widget:GetTooltip(mx, my)
    if show and widget:IsAbove(mx, my) then
        return string.format("")
    end
end

function getSliderValue(draggingSlider, cx)
    local sliderWidth = optionButtons[draggingSlider].sliderXpos[2] - optionButtons[draggingSlider].sliderXpos[1]
    local value = (cx - optionButtons[draggingSlider].sliderXpos[1]) / sliderWidth
    local min, max

    if options[draggingSlider].steps then
        min, max = options[draggingSlider].steps[1], options[draggingSlider].steps[1]

        for k, v in ipairs(options[draggingSlider].steps) do
            if v > max then
                max = v
            end

            if v < min then
                min = v
            end
        end
    else
        min = options[draggingSlider].min
        max = options[draggingSlider].max
    end

    value = min + ((max - min) * value)

    if value < min then
        value = min
    end

    if value > max then
        value = max
    end

    if options[draggingSlider].steps ~= nil then
        value = NearestValue(options[draggingSlider].steps, value)
    elseif options[draggingSlider].step ~= nil then
        value =
            math.floor((value + (options[draggingSlider].step / 2)) / options[draggingSlider].step) *
            options[draggingSlider].step
    end
    -- is a string now :(

    return value
end

function widget:MouseWheel(up, value)
    local x, y = Spring.GetMouseState()
    local cx, cy = correctMouseForScaling(x, y)
    if show then
        return true
    end
end

function widget:MouseMove(x, y)
    if draggingSlider ~= nil then
        local cx, cy = correctMouseForScaling(x, y)
        options[draggingSlider].value = getSliderValue(draggingSlider, cx)
        sliderValueChanged = true
        applyOptionValue(draggingSlider)
    end
end

function widget:MousePress(x, y, button)
    return mouseEvent(x, y, button, false)
end

function widget:MouseRelease(x, y, button)
    return mouseEvent(x, y, button, true)
end

function mouseEvent(x, y, button, release)
    if spIsGUIHidden() then
        return false
    end
    if amNewbie and not gameStarted then
        return
    end

    if show then
        -- on window
        local rectX1 = ((screenX - bgMargin) * widgetScale) - ((vsx * (widgetScale - 1)) / 2)
        local rectY1 = ((screenY + bgMargin) * widgetScale) - ((vsy * (widgetScale - 1)) / 2)
        local rectX2 = ((screenX + screenWidth + bgMargin) * widgetScale) - ((vsx * (widgetScale - 1)) / 2)
        local rectY2 = ((screenY - screenHeight - bgMargin) * widgetScale) - ((vsy * (widgetScale - 1)) / 2)

        if IsOnRect(x, y, rectX1, rectY2, rectX2, rectY1) then
            -- on option
            local cx, cy = correctMouseForScaling(x, y)

            if release then
                -- apply new slider value
                if draggingSlider ~= nil then
                    options[draggingSlider].value = getSliderValue(draggingSlider, cx)
                    applyOptionValue(draggingSlider)
                    draggingSlider = nil
                end

                -- select option
                if showSelectOptions ~= nil then
                    for i, o in pairs(optionSelect) do
                        if IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                            options[showSelectOptions].value = o[5]
                            applyOptionValue(showSelectOptions)
                        end
                    end

                    if
                        selectClickAllowHide ~= nil or
                            not IsOnRect(
                                cx,
                                cy,
                                optionButtons[showSelectOptions][1],
                                optionButtons[showSelectOptions][2],
                                optionButtons[showSelectOptions][3],
                                optionButtons[showSelectOptions][4]
                            )
                     then
                        showSelectOptions = nil
                        selectClickAllowHide = nil
                    else
                        selectClickAllowHide = true
                    end
                else
                    for i, o in pairs(optionButtons) do
                        if options[i].type == "bool" and IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                            applyOptionValue(i)
                        elseif options[i].type == "slider" and IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                        elseif options[i].type == "select" and IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                        end
                    end
                end
            else -- mousepress
                if not showSelectOptions then
                    for i, o in pairs(optionButtons) do
                        if
                            options[i].type == "slider" and
                                (IsOnRect(cx, cy, o.sliderXpos[1], o[2], o.sliderXpos[2], o[4]) or
                                    IsOnRect(cx, cy, o[1], o[2], o[3], o[4]))
                         then
                            draggingSlider = i
                            options[draggingSlider].value = getSliderValue(draggingSlider, cx)
                            applyOptionValue(draggingSlider)
                        elseif options[i].type == "select" and IsOnRect(cx, cy, o[1], o[2], o[3], o[4]) then
                            if showSelectOptions == nil then
                                showSelectOptions = i
                            elseif showSelectOptions == i then
                            end
                        end
                        --showSelectOptions = nil
                    end
                end
            end

            -- on close button
            local brectX1 = rectX2 - ((closeButtonSize + bgMargin + bgMargin) * widgetScale)
            local brectY2 = rectY1 - ((closeButtonSize + bgMargin + bgMargin) * widgetScale)

            if IsOnRect(x, y, brectX1, brectY2, rectX2, rectY1) then
                if release then
                    showOnceMore = true -- show once more because the  lags behind, though this will not fully fix it
                    show = not show
                end

                return true
            end

            if button == 1 or button == 3 then
                return true
            end
        elseif
            titleRect == nil or
                not IsOnRect(
                    x,
                    y,
                    (titleRect[1] * widgetScale) - ((vsx * (widgetScale - 1)) / 2),
                    (titleRect[2] * widgetScale) - ((vsy * (widgetScale - 1)) / 2),
                    (titleRect[3] * widgetScale) - ((vsx * (widgetScale - 1)) / 2),
                    (titleRect[4] * widgetScale) - ((vsy * (widgetScale - 1)) / 2)
                )
         then
            if release then
                showOnceMore = true -- show once more because the  lags behind, though this will not fully fix it
                show = not show
            end
        end

        if show then
            if windowList then
                gl.DeleteList(windowList)
            end

            windowList = gl.CreateList(DrawWindow)
        end

        return true
    else
        --tx = (x - posX*vsx)/(17*widgetScale)
        --ty = (y - posY*vsy)/(17*widgetScale)
        --if tx < 0 or tx > 4.5 or ty < 0 or ty > 1.05 then return false end
        --if release then
        -- showOnceMore = show     -- show once more because the  lags behind, though this will not fully fix it
        -- show = not show
        --end
        --if show then
        -- if windowList then gl.DeleteList(windowList) end
        -- windowList = gl.CreateList(DrawWindow)
        --end
        --return true
    end
end

function widget:Initialize()
    WG["options"] = {}

    WG["options"].toggle = function(state)
        if state ~= nil then
            show = state
        else
            show = not show
        end
    end

    WG["options"].isvisible = function()
        return show
    end

    -- get widget list
    for name, data in pairs(widgetHandler.knownWidgets) do
        fullWidgetsList[name] = data
    end

    --set stuff initially

    --local bafirstlaunchsetupiscomplete = Spring.GetConfigString('disablewidgetsonce', "missing") --remove later
    --if bafirstlaunchsetupiscomplete ~= "done" then
    --	Spring.SetConfigString("disablewidgetsonce", 'done')
    --	 widgetHandler:DisableWidget("TeamPlatter")
    --end

    value = tonumber(Spring.GetConfigString("alwaysrenderwrecksandtrees", "1"))

    if value == 0 then
        --	Spring.SendCommands("FeatureDrawDistance 5000")
        --  Spring.SendCommands("FeatureFadeDistance 999999")
        --  	Spring.SetConfigInt("TreeRadius", 999999)
        --Spring.SetConfigInt("3DTrees", 0)
        Spring.SetConfigInt("alwaysrenderwrecksandtrees", 0)

        Spring.SetConfigString("FeatureDrawDistance", "5000")
        Spring.SetConfigString("FeatureFadeDistance", "999999")
    else
        --Spring.SendCommands("FeatureDrawDistance 99999999")
        -- Spring.SendCommands("FeatureFadeDistance 99999999")
        --	Spring.SetConfigInt("TreeRadius", 999999)
        --Spring.SetConfigInt("3DTrees", 1)
        Spring.SetConfigInt("alwaysrenderwrecksandtrees", 1)

        Spring.SetConfigString("FeatureDrawDistance", "999999")
        Spring.SetConfigString("FeatureFadeDistance", "999999")
    end

    -- value = tonumber(Spring.GetConfigString("ssao", "0"))

    -- if value == 0 then
    -- widgetHandler:DisableWidget("SSAO_alternative")
    --  Spring.SetConfigInt("ssao", 0)
    --else
    --    widgetHandler: EnableWidget("SSAO_alternative")
    --  Spring.SetConfigInt("ssao", 1)
    -- end

    if (value == 2) then --check zow can launch 1st run
        if (not gl.CreateShader) then
            value = 1
        end
    end

    local defaultval = 2
    if (gl.CreateShader) then --check zow can launch 1st run
        defaultval = 2
    else
        defaultval = 1
    end

    value = Spring.GetConfigInt("advgraphics", defaultval)
    Spring.SetConfigInt("advgraphics", value)
    
	 setGraphicsPreset(0)
	setGraphicsPreset(value)

    value = Spring.GetConfigInt("Cursorcanleavewindow", 1)

    if value == 1 then
        widgetHandler:DisableWidget("Grabinput")
        Spring.SendCommands("grabinput 0")
        Spring.SetConfigInt("Cursorcanleavewindow", 1)
    elseif value == 0 then
        widgetHandler:EnableWidget("Grabinput")
        Spring.SendCommands("grabinput 1")
        Spring.SetConfigInt("Cursorcanleavewindow", 0)
    end

    value = Spring.GetConfigInt("newunitselectionboxstyle", 1)
    Spring.SetConfigInt("newunitselectionboxstyle", value)

    if value == 0 then
        widgetHandler:DisableWidget("Fancy Selected Unit")
        SetupCommandColors(true)
        Spring.SetConfigInt("newunitselectionboxstyle", 0)
    elseif value == 1 then
        widgetHandler:EnableWidget("Fancy Selected Unit")
        SetupCommandColors(false)
        Spring.SetConfigInt("newunitselectionboxstyle", 1)
    end

    value = Spring.GetConfigInt("smoothcam", 1)
    if value == 1 then
        widgetHandler:EnableWidget("SmoothCam")
        Spring.SetConfigString("smoothcam", "1")
    else
        widgetHandler:DisableWidget("SmoothCam")
        Spring.SetConfigString("smoothcam", "0")
    end

    value = Spring.GetConfigInt("showchat", 1)
    Spring.SetConfigInt("showchat", value)

    if value == 0 then
        Spring.SetConfigInt("showchat", 0)
        widgetHandler:DisableWidget("Red Console")

        --clear maps
        Spring.SendCommands("mapmarks 0")

        Spring.SendCommands("console 0")
    elseif value == 1 then
        --clear maps
        Spring.SendCommands("mapmarks 1")

        Spring.SetConfigInt("showchat", 1)
        widgetHandler:EnableWidget("Red Console")
    end

    value = Spring.GetConfigInt("speccursors", 1)
    Spring.SetConfigInt("speccursors", value)

    if value == 0 then
        widgetHandler:DisableWidget("AllyCursorsAll")
        Spring.SetConfigInt("speccursors", 0)
        widgetHandler:EnableWidget("AllyCursorsAll")
    else
        widgetHandler:DisableWidget("AllyCursorsAll")
        Spring.SetConfigInt("speccursors", 1)
        widgetHandler:EnableWidget("AllyCursorsAll")
    end

    if (Spring.GetConfigInt("Water", 1) == 2) or (Spring.GetConfigInt("Water", 1) == 3) then
        Spring.SetConfigInt("Water", 1)
        Spring.SendCommands("Water 1")
    end
    if (Spring.GetConfigInt("Water", 1) > 3) then
        Spring.SetConfigInt("Water", 2)
    end

    value = Spring.GetConfigInt("mapborder", 1)

    if value == 1 then
        widgetHandler:EnableWidget("Map Edge Extension Colourful")
        --widgetHandler:DisableWidget("Volumetric Clouds")
        Spring.SetConfigInt("mapborder", 1)
    elseif value == 0 then
        widgetHandler:DisableWidget("Map Edge Extension Colourful")
        --widgetHandler:EnableWidget("Volumetric Clouds")
        Spring.SetConfigInt("mapborder", 0)
    end

    --value = tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 1))
    --	value = tonumber(Spring.GetConfigInt("CamSpringScrollSpeed", 1))

    --Spring.SetConfigString("ScrollWheelSpeed", "25")
    --		Spring.SetConfigString("CamSpringScrollSpeed", "25")
    --		Spring.SetConfigString("FPSScrollSpeed", "2")

    local value = Spring.GetConfigInt("CamSetting", 1) or 1

    if value == 2 then
        -- Spring.SendCommands("viewta ")
        local camState = Spring.GetCameraState()
        camState.mode = 2
        Spring.SetCameraState(camState, 0)
        Spring.SetConfigInt("CamSetting", value)
    elseif value == 1 then
        -- Spring.SendCommands("viewspring ")
        local camState = Spring.GetCameraState()
        camState.mode = 1
        Spring.SetCameraState(camState, 0)
        Spring.SetConfigInt("CamSetting", value)
    end

    options = {
        {
            id = "zoomspeed",
            name = "Zoom speed (-100 to 100)",
            type = "slider",
            min = -100,
            max = 100,
            step = 1,
            value = tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 25) or 25),
            description = "Leftside of the bar means inversed scrolling!\nKeep in mind, having the slider centered means no mousewheel zooming at all!\n\n"
        },
        {
            id = "scrollspeed",
            name = "Edge panning speed",
            type = "slider",
            min = 1,
            max = 100,
            step = 1,
            value = tonumber(Spring.GetConfigString("CamSpringScrollSpeed", 10) or 10),
            description = "How fast the camera pans when moving the screen"
        },
        {
            id = "fpsspeed",
            name = "FPS mode sensitivity",
            --  type="slider", min=0.0005, max=0.01, step=0.0001,
            type = "slider",
            min = 1,
            max = 100,
            step = 1,
            value = tonumber(Spring.GetConfigString("FPSMouseScale", 0.0025) or 0.0025) * 10000,
            description = "How fast the camera move in FPS mode"
        },
        {
            id = "disticon",
            name = "Unit icon distance",
            type = "slider",
            min = 0,
            max = 1000,
            step = 1,
            value = tonumber(Spring.GetConfigInt("UnitIconDist", 1) or 172)
        },
        --	         {id="camera", name="Camera Type", type="select", options={"fps","overhead","spring","rot overhead","free"}, value=(tonumber(Spring.GetConfigInt("CamMode",1) or 2))},

        {
            id = "blank1",
            name = "",
            type = "label",
            value = 1
        },
        --{id="blank2", name="GRAPHICS", type="label", value=1}, --{id="Water", name="Water type", type="select", options={"basic","reflective","dynamic","reflective&refractive","bump-mapped"}, value=(tonumber(Spring.GetConfigInt("Water",1) or 1)+1)},
        {
            id = "advgraphics",
            name = "Graphics",
            type = "select",
            options = {"Minimum", "Classic", "Max"},
            value = (tonumber(Spring.GetConfigInt("advgraphics", 1) or 1)) + 1,
            description = "Enable adv graphics, light effects and shadows"
        },
        {
            id = "camera",
            name = "Camera Style",
            type = "select",
            options = {"TA (Classic)", "Spring (Smooth)"},
            value = (tonumber(Spring.GetConfigInt("CamSetting", 1) or 1))
        },
        {
            id = "smoothcamid",
            name = "Smooth camera ",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("smoothcam", 1) or 1) == 1,
            description = "Smoothcamera on or off"
        },
        {
            id = "mapborder",
            name = "Show map border",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("mapborder", 1) or 1) == 1,
            description = "Map border."
        },
        --{id="advgraphics", name="High graphics", type="bool", value=tonumber(Spring.GetConfigInt("advgraphics",1) or 1) == 1, description="Enable adv graphics, light effects and shadows"},

        {
            id = "alwaysrenderwrecksandtrees",
            name = "Always show wrecks and trees",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("alwaysrenderwrecksandtrees", 1) or 1) == 1,
            description = "Always show wrecks and trees"
        },
        --{id="advmapshading", name="Advanced map shading", type="bool", value=tonumber(Spring.GetConfigInt("AdvMapShading",1) or 1) == 1, description="When disabled: shadows are disabled too"}, --{id="advmodelshading", name="Advanced model shading", type="bool", value=tonumber(Spring.GetConfigInt("AdvModelShading",1) or 1) == 1}, --{id="lighteffects", group="gfx", name="Advanced lighting ", type="bool", value=widgetHandler.orderList["Light Effects"] ~= nil and (widgetHandler.orderList["Light Effects"] > 0), description="Adds lights to projectiles, lasers and explosions.\n\nRequires shaders."}, --    {id="sharpen", group="gfx", name="Sharpen ", type="bool", value=widgetHandler.orderList["Contrast Adaptive Sharpen"] ~= nil and (widgetHandler.orderList["Contrast Adaptive Sharpen"] > 0), description="Sharpen all visible textures"}, --{id="lups", widget="LupsManager", name="Special effects ", type="bool", value=widgetHandler.orderList["LupsManager"] ~= nil and (widgetHandler.orderList["LupsManager"] > 0), description="Toggle unit particle effects: jet beams, ground flashes, fusion energy balls"}, --{id="shadows", name="Shadows ", type="bool", value=tonumber(Spring.GetConfigInt("Shadows",1) or 1) == 1, description="Shadow detail is currently controlled by"Shadow Quality Manager" widget\n...this widget will auto reduce detail when fps gets low.\n\nShadows requires"Advanced map shading" option to be enabled"},
        {
            id = "particles",
            name = "Max explosion particles",
            type = "slider",
            min = 0,
            max = 60000,
            step = 1,
            value = tonumber(Spring.GetConfigInt("MaxParticles", 1) or 30000),
            description = "How many explosion particles can exist"
        },
        {
            id = "nanoparticles",
            name = "Max nano particles",
            type = "slider",
            min = 0,
            max = 10000,
            step = 1,
            value = tonumber(Spring.GetConfigInt("MaxNanoParticles", 1) or 500),
            description = ""
        },
        {
            id = "decals",
            name = "Ground decal duration",
            type = "slider",
            min = 0,
            max = 10,
            step = 1,
            value = tonumber(Spring.GetConfigInt("GroundDecals", 1) or 1),
            description = "Set how much/duration map decals will be drawn\n\n(unit footsteps/tracks, darkening under buildings and scorches ground at explosions)"
        },
        -- {id="grassdetail", name="Grass", type="slider", min=0, max=10, step=1, value=tonumber(Spring.GetConfigInt("GrassDetail",1) or 0), description="Amount of grass displayed\n\n"}, -- only one of these shadow options are shown, depending if"Shadow Quality Manager" widget is active --{id="shadowslider", name="Shadows", type="slider", min=0, max=6000, step=1,value=tonumber(Spring.GetConfigInt("ShadowMapSize",1) or 1000), description="Set shadow detail\nSlider positioned the very left means shadows will be disabled\n\nShadows requires"Advanced map shading" option to be enabled"}, --{id="fsaa", name="Anti Aliasing", type="slider", min=0, max=8, step=1, value=tonumber(Spring.GetConfigInt("FSAALevel",1) or 0), description=""},
        {
            id = "msaa",
            name = "Anti Aliasing",
            type = "slider",
            min = 0,
            max = 4,
            step = 2,
            value = tonumber(Spring.GetConfigInt("MSAALevel", 0) or 0),
            description = "Requires restart, reduce jagged edges."
        },
        {
            id = "Water",
            name = "Water type",
            type = "select",
            options = {"basic", "reflective", "bump-mapped"},
            value = (tonumber(Spring.GetConfigInt("Water", 1) or 1) + 1)
        },
        --  {
        --    id = "blank1",
        --    name = "",
        --     type = "label",
        --    value = 1
        -- },
        --{
        --  id = "ssao",
        --  name = "SSAO (Caution, extreme lag)",
        --  type = "bool",
        --  value = tonumber(Spring.GetConfigInt("ssao", 0) or 0) == 0,
        --   description = "Shading effect."
        --},
        --{id="blank4", name="SETTINGS", type="label", value=1}, --{id="Water2", name="aa2", type="label", value=1},

        {
            id = "fullscreen",
            name = "Fullscreen",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("Fullscreen", 1) or 1) == 1
        },
        --{id="borderless", name="Borderless", type="bool", value=tonumber(Spring.GetConfigInt("WindowBorderless",1) or 1) == 1},
        {
            id = "Cursorcanleavewindow",
            name = "Cursor can leave window",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("Cursorcanleavewindow", 1) or 1) == 1,
            description = "Cursor can leave window"
        },
        {
            id = "screenedgemove",
            name = "Screen edge moves camera",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("FullscreenEdgeMove", 1) or 1) == 1,
            description = "If mouse is close to screen edge this will move camera\n\n"
        },
        --  {
        --     id = "blank1",
        --    name = "",
        --     type = "label",
        --      value = 1
        --   },

        {
            id = "commandsfx",
            widget = "Commands FX",
            name = "Show Ally Commands",
            type = "bool",
            value = widgetHandler.orderList["Commands FX"] ~= nil and (widgetHandler.orderList["Commands FX"] > 0),
            description = "Shows unit command target lines when you give orders\n\nAlso see the commands your teammates are giving to their units"
        },
        --{id="treeradius", name="Tree render distance", type="slider", min=0, max=2000, value=tonumber(Spring.GetConfigInt("TreeRadius",1) or 1000), description="Applies to SpringRTS engine default trees\n\n"}, --{id="crossalpha", name="Mouse cross alpha", type="slider", min=0, max=1, value=tonumber(Spring.GetConfigInt("CrossAlpha",1) or 1), description="Opacity of mouse icon in center of screen when you are in camera pan mode\n\n(\"icon\" looks like: dot in center with 4 arrowed pointing in all directions) "}, --{id="border", name="Immersive map border", type="bool", value=tonumber(Spring.GetConfigInt("chatsound",1) or 1) == 1, description="Adds cloudy border."}, --{id="grounddetail", name="Ground mesh detail", type="slider", min=20, max=100,step=1, value=tonumber(Spring.GetConfigInt("GroundDetail",1) or 50), description="Ground mesh detail (polygon detail of the map)"}, --  {id="mapedgeextension", widget="Map Edge Extension", name="Map edge extension", type="bool", value=widgetHandler.orderList["Map Edge Extension"] ~= nil and (widgetHandler.orderList["Map Edge Extension"] > 0), description="Mirrors the map at screen edges and darkens and decolorizes them\n\nHave shaders enabled for best result"}, --{id="advsky", name="AdvSky", type="bool", value=tonumber(Spring.GetConfigInt("AdvSky",1) or 1) == 1, description="Enables high resolution clouds\n\n"}, --   {id="snow", widget="Snow", name="Snow", type="bool", value=widgetHandler.orderList["Snow"] ~= nil and (widgetHandler.orderList["Snow"] > 0), description="Lets it snow on winter maps, auto reduces when your fps gets lower + unitcount higher\n\nYou can give the command /snow to toggle snow for the current map (it remembers)"}, -- {id="3dtrees", name="3DTrees", type="bool", value=tonumber(Spring.GetConfigInt("3DTrees",1) or 1) == 1, description="3d trees, it looks better disabled"}, --{id="fpstimespeed", name="Display FPS, GameTime and Speed", type="bool", value=tonumber(Spring.GetConfigInt("ShowFPS",1) or 1) == 1, description="Located at the top right of the screen\n\nIndividually toggle them with /fps /clock /speed"},

        {
            id = "speccursors",
            name = "Show spectator cursors",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("speccursors", 1) or 1) == 1,
            description = "Show spec cursors"
        },
        {
            id = "showchat",
            name = "Allow chat and map drawings",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("showchat", 1) or 1) == 1,
            description = "Show chat and map marks"
        },
        {
            id = "chatsound",
            name = "Chat notification sound",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("chatsound", 1) or 1) == 1,
            description = "When green, incoming messages make a sound"
        },
        {
            id = "Profanity",
            name = "Hide rude chat",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("ProfanityFilter", 1) or 1) == 1,
            description = "When green, rude text will be filtered"
        },
        {
            id = "nametags",
            name = "Hide commander name tags",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("nametags", 1) or 1) == 1,
            description = "Commander name tags"
        },
        {
            id = "newunitselectionboxstyle",
            name = "New selection box style",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("newunitselectionboxstyle", 1) or 1) == 1,
            description = "Fancy selected unit boxes"
        },
        {
            id = "reduceping",
            name = "Reduce Ping (Disable if your net lags)",
            type = "bool",
            value = tonumber(Spring.GetConfigInt("reduceping", 1) or 1) == 1,
            description = "Requires restart, Lowers your ping, disable this if you have an unstable connection"
        },
        {
            id = "adaptive",
            name = "Boost perfomance when FPS drops ",
            type = "bool",
            value = widgetHandler.orderList["Adaptive graphics"] ~= nil and
                (widgetHandler.orderList["Adaptive graphics"] > 0),
            description = "Boost perfomance if FPS is low"
        },
        {
            id = "sndvolmaster",
            name = "Sound volume",
            type = "slider",
            min = 0,
            max = 100,
            step = 1,
            value = tonumber(Spring.GetConfigInt("snd_volmaster", 1) or 100)
        }
    }

    local processedOptions = {}
    local insert = true

    for oid, option in pairs(options) do
        insert = true

        if option.type == "slider" then
            if option.value < option.min then
                option.value = option.min
            end

            if option.value > option.max then
                option.value = option.max
            end
        end

        if
            option.id == "shadows" and
                (fullWidgetsList["Shadow Quality Manager"] == nil or
                    (widgetHandler.orderList["Shadow Quality Manager"] == 0))
         then
            insert = false
        end

        if
            option.id == "shadowslider" and fullWidgetsList["Shadow Quality Manager"] ~= nil and
                (widgetHandler.orderList["Shadow Quality Manager"] > 0)
         then
            insert = false
        end

        if option.widget ~= nil and fullWidgetsList[option.widget] == nil then
            insert = false
        end

        if luaShaders ~= 1 then
            if
                option.id == "ssao" or option.id == "dof" or option.id == "bloom" or option.id == "xrayshader" or
                    option.id == "mapedgeextension" or
                    option.id == "snow" or
                    id == "lighteffects" or
                    id == "sharpen" or
                    id == "advgraphics" or
                    id == "mapborder"
             then
                option.description = "You dont have LuaShaders enabled, we will enable it for you but...\n\n"
            end
        end

        if insert then
            table.insert(processedOptions, option)
        end
    end

    options = processedOptions
    --Spring.SetConfigString("advgraphics", value)
end

function widget:Shutdown()
    if buttonGL then
        glDeleteList(buttonGL)
        buttonGL = nil
    end

    if windowList then
        glDeleteList(windowList)
        windowList = nil
    end
end
