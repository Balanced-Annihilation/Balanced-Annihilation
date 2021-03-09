
function widget:GetInfo()
return {
    name      = "Adaptive graphics",
    desc      = "adjust graphics for max fps based on fps",
    author    = "",
    date      = "0",
    license   = "GNU GPL, v2 or later",
    layer     = -10000,
    enabled = true,
	handler = true, 
}
end


local turnedShadowsOff = false
local spGetFPS				= Spring.GetFPS
local isSpec = Spring.GetSpectatingState()

function widget:Shutdown()

	local advgraphics = tonumber(Spring.GetConfigInt("advgraphics",1) or 1)
	if(advgraphics == 1) then
							Spring.SendCommands({"shadows 1 "..6144})

				widgetHandler:EnableWidget("Projectile lights")
				widgetHandler:EnableWidget("Deferred rendering")
				widgetHandler:EnableWidget("Light Effects")
				widgetHandler:EnableWidget("Contrast Adaptive Sharpen")
				widgetHandler:EnableWidget("LupsManager")
						--	Spring.SendCommands("AdvMapShading "..1)

			--Spring.SetConfigString("AdvMapShading", "1")
			--Spring.SendCommands("AdvModelShading "..1)
			--Spring.SetConfigString("AdvModelShading", "1")
	end
	
	
end
local supermaxfpsmode = false
local maxfpsmode = false

function widget:GameFrame(gameFrame)
		if (not isSpec) and (not supermaxfpsmode) then
		if gameFrame > 1000 and gameFrame%500==0 then 
			--local modelCount = #spGetVisibleUnits(-1,nil,false) + #spGetVisibleFeatures(-1,nil,false,false) -- expensive

			if (not supermaxfpsmode) and maxfpsmode and spGetFPS() <= 10 then
						supermaxfpsmode = true
						Spring.SendCommands("AdvMapShading "..0)
						Spring.SendCommands("AdvModelShading "..0)
						widgetHandler:DisableWidget("LupsManager")
						Spring.Echo("Max perfomance mode on until next game")
			end
			
			if (not maxfpsmode) and spGetFPS() <= 10 then
						maxfpsmode = true
						--Spring.SendCommands("AdvMapShading "..0)
						--Spring.SendCommands("AdvModelShading "..0)
														Spring.SendCommands({"shadows 0"})

						widgetHandler:DisableWidget("Projectile lights")
						widgetHandler:DisableWidget("Deferred rendering")
						widgetHandler:DisableWidget("Light Effects")
						widgetHandler:DisableWidget("Contrast Adaptive Sharpen")
						Spring.Echo("High perfomance mode on until next game")

						--widgetHandler:DisableWidget("LupsManager")
			end
			
			
		end
		end
end
	

