return {
	armck = {
		acceleration = 0.23999999463558,
		brakerate = 0.5,
		buildcostenergy = 1521,
		buildcostmetal = 102,
		builddistance = 128,
		builder = true,
		buildpic = "ARMCK.DDS",
		buildtime = 3453,
		canmove = true,
		category = "KBOT MOBILE ALL NOTSUB NOWEAPON NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Tech Level 1",
		energymake = 7,
		energystorage = 50,
		energyuse = 7,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5.4000000953674,
		idletime = 900,
		maxdamage = 540,
		maxslope = 20,
		maxvelocity = 1.2000000476837,
		maxwaterdepth = 25,
		metalmake = 0.070000000298023,
		metalstorage = 50,
		movementclass = "KBOT2",
		name = "Construction Kbot",
		objectname = "ARMCK",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 305,
		smoothanim = true,
		terraformspeed = 450,
		turnrate = 1100,
		upright = true,
		workertime = 90,
		buildoptions = {
			[1] = "armsolar",
			[2] = "armadvsol",
			[3] = "armwin",
			[4] = "armgeo",
			[5] = "armmstor",
			[6] = "armestor",
			[7] = "armmex",
			[8] = "armamex",
			[9] = "armmakr",
			[10] = "armalab",
			[11] = "armlab",
			[12] = "armvp",
			[13] = "armap",
			[14] = "armsy",
			[15] = "armhp",
			[16] = "armnanotc",
			[17] = "armeyes",
			[18] = "armrad",
			[19] = "armdrag",
			[20] = "armclaw",
			[21] = "armllt",
			[22] = "tawf001",
			[23] = "armhlt",
			[24] = "armguard",
			[25] = "armrl",
			[26] = "packo",
			[27] = "armcir",
			[28] = "armdl",
			[29] = "armjamt",
			[30] = "ajuno",
		},
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "28.1473846436 25.0852355957 27.3032073975",
				collisionvolumeoffsets = "1.68473052979 1.77978515623e-05 -1.12860870361",
				category = "corpses",
				damage = 324,
				description = "Construction Kbot Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 40,
				hitdensity = 100,
				metal = 66,
				object = "ARMCK_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 162,
				description = "Construction Kbot Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 26,
				object = "2X2D",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			capture = "capture1",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
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
				[1] = "kbarmmov",
			},
			select = {
				[1] = "kbarmsel",
			},
		},
	},
}
