return {
	corsh = {
		acceleration = 0.11999999731779,
		brakerate = 0.11200000345707,
		buildcostenergy = 1439,
		buildcostmetal = 71,
		buildpic = "CORSH.DDS",
		buildtime = 4079,
		canhover = true,
		canmove = true,
		category = "ALL HOVER MOBILE WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Fast Attack Hovercraft",
		energymake = 2.5999999046326,
		energyuse = 2.5999999046326,
		explodeas = "SMALL_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 2.2999999523163,
		idletime = 900,
		maxdamage = 230,
		maxslope = 16,
		maxvelocity = 4.2600002288818,
		maxwaterdepth = 0,
		movementclass = "HOVER3",
		name = "Scrubber",
		nochasecategory = "VTOL",
		objectname = "CORSH",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		sightdistance = 509,
		turnrate = 615,
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				damage = 162,
				description = "Scrubber Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 40,
				object = "CORSH_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 81,
				description = "Scrubber Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 16,
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
				[1] = "hovsmok2",
			},
			select = {
				[1] = "hovsmsl2",
			},
		},
		weapondefs = {
			armsh_weapon = {
				areaofeffect = 8,
				beamtime = 0.10000000149012,
				burstrate = 0.20000000298023,
				color = 232,
				color2 = 234,
				craterboost = 0,
				cratermult = 0,
				duration = 0.019999999552965,
				energypershot = 3,
				explosiongenerator = "custom:FLASH1nd",
				firestarter = 50,
				impactonly = 1,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "Laser",
				noselfdamage = true,
				range = 230,
				reloadtime = 0.60000002384186,
				soundhit = "lashit",
				soundstart = "lasrfast",
				soundtrigger = true,
				targetmoveerror = 0.30000001192093,
				thickness = 1.25,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 450,
				damage = {
					default = 48,
					hgunships = 6,
					l1subs = 2,
				},
			},
		},
		weapons = {
			[1] = {
				def = "ARMSH_WEAPON",
			},
		},
	},
}
