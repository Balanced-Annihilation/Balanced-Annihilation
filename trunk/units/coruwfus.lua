return {
	coruwfus = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 35879,
		buildcostmetal = 4568,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 8,
		buildinggrounddecalsizey = 8,
		buildinggrounddecaltype = "coruwfus_aoplane.dds",
		buildpic = "CORUWFUS.DDS",
		buildtime = 99870,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER",
		corpse = "DEAD",
		description = "Produces Energy / Storage",
		energymake = 1220,
		energystorage = 2500,
		explodeas = "ATOMIC_BLAST",
		footprintx = 5,
		footprintz = 5,
		icontype = "building",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 5350,
		maxslope = 16,
		minwaterdepth = 25,
		name = "Underwater Fusion Plant",
		objectname = "CORUWFUS",
		seismicsignature = 0,
		selfdestructas = "MINE_NUKE",
		sightdistance = 143,
		usebuildinggrounddecal = true,
		yardmap = "ooooooooooooooooooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "89.9762878418 27.3368988037 72.5986480713",
				collisionvolumeoffsets = "1.8653717041 -0.0807505981445 0.994560241699",
				category = "corpses",
				damage = 3210,
				description = "Underwater Fusion Plant Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 5,
				footprintz = 5,
				height = 20,
				hitdensity = 100,
				metal = 3099,
				object = "CORUWFUS_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1605,
				description = "Underwater Fusion Plant Heap",
				energy = 0,
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 1240,
				object = "5X5A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "watfusn2",
			},
		},
	},
}
