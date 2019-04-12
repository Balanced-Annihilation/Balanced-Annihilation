return {
	armrecl = {
		autoheal = 2,
		buildcostenergy = 4420,
		buildcostmetal = 415,
		builddistance = 140,
		builder = true,
		shownanospray = false,
		buildpic = "ARMRECL.DDS",
		buildtime = 7407,
		canassist = false,
		canmove = true,
		canresurrect = true,
		category = "ALL UNDERWATER NOWEAPON NOTAIR NOTHOVER",
		collisionvolumeoffsets = "0 0 2",
		collisionvolumescales = "38 17 50",
		collisionvolumetype = "box",
		description = "Ressurection Sub",
		explodeas = "smallexplosiongeneric-uw",
		footprintx = 2,
		footprintz = 2,
		icontype = "sea",
		idleautoheal = 3,
		idletime = 300,
		maxdamage = 670,
		minwaterdepth = 15,
		movementclass = "UBOAT33X3",
		name = "Grim Reaper",
		objectname = "ARMRECL",
		seismicsignature = 0,
		selfdestructas = "smallexplosiongenericSelfd-uw",
		sightdistance = 430,
		sonardistance = 270,
		terraformspeed = 2250,

		waterline = 17,
		workertime = 450,		
		--move
		acceleration = 0.14,
		brakerate = 0.075,
		maxvelocity = 2.57,
		turninplace = true,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.6962,		
		turnrate = 600,
		--end move
		
		customparams = {
			
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg2-builder",
				"deathceg3-builder",
				"deathceg4-builder",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			capture = "capture1",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
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
				[1] = "sucormov",
			},
			select = {
				[1] = "sucorsel",
			},
		},
	},
}
