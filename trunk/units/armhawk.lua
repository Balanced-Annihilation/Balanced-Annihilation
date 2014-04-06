return {
	armhawk = {
		acceleration = 0.16,
		airsightdistance = 800,
		brakerate = 0.01125,
		buildcostenergy = 4593,
		buildcostmetal = 114,
		buildpic = "ARMHAWK.DDS",
		buildtime = 7685,
		canfly = true,
		canmove = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTSUB ANTIFLAME ANTIEMG ANTILASER VTOL NOTSHIP NOTHOVER",
		collide = false,
		cruisealt = 160,
		description = "Stealth Fighter",
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		icontype = "air",
		maxdamage = 335,
		maxslope = 10,
		maxvelocity = 11.960000038147,
		maxwaterdepth = 0,
		name = "Hawk",
		nochasecategory = "NOTAIR",
		objectname = "ARMHAWK",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT_AIR",
		sightdistance = 200,
		stealth = true,
		turnrate = 1425,
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
				[1] = "vtolarmv",
			},
			select = {
				[1] = "vtolarac",
			},
		},
		weapondefs = {
			armvtol_advmissile = {
				areaofeffect = 8,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				firestarter = 0,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				metalpershot = 0,
				model = "missile",
				name = "GuidedMissiles",
				noselfdamage = true,
				range = 562,
				reloadtime = 1.5,
				smoketrail = true,
				soundhit = "xplosml2",
				soundstart = "Rocklit3",
				startvelocity = 650,
				texture2 = "armsmoketrail",
				tolerance = 8000,
				tracks = true,
				turnrate = 36000,
				weaponacceleration = 250,
				weapontimer = 7,
				weapontype = "MissileLauncher",
				weaponvelocity = 850,
				damage = {
					bombers = 350,
					commanders = 5,
					default = 12,
					fighters = 400,
					subs = 5,
					vtol = 300,
				},
			},
		},
		weapons = {
			[1] = {
				badTargetCategory = "NOTAIR",
				def = "ARMVTOL_ADVMISSILE",
				onlyTargetCategory = "NOTSUB",
			},
			[2] = {
				badTargetCategory = "NOTAIR",
				def = "ARMVTOL_ADVMISSILE",
				onlyTargetCategory = "NOTSUB",
			},
		},
	},
}
