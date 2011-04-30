return {
	corcut = {
		acceleration = 0.125,
		brakerate = 3.9379999637604,
		buildcostenergy = 5897,
		buildcostmetal = 220,
		buildpic = "CORCUT.DDS",
		buildtime = 11970,
		canfly = true,
		canmove = true,
		cansubmerge = true,
		category = "ALL MOBILE WEAPON ANTIGATOR VTOL ANTIFLAME ANTIEMG ANTILASER NOTLAND NOTSUB NOTSHIP",
		collide = false,
		cruisealt = 100,
		description = "Seaplane Gunship",
		energymake = 0.60000002384186,
		energyuse = 0.60000002384186,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 7.3499999046326,
		idletime = 900,
		maxdamage = 735,
		maxslope = 10,
		maxvelocity = 5.0799999237061,
		maxwaterdepth = 255,
		name = "Cutlass",
		nochasecategory = "VTOL",
		objectname = "CORCUT",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 595,
		turnrate = 828,
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
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
				[1] = "seapsel2",
			},
		},
		weapondefs = {
			vtol_rocket2 = {
				areaofeffect = 128,
				burnblow = true,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASHSMALLBUILDINGEX",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "RiotCannon",
				noselfdamage = true,
				range = 430,
				reloadtime = 1.2999999523163,
				soundhit = "xplosml3",
				soundstart = "canlite3",
				soundtrigger = true,
				turret = false,
				weapontype = "Cannon",
				weaponvelocity = 600,
				damage = {
					commanders = 53,
					default = 105,
					hgunships = 17,
					l1bombers = 17,
					l1subs = 5,
					l2fighters = 17,
					vtol = 17,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "VTOL_ROCKET2",
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
