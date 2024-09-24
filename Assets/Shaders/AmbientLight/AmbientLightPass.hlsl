#ifndef COMMON_AMBIENT_LIGHT_PASS_INCLUDED
#define COMMON_AMBIENT_LIGHT_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float inverseLerp(float v, float min, float max){
	return (v - min) / (max - min);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax){
	float t = inverseLerp(v, inMin, inMax);
	return lerp(outMin, outMax, t);
}

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
	float3 normalOS : NORMAL;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normalWS : VAR_NORMAL;
};

Varryings AmbientLight_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 AmbientLight_Fragment (Varryings IN) : SV_TARGET {

	float2 uv = IN.uv;
	float3 color = {0,0,0};
	float3 normal = normalize(IN.normalWS);

	float3 baseColor;
	baseColor.xyz = 0.5;

	float3 lighting;
	lighting.xyz = 0;

	float3 ambientLighting;
	ambientLighting.xyz = 0.5;

	float3 skyLight = float3(0, 0.3, 0.6);
	float3 groundLight = float3(0.6, 0.3, 0.1);

	float hemiMix = remap(normal.y, -1, 1, 0, 1);
	float3 hemi = lerp(groundLight, skyLight, hemiMix);

	lighting += ambientLighting + hemi;

	color = baseColor * lighting;

	return float4(color, 1);
}

#endif