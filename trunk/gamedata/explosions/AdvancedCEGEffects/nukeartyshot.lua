-- nukeartyshot

return {
  ["nukeartyshot"] = {
    poof01 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[1.0 1.0 1.0 0.04   0.5 0.3 0.0 0.01  0.5 0 0.0 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 10,
        particlelifespread = 0,
        particlesize       = 2,
        particlesizespread = 0,
        particlespeed      = 10,
        particlespeedspread = 0,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 0.6,
        texture            = [[muzzleside]],
        useairlos          = false,
      },
    },
    pop1 = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 8,
        heatfalloff        = 3,
        maxheat            = 10,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1,
        sizegrowth         = 15,
        speed              = [[0, 0, 0]],
        texture            = [[electriclight]],
      },
    },
  },

}

