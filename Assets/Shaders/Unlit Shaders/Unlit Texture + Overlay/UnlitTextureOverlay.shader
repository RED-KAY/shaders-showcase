Shader "Custom/UnlitTexture + Overlay" {
	
	Properties {
		[MainColor]		_BaseColor ("Base Color", Color) = (1,1,1,1)
		[MainTexture]	_BaseMap ("Main Texture", 2D) = "white" {}
						_Overlay ("Overlay Texture", 2D) = "white" {}
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex UnlitTextureOverlayPassVertex
				#pragma fragment UnlitTextureOverlayPassFragment
				#include "UnlitTextureOverlayPass.hlsl"

			ENDHLSL
		}
	}
}