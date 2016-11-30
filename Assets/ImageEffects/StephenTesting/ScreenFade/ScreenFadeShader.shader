﻿Shader "Hidden/ScreenFade"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FadeTex("FadeTexture", 2D) = "white" {}
		_Amount("Amount", Float) = 0.0
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
			
			sampler2D _MainTex;
			sampler2D _FadeTex;
			sampler2D _Amount;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				half4 fadeCol = tex2D(_FadeTex, i.uv);
				col = lerp(col, fadeCol, _Amount);
				return col;
			}
			ENDCG
		}
	}
}
