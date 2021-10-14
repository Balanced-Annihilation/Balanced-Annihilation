
function widget:GetInfo()
return {
    name      = "Adaptive graphics",
    desc      = "adjust graphics for max fps based on fps",
    author    = "",
    date      = "0",
    license   = "GNU GPL, v2 or later",
    layer     = -9997,
    enabled = true,
	handler = true, 
}
end

local spGetFPS				= Spring.GetFPS
local isSpec = Spring.GetSpectatingState()
local prevnumparticles = Spring.GetConfigInt("MaxParticles",25000)
local graphicslevel = 2
local previmmersiveborderpreset=tonumber(Spring.GetConfigInt("immersiveborder",1))
local minimumenabled = 0

function widget:Shutdown()
			value = tonumber(Spring.GetConfigString("advgraphics", 1))
			if value == 0 then
				 Spring.SendCommands("shadows 0 1024")
				 widgetHandler: DisableWidget("Deferred rendering")
				 widgetHandler: DisableWidget("Projectile lights")
				 widgetHandler: DisableWidget("Light Effects")
				 widgetHandler: DisableWidget("Contrast Adaptive Sharpen")
				 widgetHandler: DisableWidget("LupsManager")
				 Spring.SendCommands("AdvMapShading "..0)
				 Spring.SetConfigInt("AdvMapShading", 0)
				 Spring.SendCommands("AdvModelShading "..0)
				 Spring.SetConfigInt("AdvModelShading", 0)
				 widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
				  widgetHandler: DisableWidget("Bloom Shader Alternate")
				 Spring.SetConfigInt("ssao", "0")
				-- widgetHandler: DisableWidget("SSAO_alternative")
			 elseif value == 1 then
				 widgetHandler: EnableWidget("Deferred rendering")
				 Spring.SendCommands("AdvMapShading "..1)
				 Spring.SetConfigInt("AdvMapShading", 1)
				 Spring.SendCommands("AdvModelShading "..1)
				 Spring.SetConfigInt("AdvModelShading", 1)
				 Spring.SendCommands("shadows 1 6144")
				 widgetHandler: EnableWidget("Projectile lights")
				 widgetHandler: EnableWidget("Light Effects")
				 widgetHandler: EnableWidget("Contrast Adaptive Sharpen")
				 widgetHandler: EnableWidget("LupsManager")
				 widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
				  widgetHandler: DisableWidget("Bloom Shader Alternate")
				 Spring.SetConfigInt("ssao", "0")
				-- widgetHandler: DisableWidget("SSAO_alternative")
			 elseif value == 2 then
				 widgetHandler: EnableWidget("Deferred rendering")
				 Spring.SendCommands("AdvMapShading "..1)
				 Spring.SetConfigInt("AdvMapShading", 1)
				 Spring.SendCommands("AdvModelShading "..1)
				 Spring.SetConfigInt("AdvModelShading", 1)
				 Spring.SendCommands("shadows 1 6144")
				 widgetHandler: EnableWidget("Projectile lights")
				 widgetHandler: EnableWidget("Light Effects")
				 widgetHandler: EnableWidget("Contrast Adaptive Sharpen")
				 widgetHandler: EnableWidget("LupsManager")
				 widgetHandler: EnableWidget("Bloom Shader Alternate Deferred")
				  widgetHandler: EnableWidget("Bloom Shader Alternate")
				 Spring.SetConfigInt("ssao", "1")
				-- widgetHandler: EnableWidget("SSAO_alternative")
			 end
			 if(minimumenabled == 1) then
				Spring.SetConfigInt("MaxParticles",prevnumparticles) --reset max particles
				Spring.SetConfigInt("immersiveborder",previmmersiveborderpreset) 
			end

end

function widget:GameFrame(gameFrame)
		if (not isSpec) and (graphicslevel > -1) then
		if gameFrame > 1000 and gameFrame%500==0 then 
				fps = spGetFPS()	
				if graphicslevel == 2 and spGetFPS() < 25 then
					widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
					widgetHandler: DisableWidget("Bloom Shader Alternate")
					--widgetHandler: DisableWidget("SSAO_alternative")
					graphicslevel = graphicslevel-1
				elseif spGetFPS() < 20 then
					if graphicslevel == 1 then
						widgetHandler: DisableWidget("Bloom Shader Alternate Deferred")
						widgetHandler: DisableWidget("Bloom Shader Alternate")
						--widgetHandler: DisableWidget("SSAO_alternative")
						Spring.SendCommands({"shadows 0"})
						widgetHandler:DisableWidget("Projectile lights")
						widgetHandler:DisableWidget("Deferred rendering")
						widgetHandler:DisableWidget("Light Effects")
						--widgetHandler:DisableWidget("Contrast Adaptive Sharpen")
						Spring.Echo("High perfomance mode on until next game")
						graphicslevel = graphicslevel-1

					elseif graphicslevel == 0 then
						previmmersiveborderpreset=tonumber(Spring.GetConfigInt("immersiveborder",0))

						widgetHandler:DisableWidget("Map Edge Extension Colourful")
						--widgetHandler:DisableWidget("Volumetric Clouds")
					
						Spring.SendCommands("AdvMapShading "..0)
						Spring.SendCommands("AdvModelShading "..0)
						widgetHandler:DisableWidget("LupsManager")
						Spring.Echo("Max perfomance mode on until next game")
						graphicslevel = graphicslevel-1
						prevnumparticles = Spring.GetConfigInt("MaxParticles",25000)
						if prevnumparticles > 10000 then
							Spring.SetConfigInt("MaxParticles",10000)
						end
						
						minimumenabled= 1
						
						
						
					end
				end
		end
		end
end


