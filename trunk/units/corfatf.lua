return {
	corfatf = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 16384,
		buildcostenergy = 7552,
		buildcostmetal = 799,
		buildpic = "CORFATF.DDS",
		buildtime = 10302,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -5 -3.5",
		collisionvolumescales = "60 30 60",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Enhanced Radar Targeting",
		energyuse = 150,
		explodeas = "largeBuildingExplosionGenericWhite",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		istargetingupgrade = true,
		maxdamage = 1375,
		maxslope = 10,
		minwaterdepth = 30,
		name = "Floating Targeting Facility",
		objectname = "CORFATF",
		onoffable = true,
		seismicsignature = 0,
		selfdestructas = "largeBuildingExplosionGenericWhite",
		sightdistance = 273,
		waterline = 3,
		yardmap = "wwwwwwwwwwwwwwww",
		customparams = {
			death_sounds = "generic",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-1.11164093018 -5.62302210693 3.14508056641",
				collisionvolumescales = "61.8861541748 21.1415557861 54.7463684082",
				collisionvolumetype = "Box",
				damage = 825,
				description = "Floating Targeting Facility Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 447,
				object = "CORFATF_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 413,
				description = "Floating Targeting Facility Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 179,
				object = "4X4D",
                collisionvolumescales = "85.0 14.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			activate = "targon2",
			canceldestruct = "cancel2",
			deactivate = "targoff2",
			underattack = "warning1",
			working = "targsel2",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "targsel2",
			},
		},
	},
}
