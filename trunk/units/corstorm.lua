return {
	corstorm = {
		acceleration = 0.10800000280142,
		brakerate = 0.1879999935627,
		buildcostenergy = 853,
		buildcostmetal = 81,
		builder = false,
		buildpic = "CORSTORM.DDS",
		buildtime = 1722,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		category = "KBOT MOBILE WEAPON ALL NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Rocket Kbot",
		energymake = 0.60000002384186,
		energystorage = 0,
		energyuse = 0.60000002384186,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 670,
		maxslope = 14,
		maxvelocity = 1.6499999761581,
		maxwaterdepth = 21,
		metalstorage = 0,
		movementclass = "KBOT2",
		name = "Storm",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "CORSTORM",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 344.5,
		smoothanim = true,
		turnrate = 1103,
		upright = true,
		workertime = 0,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 402,
				description = "Storm Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 55,
				object = "CORSTORM_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 201,
				description = "Storm Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 22,
				object = "2X2C",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:rocketflare",
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
			core_kbot_rocket = {
				areaofeffect = 48,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:VSMLMISSILE_EXPLOSION",
				firestarter = 70,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				metalpershot = 0,
				model = "missile",
				name = "Rockets",
				noselfdamage = true,
				range = 475,
				reloadtime = 3.7999999523163,
				smoketrail = true,
				soundhit = "xplosml2",
				soundstart = "rocklit1",
				startvelocity = 190,
				texture2 = "coresmoketrail",
				turret = true,
				weaponacceleration = 120,
				weapontimer = 2,
				weapontype = "MissileLauncher",
				weaponvelocity = 190,
				damage = {
					default = 157,
					l1subs = 5,
					l2subs = 5,
					l3subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORE_KBOT_ROCKET",
			},
		},
	},
}
