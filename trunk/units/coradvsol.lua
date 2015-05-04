return {
	coradvsol = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 4096,
		buildcostenergy = 3703,
		buildcostmetal = 348,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 6,
		buildinggrounddecalsizey = 6,
		buildinggrounddecaltype = "coradvsol_aoplane.dds",
		buildpic = "CORADVSOL.DDS",
		buildtime = 8143,
		category = "ALL NOTSUB NOWEAPON NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 0 -2",
		collisionvolumescales = "57 55 57",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		damagemodifier = 0.9,
		description = "Produces Energy",
		energymake = 75,
		energystorage = 100,
		explodeas = "SMALL_BUILDINGEX",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 1080,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Advanced Solar Collector",
		objectname = "CORADVSOL",
		seismicsignature = 0,
		selfdestructas = "SMALL_BUILDING",
		sightdistance = 260,
		usebuildinggrounddecal = true,
		yardmap = "oooooooooooooooo",
		customparams = {},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 -27 -1",
				collisionvolumescales = "60 112 58",
				collisionvolumetest = 1,
				collisionvolumetype = "Ell",
				damage = 648,
				description = "Advanced Solar Collector Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 12,
				hitdensity = 100,
				metal = 231,
				object = "CORADVSOL_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 324,
				description = "Advanced Solar Collector Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				hitdensity = 100,
				metal = 92,
				object = "4X4A",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
		},
		sounds = {
			activate = "solar2",
			canceldestruct = "cancel2",
			deactivate = "solar2",
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
				[1] = "solar2",
			},
		},
	},
}
