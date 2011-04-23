return {
	cormort = {
		acceleration = 0.13199999928474,
		brakerate = 0.22499999403954,
		buildcostenergy = 2065,
		buildcostmetal = 382,
		builder = false,
		buildpic = "CORMORT.DDS",
		buildtime = 5139,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		category = "KBOT MOBILE WEAPON ALL NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Mobile Mortar Kbot",
		energymake = 1,
		energystorage = 0,
		energyuse = 1,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 850,
		maxslope = 14,
		maxvelocity = 2.1500000953674,
		maxwaterdepth = 12,
		metalstorage = 0,
		movementclass = "KBOT2",
		name = "Morty",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "CORMORT",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 300,
		smoothanim = true,
		turnrate = 1099,
		upright = true,
		workertime = 0,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 510,
				description = "Morty Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 118,
				object = "CORMORT_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 255,
				description = "Morty Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 47,
				object = "2X2A",
				reclaimable = true,
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
				[1] = "kbcormov",
			},
			select = {
				[1] = "kbcorsel",
			},
		},
		weapondefs = {
			core_mort = {
				areaofeffect = 36,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:CORE_FIRE_SMALL",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "PlasmaCannon",
				noselfdamage = true,
				range = 850,
				reloadtime = 1.6000000238419,
				soundhit = "xplomed3",
				soundstart = "cannon1",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 450,
				damage = {
					default = 105,
					gunships = 14,
					hgunships = 14,
					l1bombers = 14,
					l1fighters = 14,
					l1subs = 5,
					l2bombers = 14,
					l2fighters = 14,
					l2subs = 5,
					l3subs = 5,
					vradar = 14,
					vtol = 14,
					vtrans = 14,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORE_MORT",
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
