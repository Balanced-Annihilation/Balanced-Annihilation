function widget:GetInfo()
    return {
        name      = "Pause Screen",
        desc      = "Displays an overlay when the game is paused",
        author    = "Floris",
        date      = "sept 2016",
        license   = "GNU GPL v2",
        layer     = -1001,
        enabled   = true
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spGetGameSpeed        = Spring.GetGameSpeed
local spIsGUIHidden         = Spring.IsGUIHidden

local glColor               = gl.Color
local glTexture             = gl.Texture
local glScale               = gl.Scale
local glPopMatrix           = gl.PopMatrix
local glPushMatrix          = gl.PushMatrix
local glTranslate           = gl.Translate
local glTexRect             = gl.TexRect
local glLoadFont            = gl.LoadFont
local glDeleteFont          = gl.DeleteFont
local glRect                = gl.Rect
local glUseShader           = gl.UseShader
local glCopyToTexture       = gl.CopyToTexture
local glUniform             = gl.Uniform
local glGetUniformLocation  = gl.GetUniformLocation

local osClock               = os.clock

----------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-------------------------------
-- logic
-------------------------------

local slideTime = 0.4

local paused = false
local lastPaused = false -- pause state on previous Update
local pauseTimestamp = -slideTime -- most recent time at which pause state changed
local drawPauseScreen = false
local gameStarted = false


function widget:Initialize()
  InitializeGL()
  
  if Spring.GetGameFrame() > 0 then
  	gameStarted = true
  end
  
  widget:Update()
  if paused then
	pauseTimestamp = -slideTime -- gracefully handle luaui reload whilst paused 
    lastPaused = true
  end
end

function widget:GameStart()
	gameStarted = true
end

function widget:GameOver()
    widgetHandler:RemoveWidget()
end

function widget:Update(dt)
	if not gameStarted then return end	
	
    local _, gameSpeed, isPaused = spGetGameSpeed()
    if isPaused or gameSpeed <= 0 then -- SPADS can "pause" by setting gamespeed 0
        paused = true
    else
        paused = false
    end	
	
	local now = osClock()		
	local became_paused = (paused and not lastPaused)
	local became_unpaused = (not paused and lastPaused)
    if became_paused or became_unpaused then
		local diffPauseTime = now - pauseTimestamp
        if diffPauseTime <= slideTime then
			-- pause state changed during animation, re-write history to make the sliding work nicely
            timeRemaining = slideTime - diffPauseTime
			pauseTimestamp = now - timeRemaining
		else 
			-- "normal" pause state change
			pauseTimestamp = osClock()
		end
    end

	drawPauseScreen = paused or (osClock() - pauseTimestamp <= slideTime)
	if drawPauseScreen and spIsGUIHidden() then drawPauseScreen = false end
	
    lastPaused = paused	
end

-------------------------------
-- draw
-------------------------------

local sizeMultiplier        = 1
local maxAlpha              = 0.6
local maxShaderAlpha        = 0.33
local maxNonShaderAlpha     = 0.1			--background alpha when shaders arent availible
local boxWidth              = 200
local boxHeight             = 35
local fadeToTextAlpha       = 0.5
local fontSizeHeadline      = 24
local fontPath              = "LuaUI/Fonts/MicrogrammaDBold.ttf"

local myFont
local wndX1 = nil
local wndY1 = nil
local wndX2 = nil
local wndY2 = nil
local textX = nil
local textY = nil
local usedSizeMultiplier = 1
local vsx, vsy = Spring.GetWindowGeometry()

local shaderAlpha = 0
local screencopy
local shaderProgram

local fragmentShaderSource = {
	--intensity formula based on http://alienryderflex.com/hsp.html
	washed = [[
		uniform sampler2D screencopy;
		uniform float alpha;

		float getIntensity(vec4 color) {
		  vec3 intensityVector = color.rgb * vec3(0.66,0.66,0.66);
		  return length(intensityVector);
		}

		void main() {
		  vec2 texCoord = vec2(gl_TextureMatrix[0] * gl_TexCoord[0]);
		  vec4 origColor = texture2D(screencopy, texCoord);
		  float intensity = getIntensity(origColor);
		  intensity = intensity * 1.15;
		  float multi = intensity * 0.9;
		  if (intensity > 1) intensity = 1;
		  if (intensity < 0.5) {
				if (intensity < 0.2) {
				  gl_FragColor = vec4(multi*0.22, multi*0.22, multi*0.22, alpha);
				} else if (intensity < 0.35) {
				  gl_FragColor = vec4(multi*0.32, multi*0.32, multi*0.32, alpha);
				} else {
				  gl_FragColor = vec4(multi*0.55, multi*0.55, multi*0.55, alpha);
				}
		  } else {
				if (intensity < 0.75) {
					gl_FragColor = vec4(multi*0.7, multi*0.7, multi*0.7, alpha);
				} else {
				  gl_FragColor = vec4(multi*0.82, multi*0.82, multi*0.82, alpha);
				}
		  }
		}
	]],
}

function InitializeGL()
  vsx, vsy = widgetHandler:GetViewSizes()
  widget:ViewResize(vsx, vsy)
  
  myFont = glLoadFont(fontPath, fontSizeHeadline)
   
  if gl.CreateShader and (Platform == nil or Platform.gpuVendor ~= 'Intel') then
    shaderProgram = gl.CreateShader(
    {
	  fragment = fragmentShaderSource.washed,
	  uniformInt = {
		  screencopy = 0,
		},
	})
    if shaderProgram then
  	    alphaLoc = glGetUniformLocation(shaderProgram, "alpha")
    end
  else
    Spring.Echo("<Screen Shader>: GLSL not supported.")
  end
end

function widget:Shutdown()
  glDeleteFont(myFont)
  if shaderProgram then
    gl.DeleteShader(shaderProgram)
  end
end

function widget:DrawScreen()
  if Spring.IsGUIHidden() then return end  
  if not drawPauseScreen then return end
  DrawPause()
end

function DrawPause()
    local now = osClock()
    local diffPauseTime = (now - pauseTimestamp)
    
    local text           = { 1.0, 1.0, 1.0, 0*maxAlpha }
    local outline        = { 0.0, 0.0, 0.0, 0*maxAlpha }     
    
	-- progress: 1==off-screen, 0==center
    if paused then 
    	progress = math.max(0.0, 1.0 - diffPauseTime / slideTime)
    else
    	progress = math.min(1.0, diffPauseTime / slideTime)
    end
	
    text[4]	   = (text[4] * progress) + fadeToTextAlpha
    outline[4] = (outline[4] * progress) + (fadeToTextAlpha/2.25)
		
    shaderAlpha = (1.0-progress) * maxShaderAlpha
    nonShaderAlpha = (1.0-progress) * maxNonShaderAlpha
    
    glPushMatrix()
    
	if not shaderProgram then
   		glColor(0, 0, 0, nonShaderAlpha)
    	glRect(0, 0, vsx, vsy)
	end
	  
    glTranslate(-vsx*(usedSizeMultiplier-1)/2, -vsy*(usedSizeMultiplier-1)/2, 0)
    glScale(usedSizeMultiplier,usedSizeMultiplier,1)
	glTranslate((vsx-wndX1) / usedSizeMultiplier * progress, 0, 0)
    
    --draw text
    myFont:Begin()
    myFont:SetOutlineColor(outline)
    myFont:SetTextColor(text)
    myFont:Print("GAME  PAUSED", textX, textY, fontSizeHeadline, "O")
    myFont:End()
    
    glPopMatrix()
end

function updateWindowCoords()
    wndX1 = (vsx / 2) - boxWidth
    wndY1 = (vsy / 2) + boxHeight
    wndX2 = (vsx / 2) + boxWidth
    wndY2 = (vsy / 2) - boxHeight

    textX = wndX1 + (wndX2 - wndX1) * 0.33
    textY = wndY2 + (wndY1 - wndY2) * 0.4
end

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx, vsy = viewSizeX, viewSizeY
  usedSizeMultiplier = (0.5 + ((vsx*vsy)/5500000)) * sizeMultiplier
  
  updateWindowCoords()
  
  screencopy = gl.CreateTexture(vsx, vsy, {
    border = false,
    min_filter = GL.NEAREST,
    mag_filter = GL.NEAREST,
  })
end

function widget:DrawScreenEffects()
	if not shaderProgram then return end
	if not drawPauseScreen then return end
	
	glCopyToTexture(screencopy, 0, 0, 0, 0, vsx, vsy)
	glTexture(0, screencopy)
	glUseShader(shaderProgram)
	glUniform(alphaLoc, shaderAlpha)
	glTexRect(0,vsy,vsx,0)
	glTexture(0, false)
	glUseShader(0)
end
