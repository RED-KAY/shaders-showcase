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

	float2 uv = IN.uv;
	float3 color = {0.0,0.0,0.0};

	float v1 = step(0.5, uv.x);
	float v2 = uv.x;
	float v3 = smoothstep(0, 1, uv.x);

	float l1 = smoothstep(0, 0.005, abs(uv.y - 0.33));
	float l2 = smoothstep(0, 0.005, abs(uv.y - 0.66));

	float step_l = smoothstep(0, 0.005, abs(uv.y - lerp(0.7, 0.96, v1)));
	float linear_l = smoothstep(0, 0.005, abs(uv.y - lerp(0.33, 0.66, v2)));	
	float smoothStep_l = smoothstep(0, 0.005, abs(uv.y - lerp(0, 0.33, v3)));	

	float3 red = {1, 0, 0};
	float3 blue = {0, 0, 1};
	float3 w = {1, 1, 1};

	//Demonstrates step, smooth step & lerp differences using blending between two colors (red & blue).
	if(uv.y > 0.33 && uv.y < 0.66){
		color = lerp(red, blue, uv.x);							//Fills the middle area with a mix of red & blue using linear interpolation.
	}else if (uv.y > 0.0 && uv.y < 0.33){	
		color = lerp(red, blue, smoothstep(0, 1, uv.x));		//Fills the bottom area with a mix between red and blue using smooth step function.
	}else{
		color = lerp(red, blue, step(0.5, uv.x));				//Fills top most area with a blend between red and blue using step funciton.
	}

	//Colors the demo lines with white.
	color = lerp(w, color, l1);
	color = lerp(w, color, l2);
	color = lerp(w, color, linear_l);
	color = lerp(w, color, smoothStep_l);
	color = lerp(w, color, step_l);

	return float4(color, 1);
}

//Just an experimentation with these functions.
//float4 CommonShaderFunctions_Fragment (Varryings IN) : SV_TARGET {

//	float2 uv = IN.uv;
//	float3 color = {0.0,0.0,0.0};

//	float3 red = {1, 0, 0};
//	float3 blue = {0, 0, 1};
//	//color = float3(uv.x, uv.x, uv.x);

//	//float3 v = lerp(red, blue, uv.x);				//lerp(a,b,t) -> Returns a value between `a` & `b` based on `t` as percentage. Eg: lerp(10,20,0.5) -> 15 being 50% between 10 & 20. 
//	//color = v;

//	//float v = step(0.5, uv.x);					//step(a,x) -> Returns 0 if the value or `x` is equal-to or less-than `a` & 1 if `x` is greater than `a`. 
//	//float v = smoothstep(0, 1, uv.x);			    //smoothstep(edge1,edge2,x) -> returns a smooth Hermite interpolation between 0 and 1 if x is in the range [edge1, edge2].
//	//color = float3(v,v,v);
	
//	return float4(color, 1);
//}

#endif