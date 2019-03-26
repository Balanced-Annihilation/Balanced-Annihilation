return {
	-- Heavily inspired by https://github.com/KhronosGroup/glTF-WebGL-PBR/blob/master/shaders/pbr-vert.glsl
	vertex = VFS.LoadFile("ModelMaterials/Shaders/pbr.vert"),
	fragment = VFS.LoadFile("ModelMaterials/Shaders/pbr.frag"),

	uniformInt = {
		tex0 = 0,
		tex1 = 1,
		tex2 = 2,
		tex3 = 3,
		--tex4 = 4,
		brdfLUT = 5,
		shadowTex = 6,
		irradianceEnvTex = 7,
		specularEnvTex = 8,
	},
	uniformFloat = {
		sunColor = {gl.GetSun("diffuse" ,"unit")},
		shadowDensity = gl.GetSun("shadowDensity" ,"unit"),
	},
	uniformMatrix = {
	},
}