Shader "Custom/Lit/Toon Shading" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex ToonShading_Vertex
				#pragma fragment ToonShading_Fragment
				#include "ToonShadingPass.hlsl"

			ENDHLSL
		}
	}
}