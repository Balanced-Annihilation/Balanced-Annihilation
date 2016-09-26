return {
	corfdrag = {
		acceleration = 0,
		blocking = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 672,
		buildcostmetal = 21,
		buildpic = "CORFDRAG.DDS",
		buildtime = 1000,
		canattack = false,
		canrepeat = false,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -28 0",
		collisionvolumescales = "37 70 37",
		collisionvolumetype = "box",
		crushresistance = 250,
		description = "Shark's Teeth",
		footprintx = 2,
		footprintz = 2,
		hidedamage = true,
		idleautoheal = 0,
		maxdamage = 15000,
		maxslope = 32,
		minwaterdepth = 1,
		name = "Shark's Teeth",
		objectname = "CORFDRAG",
		repairable = false,
		seismicsignature = 0,
		sightdistance = 1,
		waterline = 3,
		yardmap = "wwww",
			sfxtypes = { 
			pieceExplosionGenerators = { 
				"deathceg3", 
				"deathceg4", 
			}, 
		},
		customparams = {
			death_sounds = "generic",
		},
	},
}