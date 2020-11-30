
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
	--Spring.SendCommands("UseNetMessageSmoothingBuffer ".."0")
	--Spring.SendCommands("NetworkLossFactor ".."2")
	--Spring.SendCommands("LinkOutgoingBandwidth ".."262144")
	--Spring.SendCommands("LinkIncomingSustainedBandiwdth ".."262144")
	--Spring.SendCommands("LinkIncomingPeakBandiwdth ".."262144")
	--Spring.SendCommands("LinkIncomingMaxPacketRate ".."2048")
	
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


		

		

		--Spring.SendCommands("UnitLodDist ".."90000") --need this to remove it from springsettings
		

	if tonumber(Spring.GetConfigInt("reduceping",1) or 1) == 1 then
   reducePing()
   end
   
   if firstlaunchsetupDone == false then
	Spring.SetConfigString("UseNetMessageSmoothingBuffer", '0')
		Spring.SetConfigString("Water", '1')
		Spring.SetConfigString("ProfanityFilter", '1')
		Spring.SetConfigString("chatsound", '1')
		Spring.SetConfigString("modernGUI", '1')
		Spring.SetConfigString("reduceping", '1')
		reducePing()
		Spring.SetConfigString("LuaShaders", '1')
		Spring.SetConfigInt("GroundDetail", 70)   
		firstlaunchsetupDone = true
		Spring.SetConfigInt("MaxNanoParticles", 3000)
		Spring.SetConfigInt("MaxParticles", minMaxparticles)
    end
	
			local camState = Spring.GetCameraState()
			camState.mode = 1
			Spring.SetCameraState(camState,0)
			Spring.SetConfigString("UnitLodDist", '90000')
			Spring.SetConfigString("FeatureDrawDistance", '90000')
			Spring.SetConfigString("FeatureFadeDistance", '90000') 
			Spring.SetConfigString("GuiOpacity", '0.6')
			Spring.SetConfigInt("MouseDragScrollThreshold", 0)    
			Spring.SetConfigInt("EdgeMoveWidth", 0.1)    
			Spring.SetConfigString("AdvSky", '0') --always disable this
			Spring.SetConfigString("Vsync", '0')
			Spring.SetConfigString("GrassDetail",'0')
			Spring.SetConfigString("MouseDragScrollThreshold",'0')
			Spring.SetConfigString("MiniMapDrawProjectiles", '0')
		--Spring.SetConfigInt("ScrollWheelSpeed", 40)  
		
		--local scrollspeed = 40
		--Spring.SetConfigInt("FPSScrollSpeed", scrollspeed)			-- spring default: 10
		--	 Spring.SetConfigInt("OverheadScrollSpeed", scrollspeed)		-- spring default: 10
		--	 Spring.SetConfigInt("RotOverheadScrollSpeed", scrollspeed)	-- spring default: 10
		--	 Spring.SetConfigInt("CamFreeScrollSpeed", scrollspeed*50)	-- spring default: 500
		--	 Spring.SetConfigInt("CamSpringScrollSpeed", scrollspeed)		-- spring default: 10
	
	
   

   
   setEngineFont()   
    widgetHandler:RemoveWidget(self)
end

