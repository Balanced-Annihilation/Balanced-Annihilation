return {
	armjamt = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 4382,
		buildcostenergy = 7945,
		buildcostmetal = 226,
		buildpic = "ARMJAMT.DDS",
		buildtime = 9955,
		canattack = false,
		category = "ALL NOTSUB NOWEAPON SPECIAL NOTAIR NOTHOVER",
		cloakcost = 25,
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "32 82 32",
		collisionvolumetest = 1,
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Cloakable Jammer Tower",
		energyuse = 40,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		icontype = "building",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 712,
		maxslope = 32,
		maxwaterdepth = 0,
		mincloakdistance = 35,
		name = "Sneaky Pete",
		objectname = "ARMJAMT",
		onoffable = true,
		radardistancejam = 500,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 195,
		yardmap = "oooo",
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "28.2096405029 67.270401001 28.2096252441",
				collisionvolumeoffsets = "-7.62939453125e-06 -2.49999949951 -0.0",
				category = "corpses",
				damage = 427,
				description = "Sneaky Pete Wreckage",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 3,
				hitdensity = 100,
				metal = 147,
				object = "ARMJAMT_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
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
				[1] = "kbarmmov",
			},
			select = {
				[1] = "radjam1",
			},
		},
	},
}
