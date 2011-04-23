return {
	armmanni = {
		acceleration = 0.013199999928474,
		brakerate = 0.13750000298023,
		buildcostenergy = 12477,
		buildcostmetal = 1129,
		builder = false,
		buildpic = "ARMMANNI.DDS",
		buildtime = 25706,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Mobile Tachyon Weapon",
		energymake = 5.1999998092651,
		energystorage = 0,
		energyuse = 5.1999998092651,
		explodeas = "ESTOR_BUILDINGEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 2500,
		maxslope = 12,
		maxvelocity = 1.5180000066757,
		maxwaterdepth = 0,
		metalstorage = 0,
		movementclass = "TANK3",
		name = "Penetrator",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "ARMMANNI",
		seismicsignature = 0,
		selfdestructas = "ESTOR_BUILDING",
		sightdistance = 650,
		smoothanim = false,
		trackoffset = 16,
		trackstrength = 10,
		trackstretch = 1,
		tracktype = "StdTank",
		trackwidth = 37,
		turnrate = 151,
		workertime = 0,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 1800,
				description = "Penetrator Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 734,
				object = "ARMMANNI_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 900,
				description = "Penetrator Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 294,
				object = "3X3C",
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
				[1] = "tarmmove",
			},
			select = {
				[1] = "tarmsel",
			},
		},
		weapondefs = {
			atam = {
				areaofeffect = 12,
				beamtime = 0.30000001192093,
				corethickness = 0.30000001192093,
				craterboost = 0,
				cratermult = 0,
				energypershot = 1000,
				explosiongenerator = "custom:FLASH3blue",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				laserflaresize = 20,
				name = "ATAM",
				noselfdamage = true,
				range = 950,
				reloadtime = 5.5,
				rgbcolor = "0 0 1",
				soundhit = "xplolrg1",
				soundstart = "annigun1",
				targetmoveerror = 0.30000001192093,
				thickness = 5.5,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 1500,
				damage = {
					blackhydra = 4000,
					commanders = 1000,
					default = 2500,
					l1subs = 5,
					l2subs = 5,
					l3subs = 5,
					seadragon = 4000,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ATAM",
				maindir = "0 0 1",
				maxangledif = 180,
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
