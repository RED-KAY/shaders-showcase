Shader "Custom/CommonShaderFunctions" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex CommonShaderFunctions_Vertex
				#pragma fragment CommonShaderFunctions_Fragment
				#include "CommonShaderFunctionsPass.hlsl"

			ENDHLSL
		}
	}
}