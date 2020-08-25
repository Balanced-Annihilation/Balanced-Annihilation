local array = {}

local DAMAGE_PERIOD = 10 -- how often damage is applied

local weapons = {


	--junos
	ajuno_juno_pulse = { radius = 950, damage = 0, duration = 660, rangeFall = 0.8, timeFall = 0.1, scoutDmg = 60},
	cjuno_juno_pulse = { radius = 950, damage = 0, duration = 660, rangeFall = 0.8, timeFall = 0.1, scoutDmg = 60},
	
	--mortor_canon
	amortor_mortor_cannon =  { radius = 95, damage = 200, duration = 120, rangeFall = 0.25, timeFall = 0.5, allyScale = 0.25, teamScale = 0.25},
	cmortor_mortor_cannon =  { radius = 95, damage = 200, duration = 120, rangeFall = 0.25, timeFall = 0.5, allyScale = 0.25, teamScale = 0.25},

}

-- radius		- defines size of sphereical area in which damage is dealt
-- damage		- maximun damage over 1 second that can be dealt to a unit
-- duration		- how long the area damage stays around for (in frames)
-- rangeFall	- the proportion of damage not dealt increases linearly with distance from 0 to rangeFall at the radius
-- timeFall		- the proportion of damage not dealt increases linearly with elapsed time from 0 to timeFall at the duration

local presets = {
	--module_napalmgrenade = { radius = 256, damage = 20, duration = 1400, rangeFall = 0.6, timeFall = 0.5 },
}

------------------------
-- Send the Config

for name,data in pairs(WeaponDefNames) do
	if data.customParams.areadamage_preset then
		weapons[name] = Spring.Utilities.CopyTable(presets[data.customParams.areadamage_preset])
	end
	if weapons[name] then
		weapons[name].damage = weapons[name].damage *DAMAGE_PERIOD/30
		weapons[name].timeLoss = weapons[name].damage*weapons[name].timeFall*DAMAGE_PERIOD/weapons[name].duration
		array[data.id] = weapons[name]
	end
end

return DAMAGE_PERIOD, array
