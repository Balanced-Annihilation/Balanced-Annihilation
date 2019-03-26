%%VERTEX_GLOBAL_NAMESPACE%%

uniform mat4 camera;		//ViewMatrix (gl_ModelViewMatrix is ModelMatrix!)
uniform vec3 cameraPos;

//The api_custom_unit_shaders supplies this definition:
#ifdef use_shadows
	uniform mat4 shadowMatrix;
	uniform vec4 shadowParams;
#endif

out Data {
	vec3 worldPos;
	vec3 cameraDir;
	vec2 texCoord;

	#ifdef use_shadows
		vec4 shadowTexCoord;
	#endif

	#ifdef GET_NORMALMAP
		#ifdef HAS_TANGENTS
			mat3 worldTBN;
		#else
			vec3 worldNormal;
		#endif
	#else
		vec3 worldNormal;
	#endif
};

//For a moment pretend we have passed OpenGL 2.0 era
#define modelMatrix gl_ModelViewMatrix			// don't trust the ModelView name, it's modelMatrix in fact
#define viewMatrix camera						// viewMatrix is mat4 uniform supplied by Gadget(?)
#define projectionMatrix gl_ProjectionMatrix	// just because I don't like gl_BlaBla

void main(void)	{
	vec4 modelPos = gl_Vertex;
	vec3 modelNormal = gl_Normal;

	%%VERTEX_PRE_TRANSFORM%%

	#ifdef GET_NORMALMAP
		#ifdef HAS_TANGENTS
			vec3 worldNormalN = normalize(gl_NormalMatrix * modelNormal);
			// The use of gl_MultiTexCoord[5,6] is a hack due to lack of support of proper attributes
			// TexCoord5 and TexCoord6 are defined and filled in engine. See: rts/Rendering/Models/AssParser.cpp
			vec3 modelTangent = gl_MultiTexCoord5.xyz;
			vec3 worldTangent = normalize(vec3(modelMatrix * vec4(modelTangent, 0.0)));

			#if 1 //take modelBitangent from attributes
				vec3 modelBitangent = -gl_MultiTexCoord6.xyz;
				vec3 worldBitangent = normalize(vec3(modelMatrix * vec4(modelBitangent, 0.0)));
			#else //calculate worldBitangent
				#ifdef TBN_REORTHO
					worldTangent = normalize(worldTangent - worldNormalN * dot(worldNormalN, worldTangent));
				#endif

				//vec3 worldBitangent = normalize( cross(worldTangent, worldNormalN) );
				vec3 worldBitangent = normalize( cross(worldNormalN, worldTangent) );
			#endif

			//#ifdef FLIP_BITANGENT
				//worldBitangent = -worldBitangent;
			//#endif

			float handednessSign = sign(dot(cross(worldNormalN, worldTangent), worldBitangent));
			worldTangent = worldTangent * handednessSign;
			worldTBN = mat3(worldTangent, worldBitangent, worldNormalN);
		#else
			worldNormal = gl_NormalMatrix * modelNormal;
		#endif
	#else
		worldNormal = gl_NormalMatrix * modelNormal;
	#endif

	vec4 worldPos4 = modelMatrix * modelPos;
	worldPos = worldPos4.xyz / worldPos4.w; //doesn't make much sense (?)

	#ifdef use_shadows
	shadowTexCoord = shadowMatrix * worldPos4;
		#if 1
			shadowTexCoord.xy = shadowTexCoord.xy + 0.5;
		#else
			shadowTexCoord.xy *= (inversesqrt(abs(shadowTexCoord.xy) + shadowParams.zz) + shadowParams.ww);
			shadowTexCoord.xy += shadowParams.xy;
		#endif
	#endif

	cameraDir = cameraPos - worldPos;

	// TODO: multiply by gl_TextureMatrix[0] ?
	texCoord = gl_MultiTexCoord0.xy;
	#ifdef FLIP_UV
		texCoord.t = 1.0 - texCoord.t;
	#endif

	//TODO:
	// 2) flashlights ?
	// 3) treadoffset ?

	gl_Position = projectionMatrix * (viewMatrix * worldPos4);

	%%VERTEX_POST_TRANSFORM%%
}