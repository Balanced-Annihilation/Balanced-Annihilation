--------------------------
-- DOCUMENTATION
-------------------------

-- BA contains weapondefs in its unitdef files
-- Standalone weapondefs are only loaded by Spring after unitdefs are loaded
-- So, if we want to do post processing and include all the unit+weapon defs, and have the ability to bake these changes into files, we must do it after both have been loaded
-- That means, ALL UNIT AND WEAPON DEF POST PROCESSING IS DONE HERE

-- What happens:
-- unitdefs_post.lua calls the _Post functions for unitDefs and any weaponDefs that are contained in the unitdef files
-- unitdefs_post.lua writes the corresponding unitDefs to customparams (if wanted)
-- weapondefs_post.lua fetches any weapondefs from the unitdefs, 
-- weapondefs_post.lua fetches the standlaone weapondefs, calls the _post functions for them, writes them to customparams (if wanted)
-- strictly speaking, alldefs.lua is a misnomer since this file does not handle armordefs, featuredefs or movedefs

-- Switch for when we want to save defs into customparams as strings (so as a widget can then write them to file)
-- The widget to do so can be found in 'etc/Lua/bake_unitdefs_post'
SaveDefsToCustomParams = false

-------------------------
-- DEFS POST PROCESSING
-------------------------


function UnitDef_Post(name, uDef)


	-- usable when baking ... keeping subfolder structure
	if SaveDefsToCustomParams then
		local filepath = getFilePath(name..'.lua', 'units/')
		if filepath then
			uDef.customparams = uDef.customparams or {}
			uDef.customparams.subfolder = string.sub(filepath, 7, #filepath-1)
		end
	end
end


-- process weapondef
function WeaponDef_Post(name, wDef)

	--Use targetborderoverride in weapondef customparams to override this global setting
	--Controls whether the weapon aims for the center or the edge of its target's collision volume. Clamped between -1.0 - target the far border, and 1.0 - target the near border.
	if wDef.customparams and wDef.customparams.targetborderoverride == nil then
		wDef.targetborder = 0.75 --Aim for just inside the hitsphere
	elseif wDef.customparams and wDef.customparams.targetborderoverride ~= nil then
		wDef.targetborder = tonumber(wDef.customparams.targetborderoverride)
	end

	wDef.cratermult = (wDef.cratermult or 1) * 0.3 -- modify cratermult cause Spring v103 made too big craters

	-- EdgeEffectiveness global buff to counterbalance smaller hitboxes
	wDef.edgeeffectiveness = (tonumber(wDef.edgeeffectiveness) or 0) + 0.15
	if wDef.edgeeffectiveness >= 1 then
	    wDef.edgeeffectiveness = 1
	end

	-- Target borders of unit hitboxes rather than center (-1 = far border, 0 = center, 1 = near border)
	-- wDef.targetborder = 1.0


	if wDef.weapontype == "Cannon" then
		if wDef.stages == nil then
			wDef.stages = 10
			if wDef.damage ~= nil and wDef.damage.default ~= nil and wDef.areaofeffect ~= nil then
				wDef.stages = math.floor(7.5 + math.min(wDef.damage.default * 0.0033, wDef.areaofeffect * 0.13))
				wDef.alphadecay = 1 - ((1/wDef.stages)/1.5)
				wDef.sizedecay = 0.4 / wDef.stages
			end
		end
	end

	if wDef.damage ~= nil then
		wDef.damage.indestructable = 0
	end

	if wDef.weapontype == "BeamLaser" then
		if wDef.beamttl == nil then
			wDef.beamttl = 3
			wDef.beamdecay = 0.7
		end
	end
end

-- process effects
function ExplosionDef_Post(name, eDef)

end



--------------------------
-- MODOPTIONS
-------------------------

-- process modoptions (last, because they should not get baked)
function ModOptions_Post (UnitDefs, WeaponDefs)
	if (Spring.GetModOptions) then
	local modOptions = Spring.GetModOptions() or {}
	local map_tidal = modOptions and modOptions.map_tidal
		if map_tidal and map_tidal ~= "unchanged" then
			for id, unitDef in pairs(UnitDefs) do
				if unitDef.tidalgenerator == 1 then
					unitDef.tidalgenerator = 0
					if map_tidal == "low" then
						unitDef.energymake = 13
					elseif map_tidal == "medium" then
						unitDef.energymake = 18
					elseif map_tidal == "high" then
						unitDef.energymake = 23
					end
				end
			end
		end

		-- transporting enemy coms
		if (modOptions.transportenemy == "notcoms") then
			for name,ud in pairs(UnitDefs) do  
				if (name == "armcom" or name == "corcom" or name == "armdecom" or name == "cordecom") then
					ud.transportbyenemy = false
				end
			end
		elseif (modOptions.transportenemy == "none") then
			for name, ud in pairs(UnitDefs) do  
				ud.transportbyenemy = false
			end
		end
	end
end


-------------------------
-- util
-------------------------

function getFilePath(filename, path)
	local files = VFS.DirList(path, '*.lua')
	for i=1,#files do
		if path..filename == files[i] then
			return path
		end
	end
	local subdirs = VFS.SubDirs(path)
	for i=1,#subdirs do
		local result = getFilePath(filename, subdirs[i])
		if result then
			return result
		end
	end
	return false
end

function lines(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((str:gsub("(.-)\r?\n", helper)))
	return t
end

function Split(s, separator)
	local results = {}
	for part in s:gmatch("[^"..separator.."]+") do
		results[#results + 1] = part
	end
	return results
end
