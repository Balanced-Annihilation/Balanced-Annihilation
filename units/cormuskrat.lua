return {
	cormuskrat = {
		acceleration = 0.06,
		brakerate = 0.6996,
		buildcostenergy = 3430,
		buildcostmetal = 172,
		builddistance = 112,
		builder = true,
		buildpic = "CORMUSKRAT.DDS",
		buildtime = 6864,
		canmove = true,
		category = "ALL TANK PHIB NOTSUB CONSTR NOWEAPON NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -1 5",
		collisionvolumescales = "22 16 41",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Amphibious Construction Vehicle",
		energymake = 8,
		energyuse = 8,
		explodeas = "mediumExplosionGenericGreen",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 995,
		maxslope = 16,
		maxvelocity = 1.44,
		maxwaterdepth = 255,
		metalmake = 0.08,
		metalstorage = 50,
		movementclass = "ATANK3",
		name = "Muskrat",
		objectname = "CORMUSKRAT",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericGreen",
		sightdistance = 260,
		terraformspeed = 400,
		trackoffset = 8,
		trackstrength = 5,
		tracktype = "StdTank",
		trackwidth = 24,
		turninplace = 1,
		turninplaceanglelimit = 60,
		turninplacespeedlimit = 0.9504,
		turnrate = 300,
		workertime = 80,
		buildoptions = {
			[1] = "corsolar",
			[2] = "coradvsol",
			[3] = "corwin",
			[4] = "corgeo",
			[5] = "cormstor",
			[6] = "corestor",
			[7] = "cormex",
			[8] = "corexp",
			[9] = "cormakr",
			[10] = "corlab",
			[11] = "corvp",
			[12] = "corap",
			[13] = "corhp",
			[14] = "cornanotc",
			[15] = "coreyes",
			[16] = "corrad",
			[17] = "cordrag",
			[18] = "cormaw",
			[19] = "corllt",
			[20] = "hllt",
			[21] = "corhlt",
			[22] = "corpun",
			[23] = "corrl",
			[24] = "madsam",
			[25] = "corerad",
			[26] = "cordl",
			[27] = "corjamt",
			[28] = "cjuno",
			[29] = "csubpen",
			[30] = "corsy",
			[31] = "cortide",
			[32] = "coruwmex",
			[33] = "corfmkr",
			[34] = "coruwms",
			[35] = "coruwes",
			[36] = "csubpen",
			[37] = "corsonar",
			[38] = "corfdrag",
			[39] = "corfrad",
			[40] = "corfhlt",
			[41] = "corfrt",
			[42] = "corptl",
		},
		customparams = {
			death_sounds = "generic",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-1.3500289917 4.80712890649e-06 3.49253082275",
				collisionvolumescales = "25.27003479 12.0197296143 44.3021697998",
				collisionvolumetype = "Box",
				damage = 697,
				description = "Muskrat Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 105,
				object = "CORMUSKRAT_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 299,
				description = "Muskrat Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 42,
				object = "3X3C",
                collisionvolumescales = "55.0 4.0 6.0",
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
			build = "nanlath2",
			canceldestruct = "cancel2",
			capture = "capture1",
			repair = "repair2",
			underattack = "warning1",
			working = "reclaim1",
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
				[1] = "vcormove",
			},
			select = {
				[1] = "vcorsel",
			},
		},
	},
}