return {
	armrad = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 600,
		buildcostmetal = 54,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 4,
		buildinggrounddecalsizey = 4,
		buildinggrounddecaltype = "armrad_aoplane.dds",
		buildpic = "ARMRAD.DDS",
		buildtime = 1137,
		canattack = false,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "30 73 30",
		collisionvolumetest = 1,
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Early Warning System",
		energymake = 4,
		energyuse = 4,
		explodeas = "SMALL_BUILDINGEX",
		footprintx = 2,
		footprintz = 2,
		icontype = "building",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 81,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Radar Tower",
		objectname = "ARMRAD",
		onoffable = true,
		radardistance = 2100,
		seismicsignature = 0,
		selfdestructas = "SMALL_BUILDING",
		sightdistance = 680,
		usebuildinggrounddecal = true,
		yardmap = "oooo",
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "46.8276062012 74.2716674805 38.2336730957",
				collisionvolumeoffsets = "-1.52809143066 -0.0377662597656 8.02375793457",
				category = "corpses",
				damage = 49,
				description = "Radar Tower Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 35,
				object = "ARMRAD_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 25,
				description = "Radar Tower Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 14,
				object = "2X2A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			activate = "radar1",
			canceldestruct = "cancel2",
			deactivate = "radarde1",
			underattack = "warning1",
			working = "radar1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "radar1",
			},
		},
	},
}
