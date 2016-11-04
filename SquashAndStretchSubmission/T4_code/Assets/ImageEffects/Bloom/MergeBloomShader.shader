﻿Shader "Hidden/MergeBloomShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D_half _MainTex;
			sampler2D_half Blur1Tex;
			sampler2D_half Blur2Tex;
			sampler2D_half Blur3Tex;
			sampler2D Blur4Tex;
			sampler2D _CameraDepthTexture;
			sampler2D_half _CameraMotionVectorsTexture;


			half4 frag (v2f i) : SV_Target
			{
				half4 mainFrag = tex2D(_MainTex, i.uv);
				half4 blurFrag =/*tex2D(Blur1Tex, i.uv) + tex2D(Blur2Tex, i.uv) + tex2D(Blur3Tex, i.uv) +*/ tex2D(Blur4Tex, i.uv);
				half4 col = 1 - (1 - mainFrag) * (1 - blurFrag);// 1 - ((1 - tex2D(_MainTex, i.uv)) *  (1 - (blurFrag)));
				//col.a = 1;
				/*col = tex2D(_CameraDepthTexture, i.uv);
				col.r = DECODE_EYEDEPTH(col.r) / _ProjectionParams.z;
				col.gb = tex2D(_CameraMotionVectorsTexture, i.uv).rg;
				col.gb = 0.5 + col.gb * 0.5;*/

				return col;
			}
			ENDCG
		}
	}
}