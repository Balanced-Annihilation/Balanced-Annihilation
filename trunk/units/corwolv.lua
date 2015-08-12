return {
	corwolv = {
		acceleration = 0.011,
		brakerate = 0.0297,
		buildcostenergy = 2367,
		buildcostmetal = 153,
		buildpic = "CORWOLV.DDS",
		buildtime = 3254,
		canmove = true,
		category = "ALL TANK WEAPON NOTSUB NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 1 0",
		collisionvolumescales = "29 15 35",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Light Mobile Artillery",
		energymake = 0.5,
		energyuse = 0.5,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		hightrajectory = 1,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 577,
		maxslope = 10,
		maxvelocity = 1.87,
		maxwaterdepth = 8,
		movementclass = "TANK2",
		name = "Wolverine",
		nochasecategory = "VTOL",
		objectname = "CORWOLV",
		pushresistant = true,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 299,
		trackoffset = 6,
		trackstrength = 5,
		tracktype = "StdTank",
		trackwidth = 30,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.2342,
		turnrate = 466,
		customparams = {
			canareaattack = 1,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.947448730469 -6.45624659424 -0.712127685547",
				collisionvolumescales = "26.1215209961 9.12510681152 48.7677612305",
				collisionvolumetype = "Box",
				damage = 330,
				description = "Wolverine Wreckage",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 0,
				hitdensity = 100,
				metal = 103,
				object = "CORWOLV_DEAD",
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
			corwolv_gun = {
				accuracy = 275,
				areaofeffect = 113,
				avoidfeature = false,
				craterareaofeffect = 113,
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
				reloadtime = 3.5,
				soundhit = "xplomed2",
				soundhitwet = "splsmed",
				soundhitwetvolume = 0.5,
				soundstart = "cannhvy3",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 365,
				damage = {
					bombers = 15,
					default = 150,
					fighters = 15,
					subs = 5,
					vtol = 15,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORWOLV_GUN",
				maindir = "0 0 1",
				maxangledif = 180,
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
