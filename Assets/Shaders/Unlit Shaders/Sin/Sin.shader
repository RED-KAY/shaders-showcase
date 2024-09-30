Shader "Custom/Unlit/Sin" {
	
	Properties {
		[MainTexture] _BaseMap ("Main Texture", 2D) = "white" {}
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex Sin_Vertex
				#pragma fragment Sin_Fragment
				#include "SinPass.hlsl"

			ENDHLSL
		}
	}
}