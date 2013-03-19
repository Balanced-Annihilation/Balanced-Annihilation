return {
	armsptk = {
		acceleration = 0.18000000715256,
		brakerate = 0.1879999935627,
		buildcostenergy = 4200,
		buildcostmetal = 375,
		buildpic = "ARMSPTK.DDS",
		buildtime = 8775,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -2 0",
		collisionvolumescales = "42 28 42",
		collisionvolumetest = 1,
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "All-Terrain Rocket Spider",
		energymake = 0.69999998807907,
		energyuse = 0.69999998807907,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 600,
		maxdamage = 1050,
		maxvelocity = 1.7200000286102,
		maxwaterdepth = 12,
		movementclass = "TKBOT3",
		name = "Recluse",
		nochasecategory = "VTOL",
		objectname = "ARMSPTK",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 440,
		turnrate = 1122,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.13973236084 -4.67773437585e-06 -1.37111663818",
				collisionvolumescales = "47.3038787842 18.2459106445 47.0814971924",
				collisionvolumetype = "Box",
				damage = 630,
				description = "Recluse Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 40,
				hitdensity = 100,
				metal = 244,
				object = "ARMSPTK_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 315,
				description = "Recluse Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 98,
				object = "3X3A",
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
				[1] = "spider2",
			},
			select = {
				[1] = "spider3",
			},
		},
		weapondefs = {
			adv_rocket = {
				areaofeffect = 72,
				burst = 3,
				burstrate = 0.30000001192093,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.5,
				explosiongenerator = "custom:FLASH2",
				firestarter = 70,
				flighttime = 2,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				model = "shipmissile",
				name = "HeavyRocket",
				noselfdamage = true,
				range = 550,
				reloadtime = 3,
				smoketrail = true,
				soundhit = "xplosml1",
				soundstart = "rockhvy3",
				soundtrigger = true,
				startvelocity = 120,
				targetmoveerror = 0.20000000298023,
				texture2 = "armsmoketrail",
				trajectoryheight = 1,
				turnrate = 2000,
				turret = true,
				weaponacceleration = 80,
				weapontimer = 6,
				weapontype = "MissileLauncher",
				weaponvelocity = 395,
				wobble = 5400,
				damage = {
					default = 120,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ADV_ROCKET",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
