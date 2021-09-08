unitDef = {
  unitname            = [[critter_duck]],
  name                = [[Duck]],
  description         = [[quack quack]],
  iconType            = "blank",
  acceleration        = 0.12, 
  bmcode              = [[1]],
  brakeRate           = 1, --0.5
  buildCostEnergy     = 0,
  buildCostMetal      = 0,
  builder             = false,
   buildPic            = [[ARMCOM.DDS]],
  buildTime           = 10,--5
  canAttack           = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canstop             = [[1]],
  category            = [[MOBILE NOWEAPON NOTAIR NOTSUB]],  
  reclaimable         = false,
	----------	
  defaultmissiontype  = [[Standby]],
  --explodeAs           = [[big_unit]],
  footprintX          = 1,
  footprintZ          = 1,
  idleAutoHeal        = 0,  
  maneuverleashlength = [[640]],
  mass                = 24,
  maxDamage           = 10,
  maxSlope            = 45,
  maxVelocity         = 0.35,
  --maxReverseVelocity   = 2.5,  ---**** als upgrade
  maxWaterDepth       = 22,
  movementClass       = [[CRITTERH]],
  --crushStrength 	  = 25,
  moveState           = -1,
  noAutoFire          = false,
  noChaseCategory     = [[MOBILE STATIC]],
  objectName          = [[critter_duck.s3o]], --
  --selfDestructAs      = [[big_unit]],
  selfDestructCountdown = 0,
  upright=false,
  floater = true,
  waterline           = 6,
  side                = [[GAYS]],
  sightDistance       = 0,--250
  seismicSignature    = 0,
  smoothAnim          = true,
  steeringmode        = [[1]],
  TEDClass            = [[TANK]],
  leaveTracks         = true,
  trackOffset         = 0,
  trackStrength       = 3,
  trackStretch        = 1,
  --trackType           = [[footSteps]],
  trackWidth          = 10,
  turninplace         = 1,
  turnRate            = 500,
  workerTime          = 0,
  script              = [[critter_duck.lua]], -- [[tpdude.lua]], 
  stealth 			      = true,
  sonarStealth		    = true,
	blocking						= false,
	capturable          = false,
}

return lowerkeys({ critter_duck = unitDef })
