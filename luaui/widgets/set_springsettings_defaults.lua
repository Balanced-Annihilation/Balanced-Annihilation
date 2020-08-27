
function widget:GetInfo()
	return {
		name      = "set springsettings defaults",
		desc      = "default settings",
		author    = "Niobium",
		date      = "3 April 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		handler = true,
		enabled   = true
	}
end

local minMaxparticles = 15000

local function reducePing()
	Spring.SendCommands("UseNetMessageSmoothingBuffer ".."0")
	Spring.SendCommands("NetworkLossFactor ".."2")
	Spring.SendCommands("LinkOutgoingBandwidth ".."262144")
	Spring.SendCommands("LinkIncomingSustainedBandiwdth ".."262144")
	Spring.SendCommands("LinkIncomingPeakBandiwdth ".."262144")
	Spring.SendCommands("LinkIncomingMaxPacketRate ".."2048")
	
	Spring.SetConfigString("UseNetMessageSmoothingBuffer", '0')
		Spring.SetConfigString("NetworkLossFactor", '2')
		Spring.SetConfigString("LinkOutgoingBandwidth", '262144')
		Spring.SetConfigString("LinkIncomingSustainedBandwidth", '262144')
		Spring.SetConfigString("LinkIncomingPeakBandwidth", '262144')
		Spring.SetConfigString("LinkIncomingMaxPacketRate", '2048')
		
		--Spring.SendCommands("FeatureDrawDistance ".."90000")
		--Spring.SendCommands("FeatureFadeDistance ".."90000")
		
end

local function setEngineFont()
		local font = "FreeSansBold.otf"
		
		Spring.SetConfigString('FontOutlineWeight','25')
		Spring.SetConfigString('FontOutlineWidth','3')
		Spring.SetConfigString('FontSize','23')
		Spring.SetConfigString('SmallFontOutlineWeight','10')
		Spring.SetConfigString('SmallFontOutlineWidth','2')
		Spring.SetConfigString('SmallFontSize','14')
		
		Spring.SendCommands("font "..font)
		--Spring.SendCommands("font ".."")
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


		

		local camState = Spring.GetCameraState()
		camState.mode = 1
		Spring.SetCameraState(camState,0)

					--Spring.SendCommands("UnitLodDist ".."90000") --need this to remove it from springsettings
					Spring.SetConfigString("UnitLodDist", '90000')
					Spring.SetConfigString("HangTimeout", '-10')
					Spring.SetConfigString("GuiOpacity", '0.6')

	
   
   if firstlaunchsetupDone == false then
	Spring.SetConfigString("UseNetMessageSmoothingBuffer", '0')
   		Spring.SetConfigString("VSync", '0')
		Spring.SetConfigString("Water", '1')
		Spring.SetConfigString("ProfanityFilter", '1')
		Spring.SetConfigString("AdvSky", '0') --1 would crash tassles
		Spring.SetConfigString("reduceping", '1')
		reducePing()
		Spring.SetConfigString("LuaShaders", '1')
		Spring.SetConfigString("FeatureDrawDistance", '90000')
		Spring.SetConfigString("FeatureFadeDistance", '90000') 
		Spring.SetConfigString("GrassDetail",'0')
		Spring.SetConfigString("MiniMapDrawProjectiles", '0')
		firstlaunchsetupDone = true
		
        Spring.SendCommands("MaxParticles ".. minMaxparticles)
		Spring.SetConfigInt("MaxParticles", minMaxparticles)
		Spring.SetConfigInt("GroundDetail", 100)    
    end
	
	if tonumber(Spring.GetConfigInt("reduceping",1) or 1) == 1 then
   reducePing()
   end
   

   
   setEngineFont()
	
   
    widgetHandler:RemoveWidget(self)
end

