return {
	armspid = {
		acceleration = 0.207,
		autoheal = 15,
		brakerate = 0.6486,
		buildcostenergy = 3400,
		buildcostmetal = 175,
		buildpic = "ARMSPID.DDS",
		buildtime = 5090,
		canmove = true,
		category = "ALL KBOT MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "28 15 28",
		collisionvolumetype = "box",
		corpse = "DEAD",
		description = "All-Terrain EMP Spider",
		energymake = 0.7,
		energyuse = 0.7,
		explodeas = "smallexplosiongeneric",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 600,
		maxdamage = 850,
		maxvelocity = 2.385,
		maxwaterdepth = 16,
		movementclass = "TKBOT2",
		mygravity = 10000,
		name = "Spider",
		nochasecategory = "ALL",
		objectname = "ARMSPID",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd",
		sightdistance = 550,
		stealth = true,
		turninplace = true,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 1.749,
		turnrate = 1290.29993,
		customparams = {
			model_author = "Kaiser",
			paralyzemultiplier = 0.125,
			subfolder = "armkbots/t2",
			techlevel = 2,
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0.0926513671875 -4.24316406278e-06 -0.909057617188",
				collisionvolumescales = "31.362487793 12.4340515137 31.2150268555",
				collisionvolumetype = "Box",
				damage = 600,
				description = "Spider Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 40,
				hitdensity = 100,
				metal = 108,
				object = "ARMSPID_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "35.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 400,
				description = "Spider Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 43,
				object = "2X2A",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
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
				[1] = "spider2",
			},
			select = {
				[1] = "spider",
			},
		},
		weapondefs = {
			spider = {
				areaofeffect = 8,
				avoidfeature = false,
				beamdecay = 0.5,
				beamtime = 0.2,
				beamttl = 1,
				collidefriendly = false,
				corethickness = 0.2,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				duration = 0.01,
				explosiongenerator = "custom:laserhit-small-blue",
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 8.8,
				name = "Close-quarters light EMP laser",
				noselfdamage = true,
				paralyzer = true,
				paralyzetime = 9,
				range = 280,
				reloadtime = 1.75,
				rgbcolor = "0.7 0.7 1",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundhitwetvolume = 0.5,
				soundstart = "hackshot",
				soundtrigger = 1,
				targetmoveerror = 0.3,
				thickness = 1.2,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 800,
				customparams = {
					expl_light_color = "0.7 0.7 1",
					light_color = "0.7 0.7 1",
				},
				damage = {
					default = 850,
				},
			},
		},
		weapons = {
			[1] = {
				def = "SPIDER",
				onlytargetcategory = "EMPABLE",
			},
		},
	},
}
