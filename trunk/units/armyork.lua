return {
	armyork = {
		acceleration = 0.039599999785423,
		airsightdistance = 900,
		brakerate = 0.12649999558926,
		buildcostenergy = 8510,
		buildcostmetal = 425,
		buildpic = "ARMYORK.DDS",
		buildtime = 9964,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Anti-Air Flak Vehicle",
		energymake = 0.5,
		energyuse = 0.5,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 2350,
		maxslope = 16,
		maxvelocity = 2.4816000461578,
		maxwaterdepth = 12,
		movementclass = "TANK3",
		name = "Phalanx",
		nochasecategory = "ALL",
		objectname = "ARMYORK",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 390,
		trackoffset = 6,
		trackstrength = 5,
		tracktype = "StdTank",
		trackwidth = 27,
		turnrate = 618.20001220703,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 1146,
				description = "Phalanx Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 276,
				object = "ARMYORK_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 573,
				description = "Phalanx Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 110,
				object = "2X2A",
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
				[1] = "varmmove",
			},
			select = {
				[1] = "varmsel",
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
					amphibious = 10,
					anniddm = 10,
					antibomber = 10,
					antifighter = 10,
					antiraider = 10,
					atl = 10,
					blackhydra = 10,
					commanders = 10,
					crawlingbombs = 10,
					default = 850,
					dl = 10,
					["else"] = 10,
					flakboats = 10,
					flaks = 10,
					flamethrowers = 10,
					gunships = 150,
					heavyunits = 10,
					hgunships = 75,
					jammerboats = 10,
					krogoth = 10,
					l1bombers = 200,
					l1fighters = 400,
					l1subs = 5,
					l2bombers = 200,
					l2fighters = 400,
					l2subs = 5,
					l3subs = 5,
					mechs = 10,
					mines = 10,
					nanos = 10,
					otherboats = 10,
					plasmaguns = 10,
					radar = 10,
					seadragon = 10,
					spies = 10,
					tl = 10,
					vradar = 200,
					vtol = 200,
					vtrans = 150,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "BOGUS_MISSILE",
			},
			[3] = {
				def = "MOBILEFLAK",
			},
		},
	},
}
