return {
	coralab = {
		acceleration = 0,
		brakerate = 0,
		buildangle = 1024,
		buildcostenergy = 15232,
		buildcostmetal = 2681,
		builder = true,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 8,
		buildinggrounddecalsizey = 7,
		buildinggrounddecaltype = "coralab_aoplane.dds",
		buildpic = "CORALAB.DDS",
		buildtime = 16819,
		canmove = true,
		canpatrol = true,
		category = "ALL PLANT NOTLAND NOWEAPON NOTSUB NOTSHIP NOTAIR",
		collisionvolumeoffsets = "0 -16 0",
		collisionvolumescales = "100 34 90",
		collisionvolumetest = 1,
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Produces Level 2 Kbots",
		energystorage = 200,
		energyuse = 0,
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 7,
		footprintz = 6,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 4072,
		maxslope = 15,
		maxvelocity = 0,
		maxwaterdepth = 0,
		metalstorage = 200,
		name = "Advanced Kbot Lab",
		noautofire = false,
		objectname = "CORALAB",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 288.60000610352,
		smoothanim = false,
		turnrate = 0,
		usebuildinggrounddecal = true,
		workertime = 200,
		yardmap = "ooooooooooooooocccccoccccccccccccccccccccc",
		buildoptions = {
			[1] = "corack",
			[2] = "corfast",
			[3] = "corpyro",
			[4] = "coramph",
			[5] = "corcan",
			[6] = "corsumo",
			[7] = "cortermite",
			[8] = "cormort",
			[9] = "corhrk",
			[10] = "coraak",
			[11] = "corroach",
			[12] = "corsktl",
			[13] = "cordecom",
			[14] = "commando",
			[15] = "corvoyr",
			[16] = "corspy",
			[17] = "corspec",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 2443,
				description = "Advanced Kbot Lab Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 6,
				height = 20,
				hitdensity = 100,
				metal = 1743,
				object = "CORALAB_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1222,
				description = "Advanced Kbot Lab Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 872,
				object = "5X5A",
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
				[1] = "plabactv",
			},
		},
	},
}
