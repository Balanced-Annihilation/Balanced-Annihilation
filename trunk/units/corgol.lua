return {
	corgol = {
		acceleration = 0.0242,
		brakerate = 0.1485,
		buildcostenergy = 21218,
		buildcostmetal = 1671,
		buildpic = "CORGOL.DDS",
		buildtime = 26125,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 -10 -1",
		collisionvolumescales = "50 50 50",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Very Heavy Assault Tank",
		energymake = 0.5,
		energyuse = 0.5,
		explodeas = "BIG_UNITEX",
		footprintx = 4,
		footprintz = 4,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		mass = 5001,
		maxdamage = 7000,
		maxslope = 12,
		maxvelocity = 1.45,
		maxwaterdepth = 12,
		movementclass = "HTANK4",
		name = "Goliath",
		nochasecategory = "VTOL",
		objectname = "CORGOL",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 395,
		trackoffset = 8,
		trackstrength = 10,
		tracktype = "StdTank",
		trackwidth = 49,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 0.957,
		turnrate = 220,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 0 0",
				collisionvolumescales = "60 16 60",
				collisionvolumetest = 1,
				collisionvolumetype = "Box",
				damage = 4500,
				description = "Goliath Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 894,
				object = "CORGOL_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 3000,
				description = "Goliath Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 378,
				object = "4X4C",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:goliathflare",
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
			cor_gol = {
				areaofeffect = 292,
				avoidfeature = false,
				craterareaofeffect = 292,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "HeavyCannon",
				noselfdamage = true,
				range = 650,
				reloadtime = 3,
				soundhit = "xplomed4",
				soundhitwet = "splslrg",
				soundhitwetvolume = 0.5,
				soundstart = "cannhvy2",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 310,
				damage = {
					bombers = 55,
					default = 900,
					fighters = 55,
					subs = 5,
					vtol = 55,
				},
			},
		},
		weapons = {
			[1] = {
				def = "COR_GOL",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
