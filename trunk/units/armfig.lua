return {
	armfig = {
		acceleration = 2.5,
		airsightdistance = 550,
		brakerate = 7.5,
		buildcostenergy = 2687,
		buildcostmetal = 68,
		buildpic = "ARMFIG.DDS",
		buildtime = 3465,
		canfly = true,
		canmove = true,
		category = "ALL MOBILE WEAPON ANTIGATOR NOTSUB ANTIFLAME ANTIEMG ANTILASER NOTLAND VTOL NOTSHIP",
		collide = false,
		cruisealt = 110,
		description = "Fighter",
		energymake = 0.69999998807907,
		energyuse = 0.69999998807907,
		explodeas = "SMALL_UNITEX",
		footprintx = 2,
		footprintz = 2,
		icontype = "air",
		idleautoheal = 1.5,
		idletime = 900,
		maxdamage = 50,
		maxslope = 10,
		maxvelocity = 9.6400003433228,
		maxwaterdepth = 255,
		name = "Freedom Fighter",
		nochasecategory = "NOTAIR",
		objectname = "ARMFIG",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		sightdistance = 275,
		turnrate = 891,
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
			armvtol_missile_a2a = {
				areaofeffect = 48,
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
				range = 530,
				reloadtime = 0.92400002479553,
				smoketrail = true,
				soundhit = "xplosml2",
				soundstart = "Rocklit3",
				startvelocity = 600,
				texture2 = "armsmoketrail",
				tolerance = 8000,
				tracks = true,
				turnrate = 24000,
				weaponacceleration = 150,
				weapontimer = 5,
				weapontype = "MissileLauncher",
				weaponvelocity = 750,
				damage = {
					commanders = 6,
					default = 27,
					hgunships = 80,
					l1bombers = 240,
					l1subs = 5,
					l2fighters = 50,
					vtol = 50,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "ARMVTOL_MISSILE_A2A",
			},
		},
	},
}
