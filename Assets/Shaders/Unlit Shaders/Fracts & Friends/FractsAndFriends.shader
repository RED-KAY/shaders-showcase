Shader "Custom/Unlit/Fracts And Friends" {
	
	Properties {
	}
	
	SubShader {

		Tags {"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		
		Pass {
			HLSLPROGRAM
				#pragma vertex FractsAndFriends_Vertex
				#pragma fragment FractsAndFriends_Fragment
				#include "FractsAndFriendsPass.hlsl"

			ENDHLSL
		}
	}
}