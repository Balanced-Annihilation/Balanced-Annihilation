return {
	corvrad = {
		acceleration = 0.03,
		activatewhenbuilt = true,
		brakerate = 0.036,
		buildcostenergy = 1290,
		buildcostmetal = 92,
		buildpic = "corvrad.dds",
		buildtime = 4223,
		canattack = false,
		canmove = true,
		category = "ALL TANK MOBILE NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 0 1",
		collisionvolumescales = "24 18 29",
		collisionvolumetype = "box",
		corpse = "dead",
		description = "Radar Vehicle",
		energymake = 8,
		energyuse = 20,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 510,
		maxslope = 16,
		maxvelocity = 1.25,
		maxwaterdepth = 0,
		movementclass = "TANK3",
		name = "Informer",
		objectname = "CORVRAD",
		onoffable = true,
		radardistance = 2200,
		selfdestructas = "BIG_UNIT",
		sightdistance = 900,
		sonardistance = 0,
		trackstrength = 10,
		tracktype = "StdTank",
		trackwidth = 23,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 0.825,
		turnrate = 210,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.611381530762 -0.0270607836914 -0.43489074707",
				collisionvolumescales = "23.1105194092 8.20951843262 32.5806274414",
				collisionvolumetype = "Box",
				damage = 546,
				description = "Informer Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 64,
				object = "CORVRAD_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 273,
				description = "Informer Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 48,
				object = "2X2F",
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
				[1] = "vcormove",
			},
			select = {
				[1] = "cvradsel",
			},
		},
	},
}
