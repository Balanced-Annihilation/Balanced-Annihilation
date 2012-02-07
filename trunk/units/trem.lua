return {
	trem = {
		acceleration = 0.052799999713898,
		brakerate = 0.10999999940395,
		buildcostenergy = 45350,
		buildcostmetal = 1951,
		buildpic = "TREM.DDS",
		buildtime = 31103,
		canmove = true,
		category = "ALL WEAPON NOTSUB NOTAIR NOTHOVER",
		collisionvolumeoffsets = "0 -5 -3",
		collisionvolumescales = "29 59 46",
		collisionvolumetest = 1,
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Heavy Artillery Vehicle",
		energymake = 2.0999999046326,
		energyuse = 2.0999999046326,
		explodeas = "BIG_UNIT",
		footprintx = 4,
		footprintz = 4,
		hightrajectory = 1,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 2700,
		maxslope = 14,
		maxvelocity = 1.4520000219345,
		maxwaterdepth = 15,
		movementclass = "HTANK4",
		name = "Tremor",
		nochasecategory = "VTOL",
		objectname = "TREM",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 351,
		trackoffset = -8,
		trackstrength = 8,
		tracktype = "StdTank",
		trackwidth = 28,
		turnrate = 169.39999389648,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "1.25984954834 -1.01012474365 0.475593566895",
				collisionvolumescales = "55.5426483154 42.2261505127 61.5749359131",
				collisionvolumetype = "Box",
				damage = 1827,
				description = "Tremor Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 8,
				hitdensity = 100,
				metal = 1118,
				object = "TREM_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 914,
				description = "Tremor Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 2,
				hitdensity = 100,
				metal = 527,
				object = "2X2B",
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
				[1] = "tcormove",
			},
			select = {
				[1] = "tcorsel",
			},
		},
		weapondefs = {
			trem1 = {
				accuracy = 1400,
				areaofeffect = 160,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH4",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "RapidArtillery",
				noselfdamage = true,
				proximitypriority = -3,
				range = 1275,
				reloadtime = 0.40000000596046,
				soundhit = "xplomed4",
				soundstart = "cannhvy2",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 414.87948608398,
				damage = {
					bombers = 19,
					default = 295,
					fighters = 19,
					subs = 5,
					vtol = 19,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "TREM1",
				maindir = "0 0 1",
				maxangledif = 270,
				onlytargetcategory = "NOTAIR NOTSUB",
			},
		},
	},
}
