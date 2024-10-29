Shader "Custom/Lit/Cel Shading + Base Color" {
	
	Properties {
		[MainColor] _BaseColor ("Base Color", Color) = (1,1,1,1)
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex CelShadingBaseColor_Vertex
				#pragma fragment CelShadingBaseColor_Fragment
				#include "CelShadingBaseColorPass.hlsl"

			ENDHLSL
		}
	}
}