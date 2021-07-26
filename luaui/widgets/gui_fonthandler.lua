function widget:GetInfo()
	return {
		name      = "Font handler",
		desc      = "handles font object creation",
		author    = "Floris",
		date      = "June 2020",
		license   = "GNU GPL, v2 or later",
		layer     = -math.huge,
		enabled   = true
	}
end


local defaultFile = "fonts/" .. Spring.GetConfigString("ba_font", "FreeSansBold.otf")
local defaultFile2 = "fonts/" .. Spring.GetConfigString("ba_font2", "FreeSansBold.otf")
local defaultSize = 32
local defaultOutlineSize = 0.17
local defaultOutlineStrength = 1.05

local presets = {
	{defaultFile, defaultSize, defaultOutlineSize, defaultOutlineStrength},
	{defaultFile, defaultSize, 0.2, 1.3},
	{defaultFile2, defaultSize, defaultOutlineSize, defaultOutlineStrength},
	{defaultFile2, defaultSize, 0.2, 1.3},
}


local vsx,vsy = Spring.GetViewGeometry()
local fonts = {}
local fontScale = 1
local sceduledDeleteFonts = {}


local function split(s, separator)
	local results = {}
	for part in s:gmatch("[^"..separator.."]+") do
		results[#results + 1] = part
	end
	return results
end


local function createFont(file, size, outlineSize, outlineStrength)
	local id = file..'_'..size..'_'..outlineSize..'_'..outlineStrength
	if fonts[id] ~= nil then
		sceduledDeleteFonts[#sceduledDeleteFonts+1] = fonts[id]
		sceduledDeleteFontsClock = os.clock() + 5
	end
	fonts[id] = gl.LoadFont(file, size*fontScale, outlineSize*fontScale, outlineStrength)
end


function widget:Update(dt)
	if sceduledDeleteFontsClock and sceduledDeleteFontsClock < os.clock() then
		for i,font in pairs(sceduledDeleteFonts) do
			gl.DeleteFont(font)
		end
		sceduledDeleteFonts = {}
		sceduledDeleteFontsClock = nil
	end
end


function widget:Initialize()
	widget:ViewResize()

	WG['fonts'] = {}
	WG['fonts'].getFont = function(file, size, outlineSize, outlineStrength)
		if type(file) == 'number' and presets[file] then	-- this method doesnt work yet, magically nil errors when trying
			file = presets[file][1]
			size = presets[file][2]
			outlineSize = presets[file][3]
			outlineStrength = presets[file][4]
		else
			file = (file and file or defaultFile)
			size = math.floor((defaultSize * (size and size or 1) + 0.5))
			outlineSize = math.floor((defaultSize * (outlineSize and outlineSize or defaultOutlineSize)) + 0.5)
			outlineStrength = (outlineStrength and outlineStrength or defaultOutlineStrength)
		end

		local id = file..'_'..size..'_'..outlineSize..'_'..outlineStrength
		if fonts[id] == nil then
			createFont(file, size, outlineSize, outlineStrength)
		end
		return fonts[id], size*fontScale
	end

end


function widget:ViewResize()
	vsx,vsy = Spring.GetViewGeometry()
	local newFontScale = ((vsx+vsy / 2) / 2500)
	if fontScale ~= newFontScale then
		fontScale = newFontScale
		for id,font in pairs(fonts) do
			local params = split(id, '_')
			createFont(params[1], tonumber(params[2]), tonumber(params[3]), tonumber(params[4]))
		end
	end
end


function widget:GetConfigData() --save config
	return {fonts=fonts, fontScale=fontScale}
end


function widget:SetConfigData(data) --load config
	if Spring.GetGameFrame() > 0 then
		if data.fonts ~= nil then
			fonts = data.fonts
			fontScale = data.fontScale
		end
	end
end
