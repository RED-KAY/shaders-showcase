Shader "Custom/IBL Specular & Fresnel" {
	
	Properties {
		_SkyboxCubeMap ("Cube Map", Cube) = "black" {}
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex IBLSpecular_Fresnel_Vertex
				#pragma fragment IBLSpecular_Fresnel_Fragment
				#include "IBLSpecular_FresnelPass.hlsl"

			ENDHLSL
		}
	}
}