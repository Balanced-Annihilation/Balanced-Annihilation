-- UNITDEF -- ARMUBER --
--------------------------------------------------------------------------------

local unitName = "armuber"

--------------------------------------------------------------------------------

local unitDef = {
	activateWhenBuilt = true,
	bmcode = 0,
	buildAngle = 8192,
	buildCostEnergy = 69600,
	buildCostMetal = 5430,
	builder = false,
	buildingGroundDecalDecaySpeed = 30,
	buildingGroundDecalSizeX = 10,
	buildingGroundDecalSizeY = 10,
	buildingGroundDecalType = [[armuber_aoplane.dds]],
	buildTime = 85800,
	canattack = false,
	category = [[ALL NOTDEFENSENOTVTOL NOTMOBILE NOTSUB NOTSUBNOTSHIP NOTVTOL NOTWEAPON]],
	collisionvolumeoffsets = [[0 0 0]],
	collisionvolumescales = [[80 112 80]],
	collisionvolumetest = 1,
	collisionvolumetype = [[CylY]],
	damageModifier = 0.4,
	description = [[Deep Core Metal Extractor, Amphibious]],
	designation = [[AM-EME1]],
	energyMake = 0,
	energyStorage = 0,
	energyUse = 250,
	explodeAs = [[ATOMIC_BLAST]],
	extractsMetal = 0.03,
	footprintX = 7,
	footprintZ = 7,
	iconType = [[building]],
	idleAutoHeal = 5,
	idleTime = 1800,
	maxDamage = 3146,
	maxSlope = 20,
	maxWaterDepth = 9999,
	metalStorage = 2500,
	name = [[Mass Extractor]],
	noAutoFire = false,
	noChaseCategory = [[ALL]],
	objectName = [[ARMMAS]],
	onoffable = true,
	radarDistance = 0,
	selfDestructAs = [[MINE_NUKE]],
	side = [[ARM]],
	sightDistance = 322,
	unitname = [[armuber]],
	useBuildingGroundDecal = true,
	workerTime = 0,
	yardMap = [[ooooooo ooooooo ooooooo ooooooo ooooooo ooooooo ooooooo]],
	weaponDefs = nil,
	weapons = {
		[1] = {
			def = [[ARMMASshield]],
			onlyTargetCategory = [[NOTVTOL]],
		},
	},
}

--------------------------------------------------------------------------------

local weaponDefs = {
	ARMMASshield = {
		name = [[ExtractorShield]],
		shieldAlpha = 0.4,
		shieldBadColor = [[0.05 0.05 0.05]],
		shieldEnergyUse = 60,
		shieldGoodColor = [[0.8 0.8 1]],
		shieldInterceptType = -1,
		shieldPower = 5000,
		shieldPowerRegen = 100,
		shieldPowerRegenEnergy = 117.2,
		shieldRadius = 107,
		shieldRepulser = false,
		shieldStartingPower = 5000,
		smartShield = true,
		visibleShield = true,
		visibleShieldHitFrames = 70,
		visibleShieldRepulse = true,
		weaponType = [[Shield]],
		damage = {
			default = 100,
			subs = 5,
		},
	},
}
unitDef.weaponDefs = weaponDefs

--------------------------------------------------------------------------------

return lowerkeys({[unitName] = unitDef})

--------------------------------------------------------------------------------
