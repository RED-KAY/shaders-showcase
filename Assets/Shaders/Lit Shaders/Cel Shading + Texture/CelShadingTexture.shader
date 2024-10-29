Shader "Custom/Lit/Cel Shading + Texture" {
	
	Properties {
		[MainTexture] _BaseMap("Main Texture", 2D) = "white" {}
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex CelShadingTexture_Vertex
				#pragma fragment CelShadingTexture_Fragment
				#include "CelShadingTexturePass.hlsl"

			ENDHLSL
		}
	}
}