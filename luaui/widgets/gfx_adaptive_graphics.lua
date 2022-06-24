function widget:GetInfo()
    return {
        name = "Adaptive graphics",
        desc = "adjust graphics for max fps based on fps",
        author = "",
        date = "0",
        license = "GNU GPL, v2 or later",
        layer = -9997,
        enabled = true,
        handler = true
    }
end

local spGetFPS = Spring.GetFPS
local isSpec = Spring.GetSpectatingState()
local prevnumparticles = Spring.GetConfigInt("MaxParticles", 30000)
local graphicslevel = 2
local prevmapborderpreset = tonumber(Spring.GetConfigInt("mapborder", 1))
local minimumenabled = 0

function widget:Shutdown()
    value = tonumber(Spring.GetConfigInt("advgraphics", 1))
    if value == 0 then
        widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
        --  widgetHandler: DisableWidget("Bloom Shader Alternate")
        -- Spring.SetConfigInt("ssao", 0)
        Spring.SendCommands("luarules disablecus")
        widgetHandler:DisableWidget("Deferred rendering")
        widgetHandler:DisableWidget("Light Effects")
        widgetHandler:DisableWidget("Lups")
        widgetHandler:DisableWidget("LupsManager")
        --widgetHandler:EnableWidget("Lups")
        --widgetHandler:EnableWidget("LupsManager")
        --widgetHandler: DisableWidget("SSAO_alternative")

        widgetHandler:DisableWidget("Contrast Adaptive Sharpen")

        Spring.SendCommands("Shadows 0")
        Spring.SendCommands("AdvMapShading 0")
        Spring.SetConfigInt("AdvMapShading", 0)
        Spring.SendCommands("AdvModelShading 0")
        Spring.SetConfigInt("AdvModelShading", 0)
    elseif value == 1 then
        -- Spring.SetConfigInt("ssao",0)
        widgetHandler:EnableWidget("Deferred rendering")
        Spring.SendCommands("luarules disablecus")
        widgetHandler:EnableWidget("Light Effects")

        Spring.SendCommands("Shadows 1 6144")

        Spring.SendCommands("AdvMapShading 1")
        Spring.SetConfigInt("AdvMapShading", 1)
        Spring.SendCommands("AdvModelShading 1")
        Spring.SetConfigInt("AdvModelShading", 1)

        --widgetHandler: DisableWidget("SSAO_alternative")

         widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
        --  widgetHandler: DisableWidget("Bloom Shader Alternate")
        widgetHandler:EnableWidget("Contrast Adaptive Sharpen")
        Spring.SetConfigInt("LuaShaders", 1)
        widgetHandler:EnableWidget("LupsManager")
        widgetHandler:EnableWidget("Lups")
    elseif value == 2 then
        Spring.SendCommands("luarules reloadcus")
        widgetHandler:EnableWidget("Deferred rendering")
        widgetHandler:EnableWidget("Light Effects")

        Spring.SendCommands("Shadows 1 6144")
        Spring.SendCommands("AdvMapShading 1")
        Spring.SetConfigInt("AdvMapShading", 1)
        Spring.SendCommands("AdvModelShading 1")
        Spring.SetConfigInt("AdvModelShading", 1)

         widgetHandler: EnableWidget("Bloom Shader Alternate Deferred")
        -- widgetHandler: EnableWidget("Bloom Shader Alternate")
        widgetHandler:EnableWidget("Contrast Adaptive Sharpen")
        --Spring.SetConfigInt("ssao", 1)
        -- widgetHandler: EnableWidget("SSAO_alternative")
        Spring.SetConfigInt("LuaShaders", 1)
        widgetHandler:EnableWidget("LupsManager")
        widgetHandler:EnableWidget("Lups")
    end
    if (minimumenabled == 1) then
        Spring.SetConfigInt("MaxParticles", prevnumparticles) --reset max particles
        Spring.SetConfigInt("mapborder", prevmapborderpreset)
    end

    --value = tonumber(Spring.GetConfigString("ssao", 0))
    --if value == 0 then
    --	widgetHandler:DisableWidget("SSAO_alternative")
    --	Spring.SetConfigInt("ssao", 0)
    --else
    --	widgetHandler: EnableWidget("SSAO_alternative")
    --	Spring.SetConfigInt("ssao", 1)
    --end
end

--function widget:Initialize()
--	if(isSpec) then
--	Spring.Echo("REMOVENOW")
--	widgetHandler:RemoveWidget(widget)
--	end
--end

function widget:GameFrame(gameFrame)
    if (gameFrame % 600 == 0) and (gameFrame > 1000) then
        if WG["topbar"] and not WG["topbar"].showingRejoining() and not select(6, Spring.GetMouseState()) then --	-- mouse not offscreen
            fps = spGetFPS()

            if spGetFPS() < 20 then
                if graphicslevel == 2 then
                    Spring.SendCommands("luarules disablecus")
                    --widgetHandler: DisableWidget("SSAO_alternative")
                    graphicslevel = graphicslevel - 1
                elseif graphicslevel == 1 then
                    Spring.SendCommands("luarules disablecus")

                    widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
                    --widgetHandler: DisableWidget("Bloom Shader Alternate")
                    --widgetHandler: DisableWidget("SSAO_alternative")
                    Spring.SendCommands("Shadows 0")
                    widgetHandler:DisableWidget("Deferred rendering")
                    widgetHandler:DisableWidget("Light Effects")
                    widgetHandler:DisableWidget("Contrast Adaptive Sharpen")
                    Spring.Echo("High perfomance mode on until next game due to low fps")
                    graphicslevel = graphicslevel - 1
                elseif graphicslevel == 0 then
                    prevmapborderpreset = tonumber(Spring.GetConfigInt("mapborder", 1))
                    Spring.SendCommands("luarules disablecus")

                    widgetHandler:DisableWidget("Map Edge Extension Colourful")
                    --widgetHandler:DisableWidget("Volumetric Clouds")

                    Spring.SendCommands("Shadows 0")

                    widgetHandler:DisableWidget("Deferred rendering")
                    widgetHandler:DisableWidget("Light Effects")
                    widgetHandler:DisableWidget("Contrast Adaptive Sharpen")
                    Spring.SendCommands("AdvMapShading 0")
                    Spring.SendCommands("AdvModelShading 0")
                    widgetHandler:DisableWidget("Lups")
                    widgetHandler:DisableWidget("LupsManager")
                    Spring.Echo("Max perfomance mode on until next game due to low fps")
                    graphicslevel = graphicslevel - 1
                    prevnumparticles = Spring.GetConfigInt("MaxParticles", 30000)
                    if prevnumparticles > 10000 then
                        Spring.SetConfigInt("MaxParticles", 10000)
                    end

                    minimumenabled = 1
                end
            end
        end
    end
end
