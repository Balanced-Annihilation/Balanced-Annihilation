include("keysym.h.lua")
local versionNumber = "1.34"

function widget:GetInfo()
    return {
        name      = "Pause Screen",
        desc      = "Displays an overlay when the game is paused",
        author    = "very_bad_soldier (enhanced by: Floris)",
        date      = "2009.08.16",
        license   = "GNU GPL v2",
        layer     = math.huge,
        enabled   = true
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spGetGameSeconds      = Spring.GetGameSeconds
local spGetMouseState       = Spring.GetMouseState
local spEcho                = Spring.Echo

local spGetGameSpeed         = Spring.GetGameSpeed

local max                    = math.max

local glColor               = gl.Color
local glTexture             = gl.Texture
local glScale                = gl.Scale
local glPopMatrix           = gl.PopMatrix
local glPushMatrix          = gl.PushMatrix
local glTranslate           = gl.Translate
local glBeginEnd            = gl.BeginEnd
local glTexRect             = gl.TexRect
local glLoadFont            = gl.LoadFont
local glDeleteFont            = gl.DeleteFont
local glRect                = gl.Rect
local glLineWidth           = gl.LineWidth
local glDepthTest           = gl.DepthTest

local osClock                = os.clock

----------------------------------------------------------------------------------

-- CONFIGURATION

local sizeMultiplier     = 1
local maxAlpha           = 0.6
local maxShaderAlpha		 = 0.35
local maxNonShaderAlpha  = 0.13			--background alpha when shaders arent availible
local boxWidth           = 200
local boxHeight          = 35
local slideTime          = 0.4
local fadeTime           = 0.22
local fadeToAlpha        = 0
local fadeToTextAlpha    = 0.25
local fontSizeHeadline   = 24
local fontSizeAddon      = 15
local fontPath           = "LuaUI/Fonts/MicrogrammaDBold.ttf"
local autoFadeTime       = 1
local forceHideWindow    = false
--Color config in drawPause function
    
----------------
local vsx, vsy
local myFont
local autoFadeTimestamp = 0
local pauseTimestamp = -10 --start or end of pause
local lastPause = false
local screenCenterX = nil
local screenCenterY = nil
local wndX1 = nil
local wndY1 = nil
local wndX2 = nil
local wndY2 = nil
local textX = nil
local textY = nil
local mouseOverClose = false
local checkedWindowSize = false
local usedSizeMultiplier = 1
local vsx, vsy = Spring.GetWindowGeometry()
local widgetInitTime = osClock()
local previousDrawScreenClock = osClock()
local paused = false


local shaderAlpha = 0

local glColor       = gl.Color
local glTexture     = gl.Texture
local glScale				= gl.Scale
local glPopMatrix   = gl.PopMatrix
local glPushMatrix  = gl.PushMatrix
local glTranslate   = gl.Translate
local glBeginEnd		= gl.BeginEnd
local glTexRect 		= gl.TexRect
local glLoadFont		= gl.LoadFont
local glDeleteFont	= gl.DeleteFont
local glRect				= gl.Rect
local glDepthTest		= gl.DepthTest

local vsx, vsy
local screencopy
local shaderProgram

local glUseShader = gl.UseShader
local glCopyToTexture = gl.CopyToTexture
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glUniform = gl.Uniform
local glGetUniformLocation = gl.GetUniformLocation

--intensity formula based on http://alienryderflex.com/hsp.html
local fragmentShaderSource = {
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


function widget:Initialize()
  vsx, vsy = widgetHandler:GetViewSizes()
  widget:ViewResize(vsx, vsy)
  
  myFont = glLoadFont( fontPath, fontSizeHeadline )
  checkedWindowSize = true
   
   
  local _, _, isPaused = spGetGameSpeed()
  if isPaused then
      paused = true
  end
  
  if gl.CreateShader then
    shaderProgram = gl.CreateShader(
    {
		  fragment = fragmentShaderSource.washed,
		  uniformInt = {
			  screencopy = 0,
			},
		})
  	alphaLoc = glGetUniformLocation(shaderProgram, "alpha")
  else
    Spring.Echo("<Screen Shader>: GLSL not supported.")
  end
  
end

function widget:Shutdown()
  glDeleteFont( myFont )
  if shaderProgram then
    gl.DeleteShader(shaderProgram)
  end
end

function widget:GamePaused(playerID, isGamePaused)
    paused = isGamePaused
end

function widget:DrawScreen()
    local now = osClock()
    local drawScreenDelay = now - previousDrawScreenClock
    previousDrawScreenClock = now
    
    local diffPauseTime = ( now - pauseTimestamp)

    local diffPauseTime = ( now - pauseTimestamp)
    
    if ( ( not paused and lastPause ) or ( paused and not lastPause ) ) then
        --pause switch
        pauseTimestamp = osClock()
        if ( diffPauseTime <= slideTime ) then
            pauseTimestamp = pauseTimestamp - ( slideTime - ( diffPauseTime / slideTime ) * slideTime )
        end
    end
    
    if ( paused and not lastPause ) then
        --new pause
        autoFadeTimestamp = nil
        if widgetInitTime + 5 > now then        -- so if you do /luaui reload when paused, it wont re-animate
            autoFadeTimestamp = now - autoFadeTime
            pauseTimestamp = now - (slideTime + autoFadeTime)
        end
    end
    
    lastPause = paused
    
    if ( paused or ( ( now - pauseTimestamp) <= slideTime ) ) then
    		showPauseScreen = true
        drawPause()
    else
    		showPauseScreen = false
    end
    
    ResetGl()
end


function drawPause()
    local now = osClock()
    local diffPauseTime = ( now - pauseTimestamp)
    
    local text           = { 1.0, 1.0, 1.0, 1.0*maxAlpha }
    local outline        = { 0.0, 0.0, 0.0, 1.0*maxAlpha }     
    
    if paused then 
    	progress = ( now - pauseTimestamp ) / slideTime 
    else
    	progress = 1 - (( now - pauseTimestamp ) / slideTime )
    end
    if progress > 1 then
    	progress = 1
    end
    if progress < 0 then
    	progress = 0
    end
    text[4]			= (text[4] * (1-progress)) + fadeToTextAlpha
    outline[4]	= (outline[4] * (1-progress)) + (fadeToTextAlpha/2.25)
		
    shaderAlpha = progress * maxShaderAlpha
    nonShaderAlpha = progress * maxNonShaderAlpha
    
    glPushMatrix()
    
	  if not shaderProgram then
   		glColor(0,0,0,nonShaderAlpha)
    	glRect( 0, 0, vsx, vsy)
	  end
	  
    glTranslate(-vsx*(usedSizeMultiplier-1)/2,  -vsy*(usedSizeMultiplier-1)/2, 0)
    glScale(usedSizeMultiplier,usedSizeMultiplier,1)
    if ( diffPauseTime <= slideTime ) then
        --we are sliding
        if ( paused ) then
            --sliding in
            glTranslate( (( vsx - wndX1 ) / usedSizeMultiplier) * ( 1.0 - ( diffPauseTime / slideTime ) ), 0, 0)
        else
            --sliding out
            glTranslate( (( vsx - wndX1 ) / usedSizeMultiplier) * ( ( diffPauseTime / slideTime ) ), 0, 0)
        end
    end
    
    --draw text
    myFont:Begin()
    myFont:SetOutlineColor( outline )
    myFont:SetTextColor( text )
    myFont:Print( "GAME  PAUSED", textX, textY, fontSizeHeadline, "O" )
    myFont:End()
    
    glPopMatrix()
    
    ResetGl()
end

function updateWindowCoords()
    screenCenterX = vsx / 2
    screenCenterY = vsy / 2
    wndX1 = screenCenterX - boxWidth
    wndY1 = screenCenterY + boxHeight
    wndX2 = screenCenterX + boxWidth
    wndY2 = screenCenterY - boxHeight

    textX = wndX1 + ( wndX2 - wndX1 ) * 0.33
    textY = wndY2 + ( wndY1 - wndY2 ) * 0.4
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
	if shaderProgram and showPauseScreen then
		glCopyToTexture(screencopy, 0, 0, 0, 0, vsx, vsy)
		glTexture(0, screencopy)
		glUseShader(shaderProgram)
		glUniform(alphaLoc, shaderAlpha)
		glTexRect(0,vsy,vsx,0)
		glTexture(0, false)
		glUseShader(0)
	end
end

function ResetGl()
    glScale(1,1,1)
    glColor( { 1.0, 1.0, 1.0, 1.0 } )
    glLineWidth( 1.0 )
    glDepthTest(false)
    glTexture(false)
end
