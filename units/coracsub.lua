return {
	coracsub = {
		acceleration = 0.035,
		brakerate = 0.636,
		buildcostenergy = 11638,
		buildcostmetal = 844,
		builddistance = 160,
		builder = true,
		buildpic = "CORACSUB.DDS",
		buildtime = 24205,
		canmove = true,
		category = "ALL UNDERWATER MOBILE NOTLAND NOWEAPON NOTAIR NOTHOVER",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "38 9 80",
		collisionvolumetype = "box",
		corpse = "DEAD",
		description = "Tech Level 2",
		energymake = 30,
		energystorage = 150,
		energyuse = 30,
		explodeas = "small_unitex",
		footprintx = 3,
		footprintz = 3,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 370,
		maxvelocity = 2.07,
		metalmake = 0.3,
		metalstorage = 150,
		minwaterdepth = 20,
		movementclass = "UBOAT3",
		name = "Advanced Construction Sub",
		objectname = "CORACSUB",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "small_unit",
		sightdistance = 156,
		terraformspeed = 1500,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.3662,
		turnrate = 364,
		waterline = 30,
		workertime = 300,
		buildoptions = {
			[1] = "coruwadves",
			[2] = "coruwadvms",
			[3] = "coruwfus",
			[4] = "coruwmme",
			[5] = "coruwmmm",
			[6] = "corfatf",
			[7] = "corplat",
			[8] = "corsy",
			[9] = "corasy",
			[10] = "corgantuw",
			[11] = "csubpen",
			[12] = "corason",
			[13] = "corenaa",
			[14] = "coratl",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0.0 -1.62156426758 -7.49900054932",
				collisionvolumescales = "45.8502807617 11.0077514648 73.3929595947",
				collisionvolumetype = "Box",
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
                collisionvolumescales = "85.0 14.0 85.0",
                collisionvolumetype = "box",
				reclaimable = true,
				resurrectable = 0,
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
