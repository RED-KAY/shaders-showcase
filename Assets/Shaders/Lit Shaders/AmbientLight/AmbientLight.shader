Shader "Custom/Lit/Ambient Light" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex AmbientLight_Vertex
				#pragma fragment AmbientLight_Fragment
				#include "AmbientLightPass.hlsl"

			ENDHLSL
		}
	}
}