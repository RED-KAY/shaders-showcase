Shader "Custom/Lit/Cel Shading" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex CelShading_Vertex
				#pragma fragment CelShading_Fragment
				#include "CelShadingPass.hlsl"

			ENDHLSL
		}
	}
}