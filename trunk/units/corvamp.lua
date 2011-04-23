return {
	corvamp = {
		acceleration = 0.49200001358986,
		airsightdistance = 600,
		brakerate = 8.75,
		buildcostenergy = 3448,
		buildcostmetal = 98,
		buildpic = "CORVAMP.DDS",
		buildtime = 6554,
		canattack = true,
		canfly = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		category = "ALL NOTLAND MOBILE WEAPON ANTIGATOR VTOL ANTIFLAME ANTIEMG ANTILASER NOTSUB NOTSHIP",
		collide = false,
		cruisealt = 160,
		description = "Stealth Fighter",
		energymake = 15,
		energyuse = 15,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 260,
		maxslope = 10,
		maxvelocity = 12.64999961853,
		maxwaterdepth = 0,
		name = "Vamp",
		nochasecategory = "NOTAIR",
		objectname = "CORVAMP",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 300,
		smoothanim = false,
		stealth = true,
		turnrate = 1337,
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
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "vtolcrac",
			},
		},
		weapondefs = {
			corvtol_advmissile = {
				areaofeffect = 8,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				firestarter = 70,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				metalpershot = 0,
				model = "missile",
				name = "GuidedMissiles",
				noselfdamage = true,
				range = 550,
				reloadtime = 0.5,
				smoketrail = true,
				soundhit = "xplosml2",
				soundstart = "Rocklit3",
				startvelocity = 650,
				texture2 = "coresmoketrail",
				tolerance = 8000,
				tracks = true,
				turnrate = 36000,
				weaponacceleration = 250,
				weapontimer = 7,
				weapontype = "MissileLauncher",
				weaponvelocity = 850,
				damage = {
					commanders = 5,
					default = 12,
					gunships = 120,
					hgunships = 120,
					l1bombers = 206,
					l1fighters = 116,
					l1subs = 3,
					l2bombers = 265,
					l2fighters = 86,
					l2subs = 3,
					l3subs = 3,
					vradar = 80,
					vtol = 80,
					vtrans = 80,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "CORVTOL_ADVMISSILE",
			},
			[2] = {
				def = "CORVTOL_ADVMISSILE",
			},
		},
	},
}
