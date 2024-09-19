#ifndef COMMON_SHADER_FUNCTIONS_PASS_INCLUDED
#define COMMON_SHADER_FUNCTIONS_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Varryings CommonShaderFunctions_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 CommonShaderFunctions_Fragment (Varryings IN) : SV_TARGET {
	float3 color = float3(IN.uv.x, IN.uv.x, IN.uv.x);
	return float4(color, 1);
}

#endif