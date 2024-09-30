Shader "Custom/Unlit/Unlit" {
	
	Properties {
		[MainColor] _BaseColor ("Base Color", Color) = (1,1,1,1)
	}
	
	SubShader {
		
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

		Pass {
			HLSLPROGRAM
				#pragma vertex UnlitPassVertex
				#pragma fragment UnlitPassFragment
				#include "UnlitPass.hlsl"

			ENDHLSL
		}
	}
}