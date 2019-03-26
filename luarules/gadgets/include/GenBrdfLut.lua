local GL_RG16F = 0x822F
local GL_COLOR_ATTACHMENT0_EXT = 0x8CE0

local function new(class, textureSize, gOption)
	return setmetatable(
	{
		gOption = math.min(math.max(gOption or 3, 1), 4), --clamp between 1 and 3
		textureSize = textureSize or 512,
		brdfShader = nil,
		brdfTexture = nil,
		brdfFBO = nil,
	}, class)
end

local GenBrdfLut = setmetatable({}, {
	__call = function(self, ...) return new(self, ...) end,
	})
GenBrdfLut.__index = GenBrdfLut

function GenBrdfLut:Initialize()
	self.brdfTexture = gl.CreateTexture(self.textureSize, self.textureSize, {
		format = GL_RG16F,
		border = false,
		min_filter = GL.LINEAR,
		mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP_TO_EDGE,
		wrap_t = GL.CLAMP_TO_EDGE,
	})

	if not self.brdfTexture then
		Spring.Echo("GenBrdfLut: [%s] brdfTexture creation error:\n%s")
	end

	self.brdfFBO = gl.CreateFBO({
		color0 = self.brdfTexture,
		drawbuffers = {GL_COLOR_ATTACHMENT0_EXT},
	})

	if not self.brdfFBO then
		Spring.Echo("GenBrdfLut: [%s] FBO creation error:\n%s")
	end

	local fragCode = VFS.LoadFile("Luarules/Gadgets/Shaders/GenBrdfLut.frag")
	fragCode = fragCode:gsub("###G_OPTION###", tostring(self.gOption))

	self.brdfShader = gl.CreateShader({
		vertex = VFS.LoadFile("Luarules/Gadgets/Shaders/GenBrdfLut.vert"),
		fragment = fragCode,
		uniformInt = {
			texSize = {self.textureSize, self.textureSize},
		},
	})

	local shLog = gl.GetShaderLog() or ""

	if not self.brdfShader then
		Spring.Echo(string.format("GenBrdfLut: [%s] shader errors:\n%s", "GenBrdfLut", shLog))
		return false
	elseif shLog ~= "" then
		Spring.Echo(string.format("GenBrdfLut: [%s] shader warnings:\n%s", "GenBrdfLut", shLog))
	end
end

function GenBrdfLut:GetTexture()
	return self.brdfTexture
end

function GenBrdfLut:Execute(saveDebug)
	if gl.IsValidFBO(self.brdfFBO) then
		gl.ActiveShader(self.brdfShader, function ()
			gl.ActiveFBO(self.brdfFBO, function()
				gl.DepthTest(false)
				gl.Blending(false)
				gl.PushPopMatrix(function()
					gl.MatrixMode(GL.PROJECTION); gl.LoadIdentity();
					gl.MatrixMode(GL.MODELVIEW); gl.LoadIdentity();
					gl.TexRect(-1, -1, 1, 1)
				end)
				if saveDebug then
					local gf = Spring.GetGameFrame()
					gl.SaveImage( 0, 0, self.textureSize, self.textureSize, string.format("brdf_%s.png", gf))
				end
			end)
		end)
	end
end

function GenBrdfLut:Finalize()
	gl.DeleteFBO(self.brdfFBO)
	gl.DeleteTexture(self.brdfTexture)
	gl.DeleteShader(self.brdfShader)
end

return GenBrdfLut