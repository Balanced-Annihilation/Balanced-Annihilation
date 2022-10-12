
	if (gl.CreateShader)then
			Spring.SetConfigInt("AdvMapShading", 1)
			Spring.SetConfigInt("AdvModelShading", 1)
			Spring.SetConfigInt("LuaShaders", 1)
			Spring.SetConfigInt("AllowDeferredMapRendering", 1)
			Spring.SetConfigInt("AllowDeferredModelRendering", 1)
			else

				Spring.SetConfigInt("LuaShaders", 0)
			Spring.SetConfigInt("AllowDeferredMapRendering", 0)
			Spring.SetConfigInt("AllowDeferredModelRendering", 0)
			Spring.SetConfigInt("advgraphics", 0)
			Spring.SetConfigInt("AdvMapShading", 0)
			Spring.SetConfigInt("AdvUnitShading", 0)
			Spring.SetConfigInt("UseVBO", 0)
			Spring.SetConfigInt("mapborder", 0)
			end
			Spring.SetConfigString("UsePBO", "0")
Spring.SetConfigString("AdvSky", "0") --always disable this
Spring.SetConfigString("DynamicSky", "0") --always disable this





if Spring.GetConfigInt("ForceDisableShaders", 0) == 1 then
	Spring.SetConfigInt("ForceDisableShaders", 0)
end

Spring.SetConfigInt("MaxDynamicModelLights", 0)
Spring.SetConfigInt("LoadingMT", 0)

	--Spring.SetConfigString("LuaGarbageCollectionMemLoadMult", "1.33")
	--Spring.SetConfigString("LuaGarbageCollectionRunTimeMult", "5")

-- Spring.SetConfigInt("LuaGarbageCollectionMemLoadMult", 1)
Spring.SetConfigInt("LuaGarbageCollectionRunTimeMult", 2)
Spring.SetConfigInt("ROAM", 1)
Spring.SetConfigInt("UseHighResTimer", 1)
Spring.SetConfigInt("ServerSleepTime", 1)
Spring.SetConfigFloat("CrossAlpha", 0)

Spring.SetConfigInt("MiniMapDrawProjectiles", 0)
Spring.SetConfigInt("MiniMapDrawCommands", 1)

Spring.SetConfigInt("BlockCompositing", 0)
Spring.SetConfigInt("HardwareCursor", 1)

local value = tonumber(Spring.GetConfigInt("BAMaxParticles", 30000) or 30000)
Spring.SetConfigInt("MaxParticles", value)
Spring.SetConfigInt("BAMaxParticles", value)

value = tonumber(Spring.GetConfigInt("BAMaxNanoParticles", 3000) or 3000)
Spring.SetConfigInt("MaxNanoParticles", value)
Spring.SetConfigInt("BAMaxNanoParticles", value)

local valueb = tonumber(Spring.GetConfigInt("BAGroundDecals", "1") or "1")
Spring.SetConfigString("GroundDecals", valueb)
Spring.SetConfigString("BAGroundDecals", valueb)

Spring.SetConfigString("Water", "1")
