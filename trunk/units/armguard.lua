return {
	armguard = {
		acceleration = 0,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 11687,
		buildcostmetal = 1645,
		builder = false,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 5,
		buildinggrounddecalsizey = 5,
		buildinggrounddecaltype = "armguard_aoplane.dds",
		buildpic = "ARMGUARD.DDS",
		buildtime = 21377,
		canattack = true,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR",
		collisionvolumeoffsets = "0 -17 0",
		collisionvolumescales = "50 68 50",
		collisionvolumetest = 1,
		collisionvolumetype = "Ell",
		corpse = "DEAD",
		description = "Medium Range Plasma Battery",
		energystorage = 0,
		energyuse = 0,
		explodeas = "MEDIUM_BUILDINGEX",
		footprintx = 3,
		footprintz = 3,
		hightrajectory = 2,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2760,
		maxslope = 10,
		maxvelocity = 0,
		maxwaterdepth = 0,
		metalstorage = 0,
		name = "Guardian",
		noautofire = false,
		nochasecategory = "MOBILE",
		objectname = "ARMGUARD",
		seismicsignature = 0,
		selfdestructas = "MEDIUM_BUILDING",
		sightdistance = 455,
		smoothanim = false,
		turnrate = 0,
		usebuildinggrounddecal = true,
		workertime = 0,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 1656,
				description = "Guardian Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 40,
				hitdensity = 100,
				metal = 1069,
				object = "ARMGUARD_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 828,
				description = "Guardian Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 428,
				object = "3X3D",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			armfixed_gun = {
				accuracy = 75,
				areaofeffect = 128,
				ballistic = true,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.25,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.5,
				name = "PlasmaCannon",
				noselfdamage = true,
				range = 1220,
				reloadtime = 2.9249999523163,
				rendertype = 4,
				soundhit = "xplomed2",
				soundstart = "cannhvy5",
				startsmoke = 1,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 450,
				damage = {
					blackhydra = 526,
					commanders = 526,
					default = 263,
					flakboats = 526,
					gunships = 90,
					hgunships = 90,
					jammerboats = 526,
					l1bombers = 90,
					l1fighters = 90,
					l1subs = 5,
					l2bombers = 90,
					l2fighters = 90,
					l2subs = 5,
					l3subs = 5,
					otherboats = 526,
					seadragon = 526,
					vradar = 90,
					vtol = 90,
					vtrans = 90,
				},
			},
			armfixed_gun_high = {
				accuracy = 75,
				areaofeffect = 192,
				ballistic = true,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.5,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 1.3999999761581,
				name = "PlasmaCannon",
				noselfdamage = true,
				proximitypriority = -2,
				range = 1220,
				reloadtime = 7,
				rendertype = 4,
				soundhit = "xplomed2",
				soundstart = "cannhvy5",
				startsmoke = 1,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 440,
				damage = {
					blackhydra = 922,
					commanders = 922,
					default = 553,
					flakboats = 922,
					gunships = 90,
					hgunships = 90,
					jammerboats = 922,
					l1bombers = 90,
					l1fighters = 90,
					l1subs = 5,
					l2bombers = 90,
					l2fighters = 90,
					l2subs = 5,
					l3subs = 5,
					otherboats = 922,
					seadragon = 922,
					vradar = 90,
					vtol = 90,
					vtrans = 90,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARMFIXED_GUN",
				maindir = "0 1 0",
				maxangledif = 230,
				onlytargetcategory = "NOTAIR",
			},
			[2] = {
				def = "ARMFIXED_GUN_HIGH",
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
