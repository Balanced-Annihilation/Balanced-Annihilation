return {
	armamex = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 6092,
		buildcostenergy = 1665,
		buildcostmetal = 190,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 5,
		buildinggrounddecalsizey = 5,
		buildinggrounddecaltype = "armamex_aoplane.dds",
		buildpic = "ARMAMEX.DDS",
		buildtime = 1800,
		category = "ALL NOTSUB NOWEAPON NOTAIR",
		cloakcost = 12,
		corpse = "DEAD",
		description = "Stealthy Cloakable Metal Extractor",
		energyuse = 3,
		explodeas = "TWILIGHT",
		extractsmetal = 0.0010000000474975,
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 14.5,
		idletime = 900,
		initcloaked = true,
		maxdamage = 1450,
		maxslope = 20,
		maxwaterdepth = 0,
		metalstorage = 75,
		mincloakdistance = 66,
		name = "Twilight",
		objectname = "ARMAMEX",
		onoffable = true,
		seismicsignature = 0,
		selfdestructas = "TWILIGHT",
		selfdestructcountdown = 1,
		sightdistance = 286,
		stealth = true,
		usebuildinggrounddecal = true,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 870,
				description = "Twilight Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 9,
				hitdensity = 100,
				metal = 103,
				object = "ARMAMEX_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 435,
				description = "Twilight Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				hitdensity = 100,
				metal = 41,
				object = "3X3A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
		},
		sounds = {
			activate = "mexrun2",
			canceldestruct = "cancel2",
			deactivate = "mexoff2",
			underattack = "warning1",
			working = "mexrun2",
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
				[1] = "servmed2",
			},
			select = {
				[1] = "mexon2",
			},
		},
	},
}
