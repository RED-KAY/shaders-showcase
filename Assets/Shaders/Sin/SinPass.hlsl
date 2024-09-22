#ifndef COMMON_SIN_PASS_INCLUDED
#define COMMON_SIN_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

CBUFFER_START(UnityPerMaterial)
	float4 _BaseMap_ST;
CBUFFER_END

float remap(float v, float inMin, float inMax, float outMin, float outMax);
float inverseLerp(float v, float min, float max);

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Varryings Sin_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 Sin_Fragment (Varryings IN) : SV_TARGET {

	float2 uv = IN.uv;
	float3 color = {0.75,0.75,0.75};

	float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);

	float time = _Time.y;
	float speed = 4;

	float t1 = remap(sin(uv.y * 400.0 + time * 10.0), -1.0, 1.0, 0.85, 1.0);
	float t2 = remap(sin(uv.y * 50.0 - time * 2.0), -1.0, 1.0, 0.85, 1.0);
	
	color.xyz = baseMap * t1 * t2;
	return float4(color, 1);
}

float inverseLerp(float v, float min, float max){
	return (v - min) / (max - min);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax){
	float t = inverseLerp(v, inMin, inMax);
	return lerp(outMin, outMax, t);
}

#endif