return {
	armbats = {
		acceleration = 0.036,
		brakerate = 0.093,
		buildangle = 16384,
		buildcostenergy = 20731,
		buildcostmetal = 5181,
		buildpic = "ARMBATS.DDS",
		buildtime = 58730,
		canmove = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTSUB SHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "-1 -10 4",
		collisionvolumescales = "67 67 138",
		collisionvolumetest = 1,
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Battleship",
		energymake = 100,
		energyuse = 48,
		explodeas = "BIG_UNITEX",
		floater = true,
		footprintx = 6,
		footprintz = 6,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 15810,
		maxvelocity = 2.88,
		minwaterdepth = 15,
		movementclass = "DBOAT6",
		name = "Millennium",
		nochasecategory = "VTOL",
		objectname = "ARMBATS",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 455,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.9008,
		turnrate = 310,
		waterline = 12,
		windgenerator = 0.001,
		customparams = {},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "-16.0281448364 -3.59007536621 -2.5637588501",
				collisionvolumescales = "74.9459686279 67.6992492676 151.322341919",
				collisionvolumetype = "Box",
				damage = 6486,
				description = "Millennium Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 6,
				footprintz = 6,
				height = 4,
				hitdensity = 100,
				metal = 3368,
				object = "ARMBATS_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 2016,
				description = "Millennium Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 1066,
				object = "6X6D",
				reclaimable = true,
				resurrectable = 0,
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
			arm_bats = {
				accuracy = 350,
				areaofeffect = 96,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "BattleshipCannon",
				noselfdamage = true,
				range = 1240,
				reloadtime = 0.4,
				soundhit = "xplomed2",
				soundstart = "cannhvy1",
				tolerance = 5000,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 470,
				damage = {
					bombers = 65,
					default = 300,
					fighters = 65,
					subs = 5,
					vtol = 65,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARM_BATS",
				maindir = "0 0 1",
				maxangledif = 330,
				onlytargetcategory = "SURFACE",
			},
			[2] = {
				def = "ARM_BATS",
				maindir = "0 0 1",
				maxangledif = 270,
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
