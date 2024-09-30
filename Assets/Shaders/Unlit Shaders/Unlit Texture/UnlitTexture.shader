Shader "Custom/Unlit/UnlitTexture" {
	
	Properties {
		[MainColor] _BaseColor ("Base Color", Color) = (1,1,1,1)
		[MainTexture] _BaseMap ("Main Texture", 2D) = "white" {}
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex UnlitTexturePassVertex
				#pragma fragment UnlitTexturePassFragment
				#include "UnlitTexturePass.hlsl"

			ENDHLSL
		}
	}
}