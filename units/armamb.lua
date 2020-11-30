return {
	armamb = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 17942,
		buildcostmetal = 2373,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 5,
		buildinggrounddecalsizey = 5,
		buildinggrounddecaltype = "armamb_aoplane.dds",
		buildpic = "ARMAMB.DDS",
		buildtime = 27072,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		cloakcost = 24,
		corpse = "DEAD",
		damagemodifier = 0.25,
		description = "Cloakable Heavy Plasma Cannon",
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 3,
		footprintz = 3,
		hightrajectory = 2,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 3600,
		maxslope = 10,
		maxwaterdepth = 0,
		mincloakdistance = 70,
		name = "Ambusher",
		nochasecategory = "MOBILE",
		objectname = "ARMAMB",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 442,
		usebuildinggrounddecal = false,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.544998168945 2.61108398441e-05 -0.5",
				collisionvolumescales = "48.1152648926 38.0216522217 48.1152648926",
				collisionvolumetype = "Box",
				damage = 2160,
				description = "Ambusher Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 1522,
				object = "ARMAMB_DEAD",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 540,
				description = "Ambusher Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 244,
				object = "3X3B",
                collisionvolumescales = "55.0 4.0 55.0",
                collisionvolumetype = "box",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:barrelshot-large",
			},
			pieceexplosiongenerators = {
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
			armamb_gun = {
				accuracy = 400,
				areaofeffect = 152,
				avoidfeature = false,
				craterareaofeffect = 152,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.25,
				explosiongenerator = "custom:genericshellexplosion-toaster",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.5,
				name = "PopupCannon",
				noselfdamage = true,
				predictboost = 0.2,
				range = 1320,
				reloadtime = 1.8,
				soundhit = "xplomed2",
				soundhitwet = "splslrg",
				soundhitwetvolume = 0.5,
				soundstart = "cannhvy5",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 450,
				damage = {
					bombers = 90,
					default = 345,
					fighters = 90,
					subs = 5,
					vtol = 90,
				},
			},
			armamb_gun_high = {
				accuracy = 400,
				areaofeffect = 224,
				avoidfeature = false,
				craterareaofeffect = 224,
				craterboost = 0.0492,
				cratermult = 0.0492,
				edgeeffectiveness = 0.5,
				explosiongenerator = "custom:genericshellexplosion-toaster",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 2,
				name = "PopupCannon",
				noselfdamage = true,
				proximitypriority = -2,
				range = 1320,
				reloadtime = 7,
				soundhit = "xplomed2",
				soundhitwet = "splslrg",
				soundhitwetvolume = 0.5,
				soundstart = "cannhvy5",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 440,
				damage = {
					bombers = 90,
					commanders = 1504,
					default = 865,
					fighters = 90,
					subs = 5,
					vtol = 90,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL GROUNDSCOUT",
				def = "ARMAMB_GUN",
				maindir = "0 1 0",
				maxangledif = 230,
				onlytargetcategory = "SURFACE",
			},
			[2] = {
				badtargetcategory = "VTOL GROUNDSCOUT",
				def = "ARMAMB_GUN_HIGH",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
