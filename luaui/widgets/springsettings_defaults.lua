
function widget:GetInfo()
	return {
		name      = "springsettings defaults",
		desc      = "default settings",
		author    = "Niobium",
		date      = "3 April 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true
	}
end

local minMaxparticles = 5000

local function reducePing()
	Spring.SendCommands("UseNetMessageSmoothingBuffer ".."0")
	Spring.SendCommands("NetworkLossFactor ".."2")
	Spring.SendCommands("LinkOutgoingBandwidth ".."262144")
	Spring.SendCommands("LinkIncomingSustainedBandiwdth ".."262144")
	Spring.SendCommands("LinkIncomingPeakBandiwdth ".."262144")
	Spring.SendCommands("LinkIncomingMaxPacketRate ".."2048")
	
	Spring.SetConfigString("UseNetMessageSmoothingBuffer ", '0')
		Spring.SetConfigString("NetworkLossFactor ", '2')
		Spring.SetConfigString("LinkOutgoingBandwidth ", '262144')
		Spring.SetConfigString("LinkIncomingSustainedBandwidth ", '262144')
		Spring.SetConfigString("LinkIncomingPeakBandwidth ", '262144')
		Spring.SetConfigString("LinkIncomingMaxPacketRate ", '2048')
		
		Spring.SendCommands("FeatureDrawDistance ".."10000")
		Spring.SendCommands("FeatureFadeDistance ".."10000")
		Spring.SetConfigString("FeatureDrawDistance", '10000')
		Spring.SetConfigString("FeatureFadeDistance", '10000') 
end

local function setEngineFont()
local font = "LuaUI/Fonts/FreeSansBold.otf"
		Spring.SendCommands("font "..font)
		Spring.SendCommands("font ".."")
		Spring.SetConfigString("SmallFontFile", 'FreeSansBold.otf')
		Spring.SetConfigString("FontFile", 'FreeSansBold.otf')
end

local firstlaunchsetupDone = false
function widget:GetConfigData()
    savedTable = {}
    savedTable.firsttimesetupDone = firstlaunchsetupDone
    return savedTable
end

function widget:SetConfigData(data)
    if data.firsttimesetupDone ~= nil then
        firstlaunchsetupDone = data.firsttimesetupDone
    end
end

function widget:Initialize()

					Spring.SendCommands("UnitLodDist ".."10000") --need this to remove it from springsettings
					Spring.SetConfigString("UnitLodDist", '10000')
					Spring.SetConfigString("hangtimeout", '0')

   reducePing()
   
   if firstlaunchsetupDone == false then
		
			
		 if tonumber(Spring.GetConfigInt("MaxParticles",1) or 0) < minMaxparticles then
            Spring.SendCommands("MaxParticles ".. minMaxparticles)
			Spring.SetConfigInt("MaxParticles", minMaxparticles)
        end
		
		Spring.SendCommands("MiniMapDrawProjectiles ",0)
		Spring.SetConfigInt("MiniMapDrawProjectiles",0)

        firstlaunchsetupDone = true
    end
   
   setEngineFont()
   
    widgetHandler:RemoveWidget(self)
end

