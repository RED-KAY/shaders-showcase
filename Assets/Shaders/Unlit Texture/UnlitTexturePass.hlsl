#ifndef CUSTOM_UNLIT_TEXTURE_PASS_INCLUDED
#define CUSTOM_UNLIT_TEXTURE_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

CBUFFER_START(UnityPerMaterial)
	float4 _BaseColor;
	float4 _BaseMap_ST;
CBUFFER_END

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Varryings UnlitTexturePassVertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);

	//OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
	OUT.uv = IN.uv * 2;
	//OUT.uv = float2(1 - OUT.uv.x, 1 - OUT.uv.y);

	return OUT;
}
	
float4 UnlitTexturePassFragment (Varryings IN) : SV_TARGET {
	IN.uv = IN.uv * -1;
	float4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
	color = color * _BaseColor;
	return color;
}

#endif