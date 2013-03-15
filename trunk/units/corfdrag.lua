return {
	corfdrag = {
		acceleration = 0,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 630,
		buildcostmetal = 20,
		buildpic = "CORFDRAG.DDS",
		buildtime = 1000,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		corpse = "FLOATINGTEETH_CORE",
		description = "Perimeter Defense",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		isfeature = true,
		maxdamage = 50,
		maxslope = 32,
		minwaterdepth = 1,
		name = "Shark's Teeth",
		objectname = "CORFDRAG",
		seismicsignature = 0,
		sightdistance = 130,
		waterline = 3,
		yardmap = "wwww",
		featuredefs = {
			floatingteeth_core = {
				autoreclaimable = 0,
				blocking = true,
				category = "dragonteeth NOTHOVER",
				damage = 15000,
				description = "Shark's Teeth",
				floating = true,
				footprintx = 2,
				footprintz = 2,
				height = 75,
				hitdensity = 100,
				metal = 20,
				object = "corfdrag",
				reclaimable = true,
				world = "allworld",
			},
		},
	},
}
