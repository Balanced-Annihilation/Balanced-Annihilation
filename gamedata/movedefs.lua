
local moveDatas = {
	AKBOT2 = {
		crushstrength = 50,
		depthmod = 0,
		footprintx = 2,
		footprintz = 2,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 50,
		
	},
	AKBOTBOMB2 = {
		crushstrength = 50,
		depthmod = 0,
		footprintx = 2,
		footprintz = 2,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 50,
		depthModParams = {
			constantCoeff = 1.5,
		},
	},
	ANT = {
		footprintX = 1,
		footprintZ = 1,
		maxWaterDepth = 2,
		crushStrength = 0,
		speedModClass = 1, -- 0 = tank, 1 = kbot, 2 = hover, 3 = ship 
	},
	ALTVEH = {	-- Amphibious light vehicles, like the Muskrat
		crushstrength = 10,	-- plasma kbot crushresistance = 400
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TANK2 = {	-- Stumpy, Raider, Leveler -- (can crush light bots but not DTs)
		crushstrength = 300,	-- plasma kbot crushresistance = 400
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TANK3 = {	-- Samson, Seer, Merl -- (Can't crush)
		crushstrength = 15,
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HTANK3 = {	-- Bulldog, Reaper
		crushstrength = 999,
		footprintx = 4,	--3
		footprintz = 4,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	ATANK3 = {	-- Triton (lvl3), Croc
		crushstrength = 2499,
		depthmod = 0,
		footprintx = 4.5,	--3
		footprintz = 4.5,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	HTANK4 = {	-- Goliath
		crushstrength = 2499,
		footprintx = 4,
		footprintz = 4,
		maxslope = 18,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	ATANK4 = {	-- Poison
		crushstrength = 1499,
		depthmod = 0,
		footprintx = 5,
		footprintz = 5,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	BOAT4 = {
		crushstrength = 40,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 8,
	},
	BOAT5 = {
		crushstrength = 50,
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 10,
	},
	--[[ 
	DBOAT3 = {
		crushstrength = 30,
		footprintx = 3,
		footprintz = 3,
		minwaterdepth = 15,
	},
	]]--
	CRITTERH = {
		crushstrength = 0,
		footprintx = 1,
		footprintz = 1,
		maxslope = 50,
		maxwaterslope = 255,
		maxWaterDepth = 255,
		minwaterdepth = 15,
		speedModClass = 2, -- 0 = tank, 1 = kbot, 2 = hover, 3 = ship 
	},
	DBOAT6 = {
		crushstrength = 252,
		footprintx = 6,
		footprintz = 6,
		minwaterdepth = 15,
	},
	HAKBOT4 = {
		crushstrength = 252,
		depthmod = 0,
		footprintx = 4,
		footprintz = 4,
		maxslope = 36,
		maxwaterdepth = 5000,
		maxwaterslope = 80,
	},
	--[[
	HDBOAT8 = {
		crushstrength = 1400,
		footprintx = 8,
		footprintz = 8,
		minwaterdepth = 15,
	},
	]]--
	HKBOT3 = {
		crushstrength = 1400,
		footprintx = 3,
		footprintz = 3,
		maxslope = 36,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HKBOT4 = {
		crushstrength = 1400,
		footprintx = 4,
		footprintz = 4,
		maxslope = 36,
		maxwaterdepth = 26,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HKBOT5 = {
		crushstrength = 1400,
		footprintx = 5,
		footprintz = 5,
		maxslope = 36,
		maxwaterdepth = 30,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	HOVER3 = {
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 25,
		footprintx = 3,
		footprintz = 3,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HHOVER3 = {
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 252,
		footprintx = 3,
		footprintz = 3,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HOVER4 = {
		badslope = 22,
		badwaterslope = 255,
		crushstrength = 25,
		footprintx = 4,
		footprintz = 4,
		maxslope = 22,
		maxwaterslope = 255,
	},
	HTKBOT4 = {
		crushstrength = 252,
		footprintx = 4,
		footprintz = 4,
		maxslope = 80,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	KBOT1 = {
		crushstrength = 5,
		footprintx = 1,
		footprintz = 1,
		maxslope = 36,
		maxwaterdepth = 5,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	KBOT2 = {		-- All basic kbots really
		crushstrength = 1,		--10
		footprintx = 3,
		footprintz = 3,
		maxslope = 36,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TKBOT2 = {
		crushstrength = 15,
		footprintx = 2,
		footprintz = 2,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	TKBOT3 = {
		crushstrength = 15,
		footprintx = 3,
		footprintz = 3,
		maxwaterdepth = 22,
		depthModParams = {
			minHeight = 4,
			linearCoeff = 0.03,
			maxValue = 0.7,
		}
	},
	VKBOT3 = {
		crushstrength = 1400,
		depthmod = 0,
		footprintx = 3,
		footprintz = 3,
		maxslope = 24,
		maxwaterdepth = 5000,
		maxwaterslope = 30,
	},
	VKBOT5 = {
		crushstrength = 1400,
		depthmod = 0,
		footprintx = 5,
		footprintz = 5,
		maxslope = 24,
		maxwaterdepth = 5000,
		maxwaterslope = 30,
	},
	
	-- Subs
	UBOAT3 = {
		footprintx = 2,
		footprintz = 2,
		minwaterdepth = 15,
		crushstrength = 5,
		subMarine = 1,
	},
	--[[
	UBOAT4 = {
		footprintx = 4,
		footprintz = 4,
		minwaterdepth = 40,
		crushstrength = 5,
		subMarine = 1,
	},
	]]--
	NANO = {
		crushstrength = 0,
		footprintx = 3,
		footprintz = 3,
		maxslope = 18,
		maxwaterdepth = 0,
	},
}

--------------------------------------------------------------------------------
-- Final processing / array format
--------------------------------------------------------------------------------
local defs = {}

for moveName, moveData in pairs(moveDatas) do
	
	moveData.heatmapping = (Spring.GetModOptions() and tonumber(Spring.GetModOptions().mo_heatmap) and (tonumber(Spring.GetModOptions().mo_heatmap) ~= 0))
	moveData.name = moveName
	
	defs[#defs + 1] = moveData
end

return defs

