return {
	armlance = {
		acceleration = 0.2,
		brakerate = 0.075,
		buildcostenergy = 7000,
		buildcostmetal = 330,
		buildpic = "ARMLANCE.DDS",
		buildtime = 15096,
		canfly = true,
		canmove = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTSUB VTOL NOTSHIP NOTHOVER",
		collide = true,
		cruisealt = 120,
		description = "Torpedo Bomber",
		energymake = 1.5,
		energyuse = 1.5,
		explodeas = "mediumExplosionGeneric",
		footprintx = 3,
		footprintz = 3,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxacc = 0.1325,
		maxaileron = 0.01384,
		maxbank = 0.8,
		maxdamage = 1727,
		maxelevator = 0.01009,
		maxpitch = 0.625,
		maxrudder = 0.00559,
		maxslope = 10,
		maxvelocity = 10.92,
		maxwaterdepth = 0,
		name = "Lancet",
		nochasecategory = "VTOL",
		objectname = "ARMLANCE",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd",
		sightdistance = 455,
		speedtofront = 0.06417,
		turnradius = 64,
		turnrate = 700,
		usesmoothmesh = true,
		wingangle = 0.06259,
		wingdrag = 0.185,
		customparams = {
			model_author = "FireStorm",
			subfolder = "armaircraft/t2",
			techlevel = 2,
		},
		sfxtypes = {
			crashexplosiongenerators = {
				[1] = "crashing-small",
				[2] = "crashing-small",
				[3] = "crashing-small2",
				[4] = "crashing-small3",
				[5] = "crashing-small3",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg3",
				[2] = "deathceg4",
				[3] = "deathceg2",
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
				[1] = "vtolarmv",
			},
			select = {
				[1] = "vtolarac",
			},
		},
		weapondefs = {
			armair_torpedo = {
				areaofeffect = 16,
				avoidfeature = false,
				avoidfriendly = false,
				burnblow = true,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:genericshellexplosion-large-uw",
				flighttime = 3,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "torpedo",
				name = "Light homing torpedo launcher",
				noselfdamage = true,
				range = 650,
				reloadtime = 8,
				soundhit = "xplodep2",
				soundstart = "bombrel",
				startvelocity = 0,
				tolerance = 2000,
				tracks = true,
				turnrate = 192000,
				turret = false,
				waterweapon = true,
				weaponacceleration = 35,
				weapontimer = 5,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 200,
				customparams = {},
				damage = {
					default = 1500,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTSHIP",
				def = "ARMAIR_TORPEDO",
				onlytargetcategory = "NOTHOVER",
			},
		},
	},
}
