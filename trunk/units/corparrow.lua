return {
	corparrow = {
		acceleration = 0.014999999664724,
		brakerate = 0.07150000333786,
		buildcostenergy = 26854,
		buildcostmetal = 988,
		buildpic = "CORPARROW.DDS",
		buildtime = 22181,
		canmove = true,
		category = "ALL TANK PHIB WEAPON NOTSUB NOTAIR NOTHOVER",
		collisionVolumeScales = [[44.6 24.6 46.6]],
		collisionVolumeOffsets = [[0 -4 0]],
		collisionVolumeTest = 1,
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Very Heavy Amphibious Tank",
		energymake = 2.0999999046326,
		energyuse = 2.0999999046326,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5 ,
		idletime = 1800 ,
		leavetracks = true,
		maxdamage = 5700,
		maxslope = 12,
		maxvelocity = 1.9500000476837,
		maxwaterdepth = 255,
		movementclass = "ATANK3",
		name = "Poison Arrow",
		nochasecategory = "VTOL",
		objectname = "CORPARROW",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 385,
		trackoffset = -6,
		trackstrength = 10,
		tracktype = "StdTank",
		trackwidth = 45,
		turnrate = 400,
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "36.4536895752 11.1021575928 54.8021697998",
				collisionvolumeoffsets = "4.526512146 -4.16978120361 3.13526153564",
				category = "corpses",
				damage = 3420,
				description = "Poison Arrow Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 9,
				hitdensity = 100,
				metal = 642,
				object = "CORPARROW_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1710,
				description = "Poison Arrow Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				hitdensity = 100,
				metal = 257,
				object = "3X3A",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
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
			core_parrow = {
				areaofeffect = 160,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "PoisonArrowCannon",
				noselfdamage = true,
				range = 575,
				reloadtime = 1.7999999523163,
				soundhit = "xplomed1",
				soundstart = "largegun",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 300,
				damage = {
					bombers = 60,
					default = 370,
					fighters = 60,
					subs = 5,
					vtol = 60,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORE_PARROW",
			},
		},
	},
}
