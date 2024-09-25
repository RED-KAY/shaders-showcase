Shader "Custom/Phong Specular" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex PhongSpecular_Vertex
				#pragma fragment PhongSpecular_Fragment
				#include "PhongSpecularPass.hlsl"

			ENDHLSL
		}
	}
}