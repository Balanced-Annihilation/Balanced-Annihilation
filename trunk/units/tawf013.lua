return {
	tawf013 = {
		acceleration = 0.0154,
		brakerate = 0.0462,
		buildcostenergy = 2150,
		buildcostmetal = 135,
		buildpic = "TAWF013.DDS",
		buildtime = 2998,
		canmove = true,
		category = "ALL TANK WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 0 3",
		collisionvolumescales = "13 18 41",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Light Artillery Vehicle",
		energymake = 1,
		energyuse = 1,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		hightrajectory = 1,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 556,
		maxslope = 15,
		maxvelocity = 1.958,
		maxwaterdepth = 8,
		movementclass = "TANK3",
		name = "Shellshocker",
		nochasecategory = "VTOL",
		objectname = "TAWF013",
		pushresistant = true,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 364,
		trackoffset = 6,
		trackstrength = 5,
		tracktype = "StdTank",
		trackwidth = 30,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.29228,
		turnrate = 393.79999,
		customparams = {
			canareaattack = 1,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.0 3.10058593911e-07 3.44650268555",
				collisionvolumescales = "30.6000061035 17.1577606201 39.1929931641",
				collisionvolumetype = "Box",
				damage = 418,
				description = "Shellshocker Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 24,
				hitdensity = 100,
				metal = 92,
				object = "TAWF013_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 259,
				description = "Shellshocker Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 37,
				object = "3X3A",
                collisionvolumescales = "55.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
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
				[1] = "tarmmove",
			},
			select = {
				[1] = "tarmsel",
			},
		},
		weapondefs = {
			tawf113_weapon = {
				accuracy = 250,
				areaofeffect = 105,
				avoidfeature = false,
				craterareaofeffect = 105,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH4",
				gravityaffected = "true",
				hightrajectory = 1,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "LightArtillery",
				noselfdamage = true,
				range = 710,
				reloadtime = 3,
				soundhit = "TAWF113b",
				soundhitwet = "splsmed",
				soundhitwetvolume = 0.5,
				soundstart = "TAWF113a",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 370,
				damage = {
					bombers = 13,
					default = 130,
					fighters = 13,
					subs = 5,
					vtol = 13,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "TAWF113_WEAPON",
				maindir = "0 0 1",
				maxangledif = 180,
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
