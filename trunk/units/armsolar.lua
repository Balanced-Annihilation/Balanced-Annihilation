return {
	armsolar = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 4096,
		buildcostmetal = 155,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 8,
		buildinggrounddecalsizey = 8,
		buildinggrounddecaltype = "armsolar_aoplane.dds",
		buildpic = "ARMSOLAR.DDS",
		buildtime = 2845,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0.0 -18.0 1.0",
		collisionvolumescales = "50.0 76.0 50.0",
		collisionvolumetype = "Ell",
		corpse = "DEAD",
		damagemodifier = 0.5,
		description = "Produces Energy",
		energystorage = 50,
		energyuse = -20,
		explodeas = "SMALL_BUILDINGEX",
		footprintx = 5,
		footprintz = 5,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 306,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Solar Collector",
		objectname = "ARMSOLAR",
		onoffable = true,
		seismicsignature = 0,
		selfdestructas = "SMALL_BUILDING",
		sightdistance = 273,
		usebuildinggrounddecal = true,
		yardmap = "yyoyy yoooy ooooo yoooy yyoyy",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 -18 1",
				collisionvolumescales = "50 76 50",
				collisionvolumetype = "Ell",
				damage = 184,
				description = "Solar Collector Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 5,
				height = 20,
				hitdensity = 100,
				metal = 75,
				object = "ARMSOLAR_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 92,
				description = "Solar Collector Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 30,
				object = "5X5B",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			activate = "solar1",
			canceldestruct = "cancel2",
			deactivate = "solar1",
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
				[1] = "solar1",
			},
		},
	},
}
