return {
	cormart = {
		acceleration = 0.020400000736117,
		brakerate = 0.12319999933243,
		buildcostenergy = 3005,
		buildcostmetal = 263,
		buildpic = "CORMART.DDS",
		buildtime = 4270,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER",
		collisionvolumeoffsets = "0 -8 0",
		collisionvolumescales = "34 38 37",
		collisionvolumetest = 1,
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Mobile Artillery",
		energymake = 0.5,
		energyuse = 0.5,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 560,
		maxslope = 12,
		maxvelocity = 1.9500000476837,
		maxwaterdepth = 0,
		movementclass = "TANK3",
		name = "Pillager",
		nochasecategory = "NOTLAND VTOL",
		objectname = "CORMART",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 299,
		trackoffset = 8,
		trackstrength = 8,
		tracktype = "StdTank",
		trackwidth = 31,
		turnrate = 445,
		customparams = {
			canareaattack = 1,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-2.2791595459 -0.365720275879 -0.110244750977",
				collisionvolumescales = "41.4731445313 24.6765594482 38.8007202148",
				collisionvolumetype = "Box",
				damage = 336,
				description = "Pillager Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 138,
				object = "CORMART_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 168,
				description = "Pillager Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 55,
				object = "2X2B",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
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
				[1] = "tcormove",
			},
			select = {
				[1] = "tcorsel",
			},
		},
		weapondefs = {
			core_artillery = {
				accuracy = 960,
				areaofeffect = 129,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.5,
				explosiongenerator = "custom:FLASH4",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "PlasmaCannon",
				noselfdamage = true,
				range = 905,
				reloadtime = 3,
				soundhit = "xplomed4",
				soundstart = "cannhvy2",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 349.53540039063,
				damage = {
					bombers = 17,
					default = 190,
					fighters = 17,
					subs = 5,
					vtol = 17,
				},
			},
		},
		weapons = {
			[1] = {
				badTargetCategory = "NOTLAND",
				def = "CORE_ARTILLERY",
				maindir = "0 0 1",
				maxangledif = 90,
				onlyTargetCategory = "NOTAIR NOTSUB",
			},
		},
	},
}
