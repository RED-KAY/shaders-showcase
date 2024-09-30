#ifndef COMMON_CEL_SHADING_PASS_INCLUDED
#define COMMON_CEL_SHADING_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float inverseLerp(float v, float min, float max){
	return (v - min) / (max - min);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax){
	float t = inverseLerp(v, inMin, inMax);
	return lerp(outMin, outMax, t);
}

float3 LinearToSRGB(float3 color)
{
    float3 sRGBLo = color * 12.92;
    float3 sRGBHi = 1.055 * pow(color, 1.0 / 2.4) - 0.055;
    float3 sRGB = lerp(sRGBLo, sRGBHi, step(0.0031308, color));
    return sRGB;
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
	float3 positionWS : VAR_POSITION;
};

Varryings CelShading_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
	OUT.positionWS = positionWS;
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 CelShading_Fragment (Varryings IN) : SV_TARGET {

	float2 uv = IN.uv;
	float3 color = {0,0,0};
	float3 normal = normalize(IN.normalWS);

	float3 baseColor = {0.5, 0.5, 0.5};

	float3 lighting;
	lighting.xyz = 0;

	float3 ambientLighting;
	ambientLighting.xyz = 0.5;

	float3 skyLight = float3(0, 0.3, 0.6);
	float3 groundLight = float3(0.6, 0.3, 0.1);

	float hemiMix = remap(normal.y, -1, 1, 0, 1);
	float3 hemi = lerp(groundLight, skyLight, hemiMix);

	//Lambertian lighting additions
	float3 lightDir = normalize(float3(-0.1, 1, 1));
	float3 lightColor = float3(1, 1, 0.9);
	float dp = max(0, dot(lightDir, normal));

	//Toon Shading
	//dp *= step(0.5, dp);
	//dp *= smoothstep(0.5, 0.505, dp);
	//dp *= smoothstep(smoothstep(1,1, 1-dp), smoothstep(0.6, 0.60, 1-dp), dp);
	dp *= lerp(0.5, 1.0, step(0.65, dp)) * step(0.4, dp);

	float3 diffuse = dp * lightColor;

	//Phong Specular
	float3 viewDir = normalize(_WorldSpaceCameraPos - IN.positionWS);
	float3 r = normalize(reflect(-lightDir, normal));
	float phongValue = max(0, dot(viewDir, r));
	phongValue = pow(abs(phongValue), 128);
	float3 specular = {phongValue, phongValue, phongValue};
	specular = smoothstep(0.5, 0.51, specular);

	//FRESNEl
	float3 fresnel = 1.0 - max(0, dot(viewDir, normal));
	fresnel = pow(fresnel, 2);
	fresnel *= step(0.2, fresnel);

	//Lambertian lighting model
	//lighting += ambientLighting * (fresnel + 0.1) + hemi * (fresnel + 0.3) + diffuse * 1.0;
	lighting += hemi * (fresnel + 0.3) + diffuse * 1.0;

	color = baseColor * lighting  + specular;


	color = LinearToSRGB(color);

	return float4(color, 1);
}

#endif