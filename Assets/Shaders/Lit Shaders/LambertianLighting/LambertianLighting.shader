Shader "Custom/Lambertian Lighting" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex LambertianLighting_Vertex
				#pragma fragment LambertianLighting_Fragment
				#include "LambertianLightingPass.hlsl"

			ENDHLSL
		}
	}
}