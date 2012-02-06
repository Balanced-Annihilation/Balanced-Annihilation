return {
	armaas = {
		acceleration = 0.048000000417233,
		airsightdistance = 900,
		brakerate = 0.061999998986721,
		buildangle = 16384,
		buildcostenergy = 7058,
		buildcostmetal = 658,
		buildpic = "ARMAAS.DDS",
		buildtime = 8628,
		canmove = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTSUB SHIP NOTAIR NOTHOVER",
		collisionvolumeoffsets = "0 -7 0",
		collisionvolumescales = "32 34 82",
		collisionvolumetest = 1,
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Anti-Air Ship",
		energymake = 7,
		energyuse = 7,
		explodeas = "BIG_UNITEX",
		floater = true,
		footprintx = 3,
		footprintz = 3,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2360,
		maxvelocity = 2.8800001144409,
		minwaterdepth = 30,
		movementclass = "BOAT4",
		name = "Archer",
		nochasecategory = "ALL",
		objectname = "ARMAAS",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 475,
		turninplace = 0,
		turnrate = 416,
		waterline = 4,
		windgenerator = 0.0010000000474975,
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "-1.40724182129 -7.7758789061e-06 -0.172019958496",
				collisionvolumescales = "36.1561584473 29.9421844482 83.5312347412",
				collisionvolumetype = "Box",
				damage = 4160,
				description = "Archer Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 325,
				object = "ARMAAS_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 2016,
				description = "Archer Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 164,
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
				[1] = "sharmmov",
			},
			select = {
				[1] = "sharmsel",
			},
		},
		weapondefs = {
			bogus_missile = {
				areaofeffect = 48,
				canattackground = false,
				craterboost = 0,
				cratermult = 0,
				impulseboost = 0,
				impulsefactor = 0,
				metalpershot = 0,
				name = "Missiles",
				range = 800,
				reloadtime = 0.5,
				startvelocity = 450,
				toairweapon = true,
				tolerance = 9000,
				turnrate = 33000,
				turret = true,
				weaponacceleration = 101,
				weapontimer = 0.10000000149012,
				weapontype = "Cannon",
				weaponvelocity = 650,
				damage = {
					default = 0,
				},
			},
			ga2 = {
				areaofeffect = 64,
				burst = 2,
				burstrate = 0.40000000596046,
				canattackground = false,
				craterboost = 0,
				cratermult = 0,
				energypershot = 0,
				explosiongenerator = "custom:FLASH2",
				firestarter = 72,
				flighttime = 3,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				metalpershot = 0,
				model = "missile",
				name = "AA2Missile",
				noselfdamage = true,
				range = 840,
				reloadtime = 0.80000001192093,
				smoketrail = true,
				soundhit = "packohit",
				soundstart = "packolau",
				soundtrigger = true,
				startvelocity = 520,
				toairweapon = true,
				tolerance = 9950,
				tracks = true,
				turnrate = 68000,
				turret = true,
				weaponacceleration = 160,
				weapontimer = 5,
				weapontype = "MissileLauncher",
				weaponvelocity = 820,
				damage = {
					default = 63,
					subs = 5,
				},
			},
			mobileflak = {
				accuracy = 1000,
				areaofeffect = 140,
				burnblow = true,
				canattackground = false,
				color = 1,
				craterboost = 0,
				cratermult = 0,
				cylindertargetting = 1,
				edgeeffectiveness = 0.85000002384186,
				explosiongenerator = "custom:FLASH3",
				gravityaffected = "true",
				impulseboost = 0,
				impulsefactor = 0,
				name = "FlakCannon",
				noselfdamage = true,
				range = 775,
				reloadtime = 0.75,
				soundhit = "flakhit",
				soundstart = "flakfire",
				toairweapon = true,
				turret = true,
				weapontimer = 1,
				weapontype = "Cannon",
				weaponvelocity = 1550,
				damage = {
					["else"] = 10,
					bombers = 200,
					commanders = 10,
					crawlingbombs = 10,
					default = 850,
					fighters = 400,
					heavyunits = 10,
					mines = 10,
					nanos = 10,
					subs = 5,
					vtol = 200,
				},
			},
		},
		weapons = {
			[1] = {
				def = "BOGUS_MISSILE",
				onlytargetcategory = "VTOL",
			},
			[2] = {
				def = "GA2",
				onlytargetcategory = "VTOL",
			},
			[3] = {
				def = "MOBILEFLAK",
				onlytargetcategory = "VTOL",
			},
		},
	},
}
