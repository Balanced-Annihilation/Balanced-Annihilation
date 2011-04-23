return {
	armwar = {
		acceleration = 0.071999996900558,
		badtargetcategory = "VTOL",
		bmcode = 1,
		brakerate = 0.23800000548363,
		buildcostenergy = 2944,
		buildcostmetal = 248,
		builder = false,
		buildpic = "ARMWAR.DDS",
		buildtime = 3828,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		canstop = 1,
		category = "KBOT MOBILE WEAPON ALL ANTIGATOR NOTSUB ANTIEMG NOTSHIP NOTAIR",
		corpse = "DEAD",
		defaultmissiontype = "Standby",
		description = "Medium Infantry Kbot",
		energymake = 0.5,
		energystorage = 0,
		energyuse = 0.5,
		explodeas = "SMALL_UNITEX",
		firestandorders = 1,
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		maneuverleashlength = 640,
		maxdamage = 1300,
		maxslope = 17,
		maxvelocity = 1.5,
		maxwaterdepth = 12,
		metalstorage = 0,
		mobilestandorders = 1,
		movementclass = "KBOT2",
		name = "Warrior",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "ARMWAR",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		side = "ARM",
		sightdistance = 350,
		smoothanim = true,
		standingfireorder = 2,
		standingmoveorder = 1,
		steeringmode = 2,
		tedclass = "KBOT",
		turnrate = 770,
		unitname = "armwar",
		upright = true,
		workertime = 0,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 780,
				description = "Warrior Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 161,
				object = "ARMWAR_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 390,
				description = "Warrior Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 64,
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
				[1] = "kbarmmov",
			},
			select = {
				[1] = "kbarmsel",
			},
		},
		weapondefs = {
			armwar_laser = {
				areaofeffect = 8,
				beamlaser = 1,
				beamtime = 0.11999999731779,
				corethickness = 0.17499999701977,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:SMALL_RED_BURN",
				firestarter = 30,
				impactonly = 1,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				laserflaresize = 10,
				lineofsight = true,
				name = "MediumLaser",
				noselfdamage = true,
				range = 330,
				reloadtime = 0.30000001192093,
				rendertype = 0,
				rgbcolor = "1 0 0",
				soundhit = "lasrhit2",
				soundstart = "lasrfir3",
				soundtrigger = true,
				targetmoveerror = 0.20000000298023,
				thickness = 2,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 950,
				damage = {
					default = 55,
					gunships = 9,
					hgunships = 9,
					l1bombers = 9,
					l1fighters = 9,
					l1subs = 5,
					l2bombers = 9,
					l2fighters = 9,
					l2subs = 5,
					l3subs = 5,
					vradar = 9,
					vtol = 9,
					vtrans = 9,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARMWAR_LASER",
			},
		},
	},
}
