return {
	corgator = {
		acceleration = 0.054999999701977,
		bmcode = 1,
		brakerate = 0.054999999701977,
		buildcostenergy = 1042,
		buildcostmetal = 118,
		builder = false,
		buildpic = "CORGATOR.DDS",
		buildtime = 1761,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		canstop = 1,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		defaultmissiontype = "Standby",
		description = "Light Tank",
		energymake = 0.5,
		energystorage = 0,
		energyuse = 0.5,
		explodeas = "BIG_UNITEX",
		firestandorders = 1,
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maneuverleashlength = 640,
		maxdamage = 693,
		maxslope = 10,
		maxvelocity = 3,
		maxwaterdepth = 12,
		metalstorage = 0,
		mobilestandorders = 1,
		movementclass = "TANK2",
		name = "Instigator",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "CORGATOR",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		side = "CORE",
		sightdistance = 273,
		smoothanim = false,
		standingfireorder = 2,
		standingmoveorder = 1,
		steeringmode = 1,
		tedclass = "TANK",
		trackoffset = 5,
		trackstrength = 5,
		trackstretch = 1,
		tracktype = "StdTank",
		trackwidth = 21,
		turnrate = 484,
		unitname = "corgator",
		workertime = 0,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 450,
				description = "Instigator Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 77,
				object = "CORGATOR_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 225,
				description = "Instigator Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 31,
				object = "2X2F",
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
			gator_laserx = {
				areaofeffect = 8,
				beamlaser = 1,
				beamtime = 0.10000000149012,
				corethickness = 0.17499999701977,
				craterboost = 0,
				cratermult = 0,
				energypershot = 0,
				explosiongenerator = "custom:SMALL_RED_BURN",
				firestarter = 50,
				impactonly = 1,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				laserflaresize = 6,
				lineofsight = true,
				name = "Laser",
				noselfdamage = true,
				range = 230,
				reloadtime = 0.76999998092651,
				rendertype = 0,
				rgbcolor = "1 0 0",
				soundhit = "lasrhit2",
				soundstart = "lasrlit3",
				soundtrigger = true,
				targetmoveerror = 0.15000000596046,
				thickness = 2.5,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 1000,
				damage = {
					default = 75,
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
					vtrans = 12,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "GATOR_LASERX",
			},
		},
	},
}
