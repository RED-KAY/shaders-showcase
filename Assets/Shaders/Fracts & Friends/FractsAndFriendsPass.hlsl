#ifndef COMMON_FRACTS_AND_FRIENDS_PASS_INCLUDED
#define COMMON_FRACTS_AND_FRIENDS_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes{
	float4 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Varryings{
	float4 positionHCS : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Varryings FractsAndFriends_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 FractsAndFriends_Fragment (Varryings IN) : SV_TARGET {

	float2 uv = IN.uv;
	float3 color = {0.75,0.75,0.75};
	float2 resolution = {_ScreenParams.x, _ScreenParams.y};

	float3 red = {1, 0, 0};
	float3 blue = {0, 0, 1};
	float3 w = {1, 1, 1};
	float3 black = {0, 0, 0};
	float3 yellow = {1, 1, 0};

	float2 center = uv - 0.5;
	float2 cell = abs(frac(center * resolution / 100) - 0.5);
	float distToCell = 1 - 2 * max(cell.x, cell.y);

	float cellLine = smoothstep(0, 0.05, distToCell);
	float xAxis = smoothstep(0, 0.0035, abs(uv.x - 0.5));
	float yAxis = smoothstep(0, 0.0035, abs(uv.y - 0.5));

	float2 pos = center * resolution / 100;
	float v1 = pos.x;
	//float v2 = abs(v1);
	//float v2 = floor(v1);
	//float v2 = ceil(v1);
	//float v2 = round(v1);
	float v2 = frac(v1);

	float f1 = smoothstep(0, 0.075, abs(pos.y - v1));
	float f2 = smoothstep(0, 0.075, abs(pos.y - v2));

	//color = cell;
	color = lerp(black, color, cellLine);
	color = lerp(blue, color, xAxis);
	color = lerp(blue, color, yAxis);
	color = lerp(yellow, color, f1);
	color = lerp(red, color, f2);

	return float4(color, 1);
}

#endif