function widget:GetInfo()
    return {
        name      = "Screen-Space Ambient Occlusion",
        version	  = 2.0,
        desc      = "Generate ambient occlusion in screen space",
        author    = "ivand",
        date      = "2019",
        license   = "GPL",
        layer     = -1,
        enabled   = false, --true
    }
end

-----------------------------------------------------------------
-- Constants
-----------------------------------------------------------------

local GL_COLOR_ATTACHMENT0_EXT = 0x8CE0
local GL_COLOR_ATTACHMENT1_EXT = 0x8CE1

local GL_R32F = 0x822E
local GL_RGB16F = 0x881B
local GL_RGB32F = 0x8815

local GL_R16_SNORM = 0x8F98
local GL_R8_SNORM = 0x8F94
local GL_RGB8_SNORM = 0x8F96

local GL_RED = 0x1903
local GL_R8 = 0x8229

local GL_RGBA8 = 0x8058
local GL_RGBA16 = 0x805B

local GL_FUNC_ADD = 0x8006
local GL_FUNC_SUBTRACT = 0x800A
local GL_FUNC_REVERSE_SUBTRACT = 0x800B

-----------------------------------------------------------------
-- Configuration Constants
-----------------------------------------------------------------

local SSAO_KERNEL_SIZE = 24
local DOWNSAMPLE = 4
local BLURPASSES = 2

local DEBUG_SSAO = false

-----------------------------------------------------------------
-- Global Variables
-----------------------------------------------------------------

local LuaShader = VFS.Include("LuaRules/Gadgets/Include/LuaShader.lua")

local vsx, vsy, vpx, vpy
local firstTime

local screenQuadList
local screenWideList

local gbuffFuseFBO
local ssaoFBO
--local ssaoBlurFBOs

local gbuffFuseViewPosTex
local gbuffFuseViewNormalTex
local ssaoTex
--local ssaoBlurTexes

local ssaoShader
local gbuffFuseShader

function widget:ViewResize()
	widget:Shutdown()
	widget:Initialize()
end

function widget:Initialize()
	firstTime = true
    vsx, vsy, vpx, vpy = Spring.GetViewGeometry()

	local commonTexOpts = {
		target = GL_TEXTURE_2D,
		border = false,
		min_filter = GL.NEAREST,
		mag_filter = GL.NEAREST,

		wrap_s = GL.CLAMP_TO_EDGE,
		wrap_t = GL.CLAMP_TO_EDGE,
	}

	commonTexOpts.format = GL_RGBA8
	ssaoTex = gl.CreateTexture(vsx / DOWNSAMPLE, vsy / DOWNSAMPLE, commonTexOpts)

	commonTexOpts.format = GL_RGB16F
	gbuffFuseViewPosTex = gl.CreateTexture(vsx, vsy, commonTexOpts)

	commonTexOpts.format = GL_RGB8_SNORM
	gbuffFuseViewNormalTex = gl.CreateTexture(vsx, vsy, commonTexOpts)

	gbuffFuseFBO = gl.CreateFBO({
		color0 = gbuffFuseViewPosTex,
		color1 = gbuffFuseViewNormalTex,
		drawbuffers = {GL_COLOR_ATTACHMENT0_EXT, GL_COLOR_ATTACHMENT1_EXT},
	})
	if not gl.IsValidFBO(gbuffFuseFBO) then
		Spring.Echo("Error1!")
	end

	ssaoFBO = gl.CreateFBO({
		color0 = ssaoTex,
		drawbuffers = {GL_COLOR_ATTACHMENT0_EXT},
	})
	if not gl.IsValidFBO(ssaoFBO) then
		Spring.Echo("Error1!")
	end
	--Spring.Echo(ssaoTex, ssaoFBO)

	local gbuffFuseShaderVert = VFS.LoadFile("LuaUI/Widgets_TAP/shaders/gbuffFuse.vert.glsl")
	local gbuffFuseShaderFrag = VFS.LoadFile("LuaUI/Widgets_TAP/shaders/gbuffFuse.frag.glsl")

	gbuffFuseShaderFrag = gbuffFuseShaderFrag:gsub("###DEPTH_CLIP01###", (Platform.glSupportClipSpaceControl and "1" or "0"))

	gbuffFuseShader = LuaShader({
		vertex = gbuffFuseShaderVert,
		fragment = gbuffFuseShaderFrag,
		uniformInt = {
			-- be consistent with gfx_deferred_rendering.lua
			--	glTexture(0, "$model_gbuffer_normtex")
			--	glTexture(1, "$model_gbuffer_zvaltex")
			--	glTexture(2, "$map_gbuffer_normtex")
			--	glTexture(3, "$map_gbuffer_zvaltex")
			modelNormalTex = 0,
			modelDepthTex = 1,
			mapNormalTex = 2,
			mapDepthTex = 3,
		},
		uniformFloat = {
			viewPortSize = {vsx, vsy},
		},
	}, "SSAO: G-buffer Fuse")
	gbuffFuseShader:Initialize()



	local ssaoShaderVert = VFS.LoadFile("LuaUI/Widgets_TAP/shaders/ssao.vert.glsl")
	local ssaoShaderFrag = VFS.LoadFile("LuaUI/Widgets_TAP/shaders/ssao.frag.glsl")

	ssaoShaderVert = ssaoShaderVert:gsub("###KERNEL_SIZE###", tostring(SSAO_KERNEL_SIZE))
	ssaoShaderFrag = ssaoShaderFrag:gsub("###KERNEL_SIZE###", tostring(SSAO_KERNEL_SIZE))

	ssaoShader = LuaShader({
		vertex = ssaoShaderVert,
		fragment = ssaoShaderFrag,
		uniformInt = {
			viewPosTex = 0,
			viewNormalTex = 1,
		},
		uniformFloat = {
			viewPortSize = {vsx / DOWNSAMPLE, vsy / DOWNSAMPLE},
		},
	}, "SSAO: Processing")
	ssaoShader:Initialize()
end

function widget:DrawWorld()
	gbuffFuseShader:ActivateWith( function ()
		gbuffFuseShader:SetUniformMatrix("invProjMatrix", "projectioninverse")
		gbuffFuseShader:SetUniformMatrix("projMatrix", "projection")
		gbuffFuseShader:SetUniformMatrix("viewMatrix", "view")
	end)

	ssaoShader:ActivateWith( function ()
		ssaoShader:SetUniformMatrix("projMatrix", "projection")
	end)
end

function widget:Shutdown()
	firstTime = nil

	if screenQuadList then
		gl.DeleteList(screenQuadList)
	end

	if screenWideList then
		gl.DeleteList(screenWideList)
	end


	gl.DeleteTexture(ssaoTex)
	gl.DeleteTexture(gbuffFuseViewPosTex)
	gl.DeleteTexture(gbuffFuseViewNormalTex)

	gl.DeleteFBO(ssaoFBO)
	gl.DeleteFBO(gbuffFuseFBO)

	ssaoShader:Finalize()
	gbuffFuseShader:Finalize()
end

function widget:DrawScreenEffects()
	gl.DepthTest(false)
	gl.Blending(false)

	if firstTime then
		screenQuadList = gl.CreateList(gl.TexRect, -1, -1, 1, 1)
		screenWideList = gl.CreateList(gl.TexRect, 0, vsy, vsx, 0)
		firstTime = false
	end

	gl.ActiveFBO(gbuffFuseFBO, function()
		gbuffFuseShader:ActivateWith( function ()

			--gbuffFuseShader:SetUniformMatrix("invProjMatrix", "projectioninverse")
			--gbuffFuseShader:SetUniformMatrix("viewMatrix", "view")

			gl.Texture(0, "$model_gbuffer_normtex")
			gl.Texture(1, "$model_gbuffer_zvaltex")
			gl.Texture(2, "$map_gbuffer_normtex")
			gl.Texture(3, "$map_gbuffer_zvaltex")

			gl.CallList(screenQuadList) -- gl.TexRect(-1, -1, 1, 1)
			--gl.TexRect(-1, -1, 1, 1)

			gl.Texture(0, false)
			gl.Texture(1, false)
			gl.Texture(2, false)
			gl.Texture(3, false)
		end)
	end)

	gl.ActiveFBO(ssaoFBO, function()
		ssaoShader:ActivateWith( function ()
			--ssaoShader:SetUniformMatrix("projMatrix", "projection")

			gl.Texture(0, gbuffFuseViewPosTex)
			gl.Texture(1, gbuffFuseViewNormalTex)
			gl.CallList(screenQuadList) -- gl.TexRect(-1, -1, 1, 1)
			--gl.TexRect(-1, -1, 1, 1)

			gl.Texture(0, false)
			gl.Texture(1, false)
		end)
	end)

	if DEBUG_SSAO then
		gl.Blending(false)
	else
		gl.BlendEquation(GL_FUNC_REVERSE_SUBTRACT)
		--gl.Blending("alpha")
		gl.Blending(true)
		gl.BlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA) --alpha NO pre-multiply
		--gl.BlendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA) --alpha pre-multiply
		--gl.BlendFunc(GL.ZERO, GL.ONE)
	end

	gl.Texture(0, ssaoTex)
	gl.CallList(screenWideList) --gl.TexRect(0, vsy, vsx, 0)

	if not DEBUG_SSAO then
		gl.BlendEquation(GL_FUNC_ADD)
	end

	gl.Texture(0, false)
	gl.Texture(1, false)
	gl.Texture(2, false)
	gl.Texture(3, false)

	gl.Blending(true)
	gl.DepthTest(true)
end