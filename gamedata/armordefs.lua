local armorDefs = {
	commander = {
		"armcom", "armcom2", "armcom3", "armdecom", "corcom", "corcom2", "corcom3", "cordecom",
	},
	aiv = {
		"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacsub", "armacv", "armcv", "armmls", "coracsub", "coracv", "corfast",
		"critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
	},
	artillery = {"armfido","armmart","armmerl","armmship","armraven","armshock","corhrk","cormart","cormh","cormort","cormship","corvroc","corwolv","gorg","shiva","tawf013","trem",},

	invader={"armfast", "corsktl", "armspid", "commando", "corpyro",},

	assault={"armlatnk","armfav","armjanus","armmlv","armsh","armspy","cordefiler","coresupp","corfav","corlevlr","corsh","corvrad","decade","marauder","nsaclash",},

	bomber={"armcybr","armlance","armpnix","armsb","armthund","corgripn","corhurc","corsb","corshad","cortitan","blade",},

	gunship={"armatlas","armbrawl","armdfly","armkam","armpeep","armsaber","armseap","armsl","bladew","corape","corcrw","corcut","corfink","corseap","corvalk",},

	defense={"armvulc","armamb","armamd","armanni","armclaw","armdl","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armpb","armptl","armtl","corbhmth","corbuzz","corexp","corfgate","corfhlt","cormaw","corfmd","corgate","corhlt","corllt","corptl","corpun","cortl","cortoast","corvipe","hllt","tawf001","armbrtha","corint","cordoom","armamex",},

	defenseaa={"armrl","armatl","armcir","armdeva","armfflak","armflak","armfrt","coratl","corenaa","corerad","corflak","corfrt","corrl","madsam","mercury","packo","screamer",},

	heavybot={"corkrog","armmav","corcan","armsptk","armsnipe", "armmark", "armzeus", "armfboy", "cortermite", "corsumo",},

	heavyveh={"armsam", "cormist", "armmanni", "armjam", "tawf114",},

	peon={"armack", "armamph","armch","armck","armcs","armfark","armflea","armpt","armpw","armrecl","armrectr","armsubk","consul","coraca","corack","corak","coramph","corch","corck","corcs","cornecro","corpt","correcl","corshark","corspec","corspy","corsub","corvoyr",},

	fighter={"armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corcsa","corhunt","corsfig","corvamp","corveng",},

	rpg={"armaak","armaas","armah","armjeth","armmh","armrock","armsub","coraak","corah","corarch","corcrash","corstorm",},

	stalwart={"armbanth","armbats","armcarry","armham","armorco","armraz","armvader","armwar","aseadragon","corbats","corcarry","corkarg","corroach","corssub","corthud","corthovr","krogtaar","meteor","tawf009",},

	resource={ "armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","aafus","cafus","armuber","coruber","armgeo","armgmm","amgeo",},

	structure={"armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
		"cortech","cortech2", "cortech3","cortech4","armawin","corawin","ajuno","armaap","armadvsol","armalab","armap","armarad","armaser","armason",
		"armasp","armasy","armavp","armbeaver","armckfus","armdf","armestor","armeyes","armfatf","armfdrag","armfgate","armfhp","armfmine3","armfmkr","armfort","armfrad",
		"armgate","armhp","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armplat","armrad","armsd","armshltx",
		"armshltxuw","armsilo","armsonar","armsy","armtarg","armtide","armuwadves","armuwadvms","armuwes","armuwfus","armuwmex","armuwmme","armuwmmm","armuwms",
		"armveil","armvp","armwin","asubpen","cjuno","cmgeo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
		"cordrag","corestor","coreyes","corfatf","corfdrag","corfhp","corfmine3","corfmkr","corfort","corfrad","corgant","corgantuw","corgeo","corhp",
		"corjamt","corlab","cormakr","cormexp","cormine1","cormine2","cormine3","cormine4","cormmkr","cormstor","cornanotc","corplat","corrad","corsd",
		"corshroud","corsonar","corsy","cortarg","cortide","cortron","coruwadves","coruwadvms","coruwes","coruwfus","coruwmex","coruwmme","coruwmmm","coruwms",
		"corvp","corwin","csubpen","tllmedfusion",},

	tank={"armanac","armbull","armcroc","armcrus","armlun","armpincer","armroy","armscab","armseer","armsjam","armst","armstump","armthovr","armtship","corblackhy","corcrus","cordl","coreter","corgarp","corgol","cormabm","cormlv","corparrow","corraid","correap","corroy","corseal","corsilo","corsjam","corsnap","corsok","cortship","intruder",},

	["else"] = {},
}


--[[
-- -- put any unit that doesn't go in any other category in light armor
for name, ud in pairs(DEFS.unitDefs) do
	local found
	for categoryName, categoryTable in pairs(armorDefs) do
		for _, usedName in pairs(categoryTable) do
			if (usedName == name) then
				found = true
			end
		end
	end
	if (not found) then
		table.insert(armorDefs.LIGHT, name)
		--Spring.Echo("Unit: ", ud.unitname, " Armorclass: light armor")
	end
end
--]]

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(armorDefs)

return armorDefs
