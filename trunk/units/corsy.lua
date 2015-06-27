return {
	corsy = {
		acceleration = 0,
		brakerate = 0,
		buildcostenergy = 800,
		buildcostmetal = 443,
		builder = true,
		buildpic = "CORSY.DDS",
		buildtime = 6000,
		canmove = true,
		category = "ALL PLANT NOTSUB NOWEAPON NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -10 0",
		collisionvolumescales = "124 56 128",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Produces Level 1 Ships",
		energymake = 15,
		energystorage = 100,
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 8,
		footprintz = 8,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 3850,
		metalmake = 0.5,
		metalstorage = 100,
		minwaterdepth = 30,
		name = "Shipyard",
		objectname = "CORSY",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 340,
		terraformspeed = 500,
		waterline = 33,
		workertime = 220,
		yardmap = "oyyyyyyoyccccccyyccccccyyccccccyyccccccyyccccccyyccccccyoyyyyyyo",
		buildoptions = {
			[1] = "corcs",
			[2] = "corpt",
			[3] = "coresupp",
			[4] = "corroy",
			[5] = "cortship",
			[6] = "corsub",
			[7] = "correcl",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0 -10 -4",
				collisionvolumescales = "116 56 120",
				collisionvolumetest = 1,
				collisionvolumetype = "Box",
				damage = 1794,
				description = "Shipyard Wreckage",
				energy = 0,
				footprintx = 7,
				footprintz = 7,
				height = 4,
				hitdensity = 100,
				metal = 390,
				object = "CORSY_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:WhiteLight",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			unitcomplete = "untdone",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "pshpactv",
			},
		},
	},
}
