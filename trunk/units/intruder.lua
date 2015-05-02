return {
	intruder = {
		acceleration = 0.33,
		brakerate = 0.495,
		buildangle = 16384,
		buildcostenergy = 15010,
		buildcostmetal = 1264,
		buildpic = "INTRUDER.DDS",
		buildtime = 14177,
		canmove = true,
		cantbetransported = true,
		category = "ALL HOVER MOBILE WEAPON NOTSUB NOTSHIP NOTAIR SURFACE",
		collisionvolumeoffsets = "0 -4 0",
		collisionvolumescales = "48.2 48.2 87.2",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Amphibious Heavy Assault Transport",
		energymake = 2.6,
		energyuse = 2.9,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		loadingradius = 110,
		mass = 200000000,
		maxdamage = 12500,
		maxvelocity = 1.892,
		maxwaterdepth = 255,
		movementclass = "ATANK3",
		name = "Intruder",
		objectname = "INTRUDER",
		releaseheld = true,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 292,
		trackoffset = -14,
		trackstrength = 10,
		tracktype = "StdTank",
		trackwidth = 42,
		transportcapacity = 20,
		transportsize = 4,
		transportunloadmethod = 2,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.24872,
		turnrate = 215.60001,
		unloadspread = 3,
		customparams = {},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.0 1.52587890767e-06 -0.262496948242",
				collisionvolumescales = "50.3999938965 38.8000030518 83.4750061035",
				collisionvolumetype = "Box",
				damage = 7500,
				description = "Intruder Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 822,
				object = "INTRUDER_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 3750,
				description = "Intruder Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 329,
				object = "4X4C",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
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
				[1] = "tcormove",
			},
			select = {
				[1] = "tcorsel",
			},
		},
	},
}
