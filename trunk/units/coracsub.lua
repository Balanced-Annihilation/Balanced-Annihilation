return {
	coracsub = {
		acceleration = 0.035000000149012,
		brakerate = 0.2119999974966,
		buildcostenergy = 7911,
		buildcostmetal = 690,
		builddistance = 300,
		builder = true,
		buildpic = "CORACSUB.DDS",
		buildtime = 17228,
		canguard = true,
		canmove = true,
		canpatrol = true,
		category = "ALL UNDERWATER MOBILE NOTLAND NOWEAPON NOTAIR",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "40 11 80",
		collisionvolumetest = 1,
		collisionvolumetype = "Ell",
		corpse = "DEAD",
		description = "Tech Level 2",
		energymake = 30,
		energystorage = 150,
		energyuse = 30,
		explodeas = "SMALL_UNITEX",
		footprintx = 3,
		footprintz = 3,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 370,
		maxvelocity = 2.0699999332428,
		metalmake = 0.30000001192093,
		metalstorage = 150,
		minwaterdepth = 20,
		movementclass = "UBOAT3",
		name = "Advanced Construction Sub",
		noautofire = false,
		objectname = "CORACSUB",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		sightdistance = 156,
		smoothanim = false,
		terraformspeed = 900,
		turnrate = 364,
		waterline = 30,
		workertime = 300,
		buildoptions = {
			[1] = "coruwfus",
			[2] = "coruwmme",
			[3] = "coruwmmm",
			[4] = "coruwadves",
			[5] = "coruwadvms",
			[6] = "corfatf",
			[7] = "corplat",
			[8] = "corsy",
			[9] = "corasy",
			[10] = "csubpen",
			[11] = "corason",
			[12] = "corenaa",
			[13] = "coratl",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				damage = 222,
				description = "Advanced Construction Sub Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 449,
				object = "CORACSUB_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 716,
				description = "Advanced Construction Sub Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 183,
				object = "4X4C",
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
				[1] = "sucormov",
			},
			select = {
				[1] = "sucorsel",
			},
		},
	},
}
