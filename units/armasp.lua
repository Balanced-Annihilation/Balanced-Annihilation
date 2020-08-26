return {
	armasp = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 0,
		buildcostenergy = 4350,
		buildcostmetal = 399,
		builddistance = 136,
		builder = true,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 12,
		buildinggrounddecalsizey = 12,
		buildinggrounddecaltype = "armasp_aoplane.dds",
		buildpic = "ARMASP.DDS",
		buildtime = 9090,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -10 0",
		collisionvolumescales = "135 27 135",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Automatically Repairs Aircraft",
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 9,
		footprintz = 9,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		isairbase = true,
		mass = 200000,
		maxdamage = 1500,
		maxslope = 10,
		maxwaterdepth = 1,
		name = "Air Repair Pad",
		objectname = "ARMASP",
		onoffable = true,
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 357.5,
		terraformspeed = 5000,
		usebuildinggrounddecal = false,
		workertime = 1000,
		yardmap = "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 -8 0",
				collisionvolumescales = "135 24 135",
				collisionvolumetype = "Box",
				damage = 1116,
				description = "Air Repair Pad Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 40,
				hitdensity = 100,
				metal = 366,
				object = "ARMASP_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 558,
				description = "Air Repair Pad Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 1,
				footprintz = 1,
				height = 4,
				hitdensity = 100,
				metal = 126,
				object = "4X4A",
                collisionvolumescales = "85.0 14.0 85.0",
                collisionvolumetype = "box",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
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
				[1] = "pairactv",
			},
		},
	},
}
