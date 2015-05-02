
return {
	armbull = {
		acceleration = 0.0396,
		brakerate = 0.165,
		buildcostenergy = 12405,
		buildcostmetal = 844,
		buildpic = "ARMBULL.DDS",
		buildtime = 17228,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionVolumeOffsets = "0 0 2",
		collisionVolumeScales = "43 23 43",
		collisionVolumeTest = 1,
		collisionVolumeType = "CylY",
		corpse = "DEAD",
		description = "Heavy Assault Tank",
		energymake = 0.8,
		energyuse = 0.8,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 4200,
		maxslope = 12,
		maxvelocity = 2.44,
		maxwaterdepth = 15,
		movementclass = "HTANK3",
		name = "Bulldog",
		nochasecategory = "VTOL",
		objectname = "ARMBULL",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 494,
		trackoffset = 8,
		trackstrength = 10,
		tracktype = "StdTank",
		trackwidth = 40,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.6104,
		turnrate = 415,
		customparams = {},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.291641235352 0.00484669189453 0.383178710938",
				collisionvolumescales = "43.0491943359 23.8300933838 46.0147399902",
				collisionvolumetype = "Box",
				damage = 2520,
				description = "Bulldog Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 549,
				object = "ARMBULL_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1260,
				description = "Bulldog Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 220,
				object = "3X3F",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:MEDIUMFLARE",
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
				[1] = "tarmmove",
			},
			select = {
				[1] = "tarmsel",
			},
		},
		weapondefs = {
			arm_bull = {
				areaofeffect = 140,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH72",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "PlasmaCannon",
				noselfdamage = true,
				range = 460,
				reloadtime = 1.12,
				soundhit = "xplomed2",
				soundstart = "cannon3",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 300,
				damage = {
					bombers = 30,
					default = 270,
					fighters = 30,
					subs = 5,
					vtol = 30,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARM_BULL",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
