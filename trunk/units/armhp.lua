return {
	armhp = {
		acceleration = 0,
		brakerate = 0,
		buildcostenergy = 3957,
		buildcostmetal = 955,
		builder = true,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 9,
		buildinggrounddecalsizey = 8,
		buildinggrounddecaltype = "armhp_aoplane.dds",
		buildpic = "ARMHP.DDS",
		buildtime = 13890,
		canmove = true,
		category = "ALL NOTLAND PLANT NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER",
		collisionvolumescales = "118 28 106",
		collisionvolumetest = 1,
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Builds Hovercraft",
		energystorage = 200,
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 8,
		footprintz = 7,
		icontype = "building",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 3005,
		maxslope = 15,
		maxwaterdepth = 0,
		metalstorage = 200,
		name = "Hovercraft Platform",
		objectname = "ARMHP",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 286,
		terraformspeed = 1000,
		usebuildinggrounddecal = true,
		workertime = 200,
		yardmap = "occccccooccccccooccccccooccccccooccccccooccccccoocccccco",
		buildoptions = {
			[1] = "armch",
			[2] = "armsh",
			[3] = "armanac",
			[4] = "armah",
			[5] = "armmh",
			[6] = "armthovr",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 0 0",
				collisionvolumescales = "116 20 104",
				collisionvolumetest = 1,
				collisionvolumetype = "Box",
				damage = 1803,
				description = "Hovercraft Platform Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 8,
				footprintz = 7,
				height = 20,
				hitdensity = 100,
				metal = 621,
				object = "ARMHP_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 902,
				description = "Hovercraft Platform Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 8,
				footprintz = 7,
				height = 4,
				hitdensity = 100,
				metal = 248,
				object = "7X7A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			build = "hoverok1",
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
				[1] = "hoversl1",
			},
		},
	},
}
