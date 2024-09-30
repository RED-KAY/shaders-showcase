#ifndef COMMON_IBL_SPECULAR_FRESNEL_PASS_INCLUDED
#define COMMON_IBL_SPECULAR_FRESNEL_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURECUBE(_SkyboxCubeMap);
SAMPLER(sampler_SkyboxCubeMap);

CBUFFER_START(UnityPerMaterial)
	float4 _SkyboxCubeMap_ST;
CBUFFER_END

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

half3 BoxProjectedCubemapDirection(half3 reflectionWS, float3 positionWS, float4 cubemapPositionWS, float4 boxMin, float4 boxMax)
{
    // Is this probe using box projection?
    if (cubemapPositionWS.w > 0.0f)
    {
        float3 boxMinMax = (reflectionWS > 0.0f) ? boxMax.xyz : boxMin.xyz;
        half3 rbMinMax = half3(boxMinMax - positionWS) / reflectionWS;

        half fa = half(min(min(rbMinMax.x, rbMinMax.y), rbMinMax.z));

        half3 worldPos = half3(positionWS - cubemapPositionWS.xyz);

        half3 result = worldPos + reflectionWS * fa;
        return result;
    }
    else
    {
        return reflectionWS;
    }
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

Varryings IBLSpecular_Fresnel_Vertex (Attributes IN) {
	Varryings OUT; 
	float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
	OUT.positionHCS = TransformWorldToHClip(positionWS);
	OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
	OUT.positionWS = positionWS;
	OUT.uv = IN.uv;

	return OUT;
}
	
float4 IBLSpecular_Fresnel_Fragment (Varryings IN) : SV_TARGET {

	float2 uv = IN.uv;
	float3 color = {0,0,0};
	float3 normal = normalize(IN.normalWS);

	float3 baseColor = {0.2, 0.0, 0.005};

	float3 lighting;
	lighting.xyz = 0;

	float3 ambientLighting;
	ambientLighting.xyz = 0.5;

	float3 skyLight = float3(0, 0.3, 0.6);
	float3 groundLight = float3(0.6, 0.3, 0.1);

	float hemiMix = remap(normal.y, -1, 1, 0, 1);
	float3 hemi = lerp(groundLight, skyLight, hemiMix);

	//Lambertian lighting additions
	float3 lightDir = normalize(float3(1, 1, 1));
	float3 lightColor = float3(1, 1, 0.9);
	float dp = max(0, dot(lightDir, normal));

	float3 diffuse = dp * lightColor;

	//Lambertian lighting model
	lighting += ambientLighting * 0.1 + hemi * 0.1 + diffuse * 1.0;

	//Phong Specular
	float3 viewDir = normalize(_WorldSpaceCameraPos - IN.positionWS);
	float3 r = normalize(reflect(-lightDir, normal));
	float phongValue = max(0, dot(viewDir, r));
	phongValue = pow(abs(phongValue), 32);
	float3 specular = {phongValue, phongValue, phongValue};

	//IBL SPECULAR
	float3 iblCoord = normalize(reflect(-viewDir, normal));
	float3 iblSample = SAMPLE_TEXTURECUBE(_SkyboxCubeMap, sampler_SkyboxCubeMap, iblCoord).xyz;
	specular += iblSample * 0.1;

	//FRESNEl
	float3 fresnel = 1.0 - max(0, dot(viewDir, normal));
	fresnel = pow(fresnel, 2);
	specular *= fresnel;
	//color = fresnel;

	color = baseColor * lighting  + specular;

	color = LinearToSRGB(color);

	return float4(color, 1);
}

#endif