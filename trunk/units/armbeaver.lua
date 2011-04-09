-- UNITDEF -- ARMBEAVER --
--------------------------------------------------------------------------------

local unitName = "armbeaver"

--------------------------------------------------------------------------------

local unitDef = {
  acceleration       = 0.0132,
  bmcode             = 1,
  brakeRate          = 0.1166,
  buildCostEnergy    = 2928,
  buildCostMetal     = 141,
  buildDistance      = 128,
  builder            = true,
  buildPic           = [[ARMBEAVER.DDS]],
  buildTime          = 6708,
  canGuard           = true,
  canMove            = true,
  canPatrol          = true,
  canreclamate       = 1,
  canstop            = 1,
  category           = [[ALL TANK PHIB NOTSUB CONSTR NOWEAPON NOTAIR]],
  corpse             = [[DEAD]],
  defaultmissiontype = [[Standby]],
  description        = [[Amphibious Construction Vehicle]],
  energyMake         = 8,
  energyStorage      = 0,
  energyUse          = 8,
  explodeAs          = [[BIG_UNITEX]],
  footprintX         = 3,
  footprintZ         = 3,
  idleAutoHeal       = 5,
  idleTime           = 1800,
  leaveTracks        = true,
  maneuverleashlength = 640,
  maxDamage          = 925,
  maxSlope           = 16,
  maxVelocity        = 1.49,
  maxWaterDepth      = 255,
  metalMake          = 0.08,
  metalStorage       = 50,
  mobilestandorders  = 1,
  movementClass      = [[ATANK3]],
  name               = [[Beaver]],
  noAutoFire         = false,
  objectName         = [[ARMBEAVER]],
  seismicSignature   = 0,
  selfDestructAs     = [[BIG_UNIT]],
  side               = [[arm]],
  sightDistance      = 266,
  smoothAnim         = false,
  standingmoveorder  = 1,
  steeringmode       = 1,
  TEDClass           = [[TANK]],
  terraformSpeed     = 240,
  trackOffset        = 0,
  trackStrength      = 5,
  trackStretch       = 1,
  trackType          = [[StdTank]],
  trackWidth         = 31,
  turnRate           = 311,
  unitname           = [[armbeaver]],
  workerTime         = 80,
  buildoptions = {
    [[armsolar]],
    [[armadvsol]],
    [[armwin]],
    [[armgeo]],
    [[armmstor]],
    [[armestor]],
    [[armmex]],
    [[armamex]],
    [[armmakr]],
    [[armfhp]],
    [[armlab]],
    [[armvp]],
    [[armap]],
    [[armsy]],
    [[armhp]],
    [[armnanotc]],
    [[armeyes]],
    [[armrad]],
    [[armdrag]],
    [[armclaw]],
    [[armllt]],
    [[tawf001]],
    [[armhlt]],
    [[armguard]],
    [[armrl]],
    [[packo]],
    [[armcir]],
    [[armdl]],
    [[armjamt]],
    [[armtide]],
    [[armuwmex]],
    [[armfmkr]],
    [[armuwms]],
    [[armuwes]],
    [[asubpen]],
    [[armsonar]],
    [[armfdrag]],
    [[armfrad]],
    [[armfhlt]],
    [[armfrt]],
    [[armtl]],
    [[ajuno]],
  },
  sounds = {
    build              = [[nanlath1]],
    canceldestruct     = [[cancel2]],
    repair             = [[repair1]],
    underattack        = [[warning1]],
    working            = [[reclaim1]],
    cant = {
      [[cantdo4]],
    },
    count = {
      [[count6]],
      [[count5]],
      [[count4]],
      [[count3]],
      [[count2]],
      [[count1]],
    },
    ok = {
      [[varmmove]],
    },
    select = {
      [[varmsel]],
    },
  },
}


--------------------------------------------------------------------------------

local featureDefs = {
  DEAD = {
    blocking           = true,
    category           = [[corpses]],
    damage             = 555,
    description        = [[Beaver Wreckage]],
    energy             = 0,
    featureDead        = [[HEAP]],
    featurereclamate   = [[SMUDGE01]],
    footprintX         = 3,
    footprintZ         = 3,
    height             = 20,
    hitdensity         = 100,
    metal              = 92,
    object             = [[ARMBEAVER_DEAD]],
    reclaimable        = true,
    seqnamereclamate   = [[TREE1RECLAMATE]],
    world              = [[All Worlds]],
  },
  HEAP = {
    blocking           = false,
    category           = [[heaps]],
    damage             = 278,
    description        = [[Beaver Heap]],
    energy             = 0,
    featurereclamate   = [[SMUDGE01]],
    footprintX         = 3,
    footprintZ         = 3,
    height             = 4,
    hitdensity         = 100,
    metal              = 37,
    object             = [[3X3C]],
    reclaimable        = true,
    seqnamereclamate   = [[TREE1RECLAMATE]],
    world              = [[All Worlds]],
  },
}
unitDef.featureDefs = featureDefs


--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
