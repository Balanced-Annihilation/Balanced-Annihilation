if (Spring.GetModOptions and (tonumber(Spring.GetModOptions().barmodels) or 0) ~= 0) then

function widget:GetInfo()
	return {
		name      = "Bloom Shader Deferred", --(v0.5)
		desc      = "Light Bloom Shader, simulates overbrightness",
		author    = "Kloot, Beherith",
		date      = "2018-05-13",
		license   = "GPL V2",
		layer     = 100000000000,
		enabled   = true,
	}
end


-- config params
local dbgDraw = 0                -- draw only the bloom-mask? [0 | 1]
local globalBlursizeMult = 1

local glowAmplifier = 0.75            -- intensity multiplier when filtering a glow source fragment [1, n]
local blurAmplifier = 1        -- intensity multiplier when applying a blur pass [1, n] (should be set close to 1)
local drawWorldAlpha = 0.08		-- darken world so bloom doesnt blown-white out the brightest areas too much
local illumThreshold = 0            -- how bright does a fragment need to be before being considered a glow source? [0, 1]

local presets = {
	{
		blursize = 22,	-- gaussian blur iteration blur size
		blurPasses = 1,	-- how many iterations of Gaussian blur should be applied to the glow sources?
		quality = 4,	-- resolution divider
	},
	{
		blursize = 17,
		blurPasses = 2,
		quality = 2,
	},
	{
		blursize = 13,
		blurPasses = 3,
		quality = 2,
	},
}
--quality =1 : 90 fps, 9% memctrler load, 99% shader load
--quality =2 : 113 fps, 57% memctrler load, 99% shader load
--quality =4 : 123 fps, 9% memctrler load, 99% shader load
local qualityPreset = 1
local blursize = presets[qualityPreset].blursize
local blurPasses = presets[qualityPreset].blurPasses
local quality = presets[qualityPreset].quality

	-- non-editables
local vsx = 1                        -- current viewport width
local vsy = 1                        -- current viewport height
local ivsx = 1.0 / vsx
local ivsy = 1.0 / vsy

local debugBrightShader = false


-- shader and texture handles
local blurShaderH71 = nil
local blurShaderV71 = nil

local brightShader = nil
local brightTexture1 = nil
local brightTexture2 = nil

local combineShader = nil

-- speedups
local glGetSun = gl.GetSun

local glCreateTexture = gl.CreateTexture
local glDeleteTexture = gl.DeleteTexture
local glActiveTexture = gl.ActiveTexture
local glCopyToTexture = gl.CopyToTexture
local glRenderToTexture = gl.RenderToTexture
local glTexture = gl.Texture
local glTexRect = gl.TexRect

local glGetShaderLog = gl.GetShaderLog
local glCreateShader = gl.CreateShader
local glDeleteShader = gl.DeleteShader
local glUseShader = gl.UseShader

local glUniformInt = gl.UniformInt
local glUniform = gl.Uniform
local glGetUniformLocation = gl.GetUniformLocation
local glGetActiveUniforms = gl.GetActiveUniforms


-- shader uniform locations
local brightShaderText0Loc = nil
local brightShaderText1Loc = nil
local brightShaderIllumLoc = nil
local brightShaderFragLoc = nil


local blurShaderH71Text0Loc = nil
local blurShaderH71FragLoc = nil
local blurShaderV71Text0Loc = nil
local blurShaderV71FragLoc = nil

local combineShaderDebgDrawLoc = nil
local combineShaderTexture0Loc = nil
local combineShaderTexture1Loc = nil


local hasdeferredmodelrendering = nil

local function SetIllumThreshold()
	local ra, ga, ba = glGetSun("ambient", "unit")
	local rd, gd, bd = glGetSun("diffuse","unit")
	local rs, gs, bs = glGetSun("specular")

	local ambientIntensity  = ra * 0.299 + ga * 0.587 + ba * 0.114
	local diffuseIntensity  = rd * 0.299 + gd * 0.587 + bd * 0.114
	local specularIntensity = rs * 0.299 + gs * 0.587 + bs * 0.114

	illumThreshold = illumThreshold*(0.8 * ambientIntensity) + (0.5 * diffuseIntensity) + (0.1 * specularIntensity)
	illumThreshold = math.min(illumThreshold, 0.8)

	illumThreshold = (0.5 + illumThreshold) / 2
end

local function RemoveMe(msg)
	Spring.Echo(msg)
	widgetHandler:RemoveWidget()
end

local function MakeBloomShaders() 

	if (glDeleteShader) then
		if brightShader ~= nil then glDeleteShader(brightShader or 0) end
		if blurShaderH71 ~= nil then glDeleteShader(blurShaderH71 or 0) end
		if blurShaderV71 ~= nil then glDeleteShader(blurShaderV71 or 0) end
		if combineShader ~= nil then glDeleteShader(combineShader or 0) end
	end
	
	combineShader = glCreateShader({
		fragment = [[
			uniform sampler2D texture0;
			uniform int debugDraw;

			void main(void) {
				vec4 a = texture2D(texture0, gl_TexCoord[0].st);
				if (debugDraw == 1) {
					a.a= 1.0;
				}
				gl_FragColor = a;
			}
		]],
		--while this vertex shader seems to do nothing, it actually does the very important world space to screen space mapping for gl.TexRect!
		vertex = [[

			void main(void)
			{
				gl_TexCoord[0] = gl_MultiTexCoord0;
				gl_Position    = gl_Vertex;
			}
		]],
		uniformInt = { texture0 = 0, debugDraw = 0}
	})

	if (combineShader == nil) then
		RemoveMe("[BloomShader::Initialize] combineShader compilation failed"); print(glGetShaderLog()); return
	end

	-- How about we do linear sampling instead, using the GPU's built in texture fetching linear blur hardware :)
	-- http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/ 
	-- this allows us to get away with 5 texture fetches instead of 9 for our 9 sized kernel!
	 -- TODO:  all this simplification may result in the accumulation of quantizing errors due to the small numbers that get pushed into the BrightTexture

	blurShaderH71 = glCreateShader({
		fragment = "#define inverseRX " .. tostring(ivsx) .. "\n" .. [[
			uniform sampler2D texture0;
			uniform int blursize;
			uniform float fragBlurAmplifier;
			const float invKernelSum = 0.0084; // (1/119)

			void main(void) {
				vec2 texCoors = vec2(gl_TexCoord[0]);
				vec3 newblur;

				newblur  = 10*  texture2D(texture0, texCoors + vec2(-blursize * inverseRX, 0)).rgb;
				newblur += 37*  texture2D(texture0, texCoors + vec2(-(blursize/3.5) * inverseRX, 0)).rgb;
				newblur += 25*  texture2D(texture0, texCoors + vec2(0               , 0)).rgb;
				newblur += 37*  texture2D(texture0, texCoors + vec2( (blursize/3.5) * inverseRX, 0)).rgb;
				newblur += 10*  texture2D(texture0, texCoors + vec2( blursize * inverseRX, 0)).rgb;
				gl_FragColor = vec4(newblur * invKernelSum * fragBlurAmplifier, 1.0);
			}
		]],
		uniformInt = {texture0 = 0, blursize = math.floor(blursize*globalBlursizeMult)},
		uniformFloat = {inverseRX, fragBlurAmplifier}
	})

	if (blurShaderH71 == nil) then
		RemoveMe("[BloomShader::Initialize] blurShaderH71 compilation failed"); Spring.Echo(glGetShaderLog()); return
	end

	blurShaderV71 = glCreateShader({
		fragment = "#define inverseRY " .. tostring(ivsy) .. "\n" .. [[
			uniform sampler2D texture0;
			uniform int blursize;
			uniform float fragBlurAmplifier;
			const float invKernelSum = 0.0084; // (1/119)

			void main(void) {
				vec2 texCoors = vec2(gl_TexCoord[0]);
				vec3 newblur;

				newblur  = 10*  texture2D(texture0, texCoors + vec2(0, -blursize * inverseRY)).rgb;
				newblur += 37*  texture2D(texture0, texCoors + vec2(0, -(blursize/3.5) * inverseRY)).rgb;
				newblur += 25*  texture2D(texture0, texCoors + vec2(0,                         0)).rgb;
				newblur += 37*  texture2D(texture0, texCoors + vec2(0,  (blursize/3.5) * inverseRY)).rgb;
				newblur += 10*  texture2D(texture0, texCoors + vec2(0,  blursize * inverseRY)).rgb;
				gl_FragColor = vec4(newblur * invKernelSum * fragBlurAmplifier, 1.0);
			}
		]],

		uniformInt = {texture0 = 0, blursize = math.floor(blursize*globalBlursizeMult)},
		uniformFloat = {inverseRY, fragBlurAmplifier}
	})

	if (blurShaderV71 == nil) then
		RemoveMe("[BloomShader::Initialize] blurShaderV71 compilation failed"); Spring.Echo(glGetShaderLog()); return
	end

	brightShader = glCreateShader({
		fragment =   [[
			uniform sampler2D modeldiffusetex;
			uniform sampler2D modelspectex;
			uniform float illuminationThreshold;
			uniform float fragGlowAmplifier;

			void main(void) {
				vec2 texCoors = vec2(gl_TexCoord[0]);
				vec3 color = vec3(texture2D(modeldiffusetex, texCoors));
				vec4 model_gbuffer_emittex = texture2D(modelspectex,texCoors);
				//float detectchangedbuffer = clamp(model_gbuffer_emittex.g,0.0,1.0); //this is required because some things overwrite all the buffers, and deferred rendering forces this to 0.0
				//color = color *(1.0 - detectchangedbuffer);
				color += color*model_gbuffer_emittex.r;

				float illum = dot(color, vec3(0.2990, 0.4870, 0.2140)); //adjusted from the real values of  vec3(0.2990, 0.5870, 0.1140)

				if (illum > illuminationThreshold) {
					gl_FragColor = vec4(color*(illum-illuminationThreshold), 1.0) * fragGlowAmplifier;
				} else {
					gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
				}
			}
		]], 

		uniformInt = {modeldiffusetex = 0, modelspectex = 1},
		uniformFloat = {illuminationThreshold, fragGlowAmplifier} --, inverseRX, inverseRY}
	})

	if (brightShader == nil) then
		RemoveMe("[BloomShader::Initialize] brightShader compilation failed"); print(glGetShaderLog()); return
	end



	brightShaderText0Loc = glGetUniformLocation(brightShader, "modeldiffusetex")
	brightShaderText1Loc = glGetUniformLocation(brightShader, "modelspectex")

	brightShaderIllumLoc = glGetUniformLocation(brightShader, "illuminationThreshold")
	brightShaderFragLoc = glGetUniformLocation(brightShader, "fragGlowAmplifier")

	blurShaderH71Text0Loc = glGetUniformLocation(blurShaderH71, "texture0")
	blurShaderH71FragLoc = glGetUniformLocation(blurShaderH71, "fragBlurAmplifier")
	blurShaderV71Text0Loc = glGetUniformLocation(blurShaderV71, "texture0")
	blurShaderV71FragLoc = glGetUniformLocation(blurShaderV71, "fragBlurAmplifier")

	combineShaderDebgDrawLoc = glGetUniformLocation(combineShader, "debugDraw")
	combineShaderTexture0Loc = glGetUniformLocation(combineShader, "texture0")
	-- combineShaderTexture1Loc = glGetUniformLocation(combineShader, "texture1")

end


function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = math.max(4,viewSizeX); ivsx = 1.0 / vsx --we can do /n here!
	vsy = math.max(4,viewSizeY); ivsy = 1.0 / vsy
	qvsx,qvsy = math.floor(vsx/quality), math.floor(vsy/quality)
	glDeleteTexture(brightTexture1 or "")
	glDeleteTexture(brightTexture2 or "")

	brightTexture1 = glCreateTexture(qvsx, qvsy, {
		fbo = true,
		min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
	})
	brightTexture2 = glCreateTexture(qvsx, qvsy, {
		fbo = true,
		min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
	})

	if (brightTexture1 == nil or brightTexture2 == nil) then
		if (brightTexture1 == nil ) then Spring.Echo('brightTexture1 == nil ') end
		if (brightTexture2 == nil ) then Spring.Echo('brightTexture2 == nil ') end
		RemoveMe("[BloomShader::ViewResize] removing widget, bad texture target")
		return
	end
	MakeBloomShaders() --we are gonna reinit the the widget, in order to recompile the shaders with the static IVSX and IVSY values in the blur shaders
end

widget:ViewResize(widgetHandler:GetViewSizes())

SetIllumThreshold()

function loadPreset()
	if presets[qualityPreset] ~= nil then
		blursize = presets[qualityPreset].blursize
		blurPasses = presets[qualityPreset].blurPasses
		quality = presets[qualityPreset].quality
		MakeBloomShaders()
	end
end

function widget:Initialize()

	WG['bloomdeferred'] = {}
	WG['bloomdeferred'].getBrightness = function()
		return glowAmplifier
	end
	WG['bloomdeferred'].setBrightness = function(value)
		glowAmplifier = value
		MakeBloomShaders()
	end
	WG['bloomdeferred'].getBlursize = function()
		return globalBlursizeMult
	end
	WG['bloomdeferred'].setBlursize = function(value)
		globalBlursizeMult = value
		MakeBloomShaders()
	end
	WG['bloomdeferred'].getPreset = function()
		return qualityPreset
	end
	WG['bloomdeferred'].setPreset = function(value)
		qualityPreset = value
		loadPreset()
	end


	if (glCreateShader == nil) then
		RemoveMe("[BloomShader::Initialize] removing widget, no shader support")
		return
	end

	hasdeferredmodelrendering = (Spring.GetConfigString("AllowDeferredModelRendering")=='1')
	if hasdeferredmodelrendering == false then
		RemoveMe("[BloomShader::Initialize] removing widget, AllowDeferredModelRendering is required")
	end
	hasdeferredmaprendering = (Spring.GetConfigString("AllowDeferredMapRendering")=='1')
	if hasdeferredmaprendering == false then
		RemoveMe("[BloomShader::Initialize] removing widget, AllowDeferredMapRendering is required")
	end
	MakeBloomShaders()

end

function widget:Shutdown()

	glDeleteTexture(brightTexture1 or "")

	if (glDeleteShader) then
		if brightShader ~= nil then glDeleteShader(brightShader or 0) end
		if blurShaderH71 ~= nil then glDeleteShader(blurShaderH71 or 0) end
		if blurShaderV71 ~= nil then glDeleteShader(blurShaderV71 or 0) end
		if combineShader ~= nil then glDeleteShader(combineShader or 0) end
	end
end


local function Bloom()
	gl.DepthMask(false)
	gl.Color(1, 1, 1, 1)
 
	glUseShader(brightShader)
		glUniformInt(brightShaderText0Loc, 0)
		glUniformInt(brightShaderText1Loc, 1)
		glUniform(   brightShaderIllumLoc, illumThreshold)
		glUniform(   brightShaderFragLoc, glowAmplifier)
		glTexture(0, "$model_gbuffer_difftex")
		glTexture(1,"$model_gbuffer_emittex")
		glRenderToTexture(brightTexture1, gl.TexRect, -1,1,1,-1)
		glTexture(0, false)
		glTexture(1, false)
	glUseShader(0)

	if not debugBrightShader then
		for i = 1, blurPasses do
			glUseShader(blurShaderH71)
				glUniformInt(blurShaderH71Text0Loc, 0)
				glUniform(blurShaderH71FragLoc, blurAmplifier)
				glTexture(brightTexture1)
				glRenderToTexture(brightTexture2, gl.TexRect, -1,1,1,-1)
				glTexture(false)
			glUseShader(0)

			glUseShader(blurShaderV71)
				glUniformInt(blurShaderV71Text0Loc, 0)
				glUniform(blurShaderV71FragLoc, blurAmplifier)
				glTexture(brightTexture2)
				glRenderToTexture(brightTexture1, gl.TexRect, -1,1,1,-1)
				glTexture(false)
			glUseShader(0)
		end
	end

	if dbgDraw == 0 then
		gl.Blending("alpha_add")
	else
		gl.Blending(GL.ONE, GL.ZERO)
	end

	glUseShader(combineShader)
	glUniformInt(combineShaderDebgDrawLoc, dbgDraw)
	glUniformInt(combineShaderTexture0Loc, 0)
	glTexture(0, brightTexture1)
	gl.TexRect(-1, -1, 1, 1, 0, 0, 1, 1)
	glTexture(0, false)
	glUseShader(0)
	gl.Blending("reset")
	gl.DepthMask(true)
end

local camX, camY, camZ = Spring.GetCameraPosition()
local camDirX,camDirY,camDirZ = Spring.GetCameraDirection()
function widget:Update(dt)
	if drawWorldAlpha <= 0 then return end
	camX, camY, camZ = Spring.GetCameraPosition()
	camDirX,camDirY,camDirZ = Spring.GetCameraDirection()
end

function widget:DrawWorld()
	if drawWorldAlpha <= 0 then return end
	-- darken world so bloom doesnt blown-white out the brightest areas too much
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	gl.PushMatrix()
	gl.Color(0,0,0,drawWorldAlpha*glowAmplifier)
	gl.Translate(camX+(camDirX*360),camY+(camDirY*360),camZ+(camDirZ*360))
	gl.Billboard()
	gl.Rect(-500, -500, 500, 500)
	gl.PopMatrix()
end


function widget:DrawScreenEffects()
	Bloom()
end


function widget:GetConfigData(data)
	savedTable = {}
	savedTable.glowAmplifier = glowAmplifier
	savedTable.qualityPreset = qualityPreset
	savedTable.globalBlursizeMult = globalBlursizeMult
	return savedTable
end

function widget:SetConfigData(data)
	if data.glowAmplifier ~= nil then
		glowAmplifier = data.glowAmplifier
	end
	if data.globalBlursizeMult ~= nil then
		globalBlursizeMult = data.globalBlursizeMult
	end
	if data.qualityPreset ~= nil then
		if presets[data.qualityPreset] ~= nil then
			qualityPreset = data.qualityPreset
			blursize = presets[qualityPreset].blursize
			blurPasses = presets[qualityPreset].blurPasses
			quality = presets[qualityPreset].quality
		end
	end
end


end