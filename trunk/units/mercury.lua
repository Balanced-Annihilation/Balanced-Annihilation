return {
	mercury = {
		acceleration = 0,
		airsightdistance = 1200,
		badtargetcategory = "NOTAIR",
		bmcode = 0,
		brakerate = 0,
		buildcostenergy = 32802,
		buildcostmetal = 1572,
		builder = false,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 6,
		buildinggrounddecalsizey = 6,
		buildinggrounddecaltype = "mercury_aoplane.dds",
		buildpic = "MERCURY.DDS",
		buildtime = 27190,
		canattack = true,
		canstop = 1,
		category = "ALL WEAPON NOTSUB SPECIAL NOTAIR",
		corpse = "DEAD",
		defaultmissiontype = "GUARD_NOMOVE",
		description = "Long-Range Missile Tower",
		energystorage = 0,
		energyuse = 0,
		explodeas = "BIG_UNITEX",
		firestandorders = 1,
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2250,
		maxslope = 20,
		maxvelocity = 0,
		maxwaterdepth = 0,
		metalstorage = 0,
		name = "Mercury",
		noautofire = false,
		objectname = "MERCURY",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		side = "ARM",
		sightdistance = 350,
		smoothanim = false,
		standingfireorder = 2,
		tedclass = "FORT",
		turnrate = 0,
		unitname = "mercury",
		usebuildinggrounddecal = true,
		workertime = 0,
		yardmap = "oooooooooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 900,
				description = "Mercury Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 1022,
				object = "MERCURY_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 450,
				description = "Mercury Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				hitdensity = 100,
				metal = 409,
				object = "3X3A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			activate = "targon1",
			canceldestruct = "cancel2",
			deactivate = "targoff1",
			underattack = "warning1",
			working = "targsel1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "targsel1",
			},
		},
		weapondefs = {
			arm_advsam = {
				areaofeffect = 300,
				avoidfriendly = false,
				canattackground = false,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0,
				explosiongenerator = "custom:FLASHSMALLBUILDINGEX",
				firestarter = 90,
				flighttime = 3,
				guidance = true,
				impulseboost = 0,
				impulsefactor = 0,
				lineofsight = true,
				model = "ADVSAM",
				name = "ADVSAM",
				noselfdamage = true,
				proximitypriority = -1.5,
				range = 2400,
				reloadtime = 18.75,
				rendertype = 1,
				selfprop = true,
				smokedelay = 0,
				smoketrail = true,
				soundhit = "impact",
				soundstart = "launch",
				startsmoke = 1,
				startvelocity = 1000,
				texture2 = "armsmoketrail",
				toairweapon = true,
				tolerance = 10000,
				tracks = true,
				trajectoryheight = 0.55000001192093,
				turnrate = 99000,
				turret = true,
				weaponacceleration = 300,
				weapontimer = 8,
				weapontype = "MissileLauncher",
				weaponvelocity = 1600,
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
					default = 1750,
					dl = 10,
					["else"] = 10,
					flakboats = 10,
					flaks = 10,
					flamethrowers = 10,
					gunships = 1750,
					heavyunits = 10,
					hgunships = 1750,
					jammerboats = 10,
					krogoth = 10,
					l1bombers = 1750,
					l1fighters = 1750,
					l1subs = 5,
					l2bombers = 1750,
					l2fighters = 1750,
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
					vradar = 1750,
					vtol = 1750,
					vtrans = 1750,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "ARM_ADVSAM",
			},
		},
	},
}
