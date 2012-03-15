return {
	armmh = {
		acceleration = 0.071999996900558,
		brakerate = 0.11200000345707,
		buildcostenergy = 2822,
		buildcostmetal = 163,
		buildpic = "ARMMH.DDS",
		buildtime = 3298,
		canhover = true,
		canmove = true,
		category = "ALL HOVER MOBILE WEAPON NOTSUB NOTSHIP NOTAIR SURFACE",
		corpse = "DEAD",
		description = "Hovercraft Rocket Launcher",
		energymake = 2.5999999046326,
		energyuse = 2.5999999046326,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 477,
		maxslope = 16,
		maxvelocity = 2.4200000762939,
		maxwaterdepth = 0,
		movementclass = "HOVER3",
		name = "Wombat",
		nochasecategory = "VTOL",
		objectname = "ARMMH",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 509,
		turnrate = 470,
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0.23698425293 1.26007220703 -0.625221252441",
				collisionvolumescales = "29.5979919434 18.3375244141 32.5498809814",
				collisionvolumetype = "Box",
				damage = 286,
				description = "Wombat Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 106,
				object = "ARMMH_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 143,
				description = "Wombat Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 42,
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
				[1] = "hovmdok1",
			},
			select = {
				[1] = "hovmdsl1",
			},
		},
		weapondefs = {
			armmh_weapon = {
				areaofeffect = 64,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH3",
				firestarter = 100,
				flighttime = 10,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				metalpershot = 0,
				model = "armmhmsl",
				name = "RocketArtillery",
				noselfdamage = true,
				range = 710,
				reloadtime = 6,
				smoketrail = true,
				soundhit = "xplomed4",
				soundstart = "Rockhvy1",
				tolerance = 4000,
				turnrate = 24384,
				weaponacceleration = 102.40000152588,
				weapontimer = 3,
				weapontype = "StarburstLauncher",
				weaponvelocity = 600,
				damage = {
					default = 300,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "MOBILE",
				def = "ARMMH_WEAPON",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
