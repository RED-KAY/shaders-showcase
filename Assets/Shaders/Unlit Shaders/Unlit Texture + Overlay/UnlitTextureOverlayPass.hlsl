#ifndef CUSTOM_UNLIT_TEXTURE_OVERLAY_PASS_INCLUDED
#define CUSTOM_UNLIT_TEXTURE_OVERLAY_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

TEXTURE2D(_Overlay);
SAMPLER(sampler_Overlay);

CBUFFER_START(UnityPerMaterial)
	float4 _BaseColor;
	float4 _BaseMap_ST;
	float4 _Overlay_ST;
CBUFFER_END

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Varryings UnlitTextureOverlayPassVertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);

	//OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 UnlitTextureOverlayPassFragment (Varryings IN) : SV_TARGET {
	float4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
	float4 overlay = SAMPLE_TEXTURE2D(_Overlay, sampler_Overlay, IN.uv);
	color = color * _BaseColor;
	return lerp(color, overlay, overlay.w);
}

#endif