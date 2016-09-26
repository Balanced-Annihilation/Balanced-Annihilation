return {
	armatlas = {
		acceleration = 0.09,
		brakerate = 0.75,
		buildcostenergy = 1322,
		buildcostmetal = 68,
		buildpic = "ARMATLAS.DDS",
		buildtime = 3850,
		canfly = true,
		canmove = true,
		category = "ALL MOBILE WEAPON NOTLAND NOTSUB ANTIFLAME ANTIEMG ANTILASER VTOL NOTSHIP NOTHOVER",
		collide = true,
		cruisealt = 70,
		description = "Air Transport",
		energymake = 0.6,
		energyuse = 0.6,
		explodeas = "smallExplosionGenericRed",
		footprintx = 2,
		footprintz = 3,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 240,
		maxslope = 10,
		maxvelocity = 7.25,
		maxwaterdepth = 0,
		name = "Atlas",
		objectname = "ARMATLAS",
		releaseheld = true,
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericRed",
		sightdistance = 260,
		transportcapacity = 1,
		transportmass = 5000,
		transportsize = 3,
		turninplaceanglelimit = 360,
		turnrate = 550,
		blocking = false,
		customparams = {
			death_sounds = "generic",
			paralyzemultiplier = 0.025,
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolarmv",
			},
			select = {
				[1] = "vtolarac",
			},
		},
	},
}
