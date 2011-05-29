return {
	cortoast = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 16115,
		buildcostmetal = 2318,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 5,
		buildinggrounddecalsizey = 5,
		buildinggrounddecaltype = "cortoast_aoplane.dds",
		buildpic = "CORTOAST.DDS",
		buildtime = 25717,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		damagemodifier = 0.25,
		description = "Heavy Plasma Cannon",
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 3,
		footprintz = 3,
		hightrajectory = 2,
		icontype = "building",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 3840,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Toaster",
		nochasecategory = "MOBILE",
		objectname = "CORTOAST",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 416,
		usebuildinggrounddecal = true,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "66.412979126 46.1585998535 60.6329803467",
				collisionvolumeoffsets = "2.98622894287 -7.32421874261e-08 6.36557769775",
				category = "corpses",
				damage = 2304,
				description = "Toaster Wreckage",
				energy = 0,
				featuredead = "DEAD2",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 1507,
				object = "CORTOAST_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			dead2 = {
				blocking = true,
				category = "corpses",
				damage = 1152,
				description = "Toaster Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 603,
				object = "CORTOAST_DEAD2",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 576,
				description = "Toaster Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 241,
				object = "3X3A",
				reclaimable = true,
				world = "All Worlds",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak2",
			uncloak = "kloak2un",
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			cortoast_gun = {
				accuracy = 450,
				areaofeffect = 164,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.25,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.5,
				name = "PopupCannon",
				noselfdamage = true,
				predictboost = 0.20000000298023,
				range = 1335,
				reloadtime = 2.0999999046326,
				soundhit = "xplomed2",
				soundstart = "cannhvy5",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 450,
				damage = {
					bombers = 90,
					default = 346,
					fighters = 90,
					subs = 5,
					vtol = 90,
				},
			},
			cortoast_gun_high = {
				accuracy = 450,
				areaofeffect = 240,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.5,
				explosiongenerator = "custom:FLASH96",
				gravityaffected = "true",
				impulseboost = 0.12300000339746,
				impulsefactor = 2,
				name = "PopupCannon",
				noselfdamage = true,
				proximitypriority = -2,
				range = 1335,
				reloadtime = 7,
				soundhit = "xplomed2",
				soundstart = "cannhvy5",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 440,
				damage = {
					bombers = 90,
					commanders = 1402,
					default = 807,
					fighters = 90,
					subs = 5,
					vtol = 90,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORTOAST_GUN",
				maindir = "0 1 0",
				maxangledif = 230,
				onlytargetcategory = "NOTAIR",
			},
			[2] = {
				def = "CORTOAST_GUN_HIGH",
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
