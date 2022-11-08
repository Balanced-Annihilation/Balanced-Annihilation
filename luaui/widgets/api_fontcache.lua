function widget:GetInfo()
    return {
        name    = "Font Cache",
        desc    = "Font cache for widgets",
        author  = "Floris, CommanderSpice",
        date    = "2020-06-01",
        license = "GPL-2.0+",
        layer   = -math.huge,
        enabled = true,
    }
end

-- FIXME: Do we want global font presets?
local defaultFile = "fonts/" .. Spring.GetConfigString("ba_font", "FreeSansBold.otf")
local defaultFile2 = "fonts/" .. Spring.GetConfigString("ba_font2", "FreeSansBold.otf")
local defaultSize = 32
local defaultOutlineSize = 0.17
local defaultOutlineStrength = 1.05

local presets = {
    {defaultFile, defaultSize, defaultOutlineSize, defaultOutlineStrength},
    {defaultFile, defaultSize, 0.2, 1.3},
    {defaultFile2, defaultSize, defaultOutlineSize, defaultOutlineStrength},
    {defaultFile2, defaultSize, 0.2, 1.3},
}

local fonts = {}

-- TODO: Global font scale factor.
local fontScale = 1

local worldView
local worldProj
local screenView
local screenProj

local function updateFontMatrices(font)
    if screenView == nil or screenProj == nil then
        screenView = {gl.GetScreenViewMatrix()}
        screenProj = {gl.GetScreenProjMatrix()}
    end
    font:SetTextViewMatrix(screenView)
    font:SetTextProjMatrix(screenProj)
end

local function createFont(file, size, outlineSize, outlineStrength)
--    Spring.Echo("Loading font: " .. file .. "," .. size*fontScale .. "," .. outlineSize*fontScale .. "," .. outlineStrength)
    font = gl.LoadFont(file, size*fontScale, outlineSize*fontScale, outlineStrength)
    updateFontMatrices(font)
    return font
end

function widget:Initialize()
    WG.fonts = {}
    WG.fonts.getFont = function(file, size, outlineSize, outlineStrength)
        if type(file) == 'number' and presets[file] then
            file, size, outlineSize, outlineStrength = unpack(presets[file])
        else
            file = (file and file or defaultFile)
            size = (size and size or defaultSize)
            outlineSize = (outlineSize and outlineSize or defaultOutlineSize)
            outlineStrength = (outlineStrength and outlineStrength or defaultOutlineStrength)
        end

        local id = file..'_'..size..'_'..outlineSize..'_'..outlineStrength
        if fonts[id] == nil then
            fonts[id] = createFont(file, size, outlineSize, outlineStrength)
        end
        return fonts[id]
    end
end

function widget:Shutdown()
    WG.fonts.getFont = nil

    for id, font in pairs(fonts) do
        Spring.Echo("Deleting font " .. id)
        gl.DeleteFont(fonts[id])
        fonts[id] = nil
    end
end

function widget:ViewResize(viewSizeX, viewSizeY)
    screenView = {gl.GetScreenViewMatrix()}
    screenProj = {gl.GetScreenProjMatrix()}
end

-- function widget:DrawWorld()
--     worldView = {gl.GetMatrixData(GL.MODELVIEW)}
--     worldProj = {gl.GetMatrixData(GL.PROJECTION)}
--     for id, font in pairs(fonts) do
--         updateFontMatrices(font, worldView, worldProj)
--     end
-- end

function widget:DrawScreen()
    for id, font in pairs(fonts) do
        updateFontMatrices(font, screenView, screenProj)
    end
end

-- function widget:GetConfigData()
--     return {fontScale=fontScale}
-- end

-- function widget:SetConfigData(data)
--     if Spring.GetGameFrame() > 0 then
--         -- if data.fonts ~= nil then
--         --     fonts = data.fonts
--         --     fontScale = data.fontScale
--         -- end
--         fontScale = data.fontScale
--     end
-- end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
    -- Shift+F10
    if (key == 291 and mods.shift) then
        local loadedFonts = ""
        for id, font in pairs(fonts) do
            loadedFonts = loadedFonts .. "\n" .. id
        end
        Spring.Echo("Cached fonts:" .. loadedFonts)
    end
end
