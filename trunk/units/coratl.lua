return {
	coratl = {
		acceleration = 0,
		activatewhenbuilt = true,
		airsightdistance = 700,
		brakerate = 0,
		buildangle = 16384,
		buildcostenergy = 4947,
		buildcostmetal = 429,
		buildpic = "CORATL.DDS",
		buildtime = 7475,
		category = "ALL NOTLAND WEAPON NOTSHIP NOTAIR NOTHOVER NOTSUB SURFACE",
		corpse = "DEAD",
		description = "Sea-To-Air Torpedo Launcher",
		energymake = 0.1,
		energyuse = 0.1,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2362,
		minwaterdepth = 12,
		name = "Lamprey",
		objectname = "CORATL",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 450,
		waterline = 10,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0.0 -1.2890625003e-06 -0.0",
				collisionvolumescales = "44.8439941406 14.7038574219 41.8139953613",
				collisionvolumetype = "Box",
				damage = 337,
				description = "Lamprey Wreckage",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 676,
				object = "CORATL_DEAD",
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
				[1] = "torpadv2",
			},
			select = {
				[1] = "torpadv2",
			},
		},
		weapondefs = {
			coratl_torpedo = {
				areaofeffect = 260,
				avoidfeature = false,
				avoidfriendly = false,
				burnblow = true,
				canattackground = false,
				collidefriendly = false,
				craterareaofeffect = 260,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH3",
				flighttime = 2,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "Advtorpedo",
				name = "LongRangeTorpedo",
				noselfdamage = true,
				proximitypriority = -1,
				range = 720,
				reloadtime = 1.4,
				smoketrail = true,
				soundhit = "",
				soundhitwet = "splslrg",
				soundhitwetvolume = 0.5,
				soundstart = "launch",
				startvelocity = 235,
				submissile = true,
				toairweapon = true,
				tolerance = 1167,
				tracks = true,
				turnrate = 99000,
				turret = true,
				waterweapon = true,
				weaponacceleration = 550,
				weapontimer = 10,
				weapontype = "MissileLauncher",
				weaponvelocity = 1500,
				damage = {
					commanders = 10,
					default = 190,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR LIGHTAIRSCOUT",
				def = "CORATL_TORPEDO",
				onlytargetcategory = "VTOL",
			},
		},
	},
}
