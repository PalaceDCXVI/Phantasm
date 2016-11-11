﻿Shader "Hidden/FilmGrainMultShader"
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

			float2 Pack(float2 param)
			{
				return param * 0.5 + 0.5;
			}

			float2 Unpack(float2 param)
			{
				return param + param - 1.0;
			}

			float rand(float2 co)
			{
				return frac(sin(1000.0*dot(co.xy, float2(21.5739, 43.421))) * 617284.3);
			}

			float rand(float co)
			{
				return frac(sin(1000.0 * co) * 617284.3);
			}

			float2 reverseMirrorFlip(float2 input)
			{
				input += 2.0f;
				if ((uint)input.x % 2 == 0)
				{
					input.x = frac(input.x);
				}
				else
				{
					input.x = 1.0-frac(input.x);
				}
				if ((uint)input.y % 2 == 0)
				{
					input.y = frac(input.y);
				}
				else
				{
					input.y = 1.0 - frac(input.y);
				}
				return input;
			}

			float2 BarrelDistortion(float2 texcoord)
			{
				texcoord = Unpack(texcoord);
				float theta = atan2(texcoord.y, texcoord.x);
				float radius = length(texcoord);
				radius = pow(radius, 1.2f);
				texcoord.x = radius * cos(theta);
				texcoord.y = radius * sin(theta);
				return 0.5 * (texcoord + 1.0);
			}



			sampler2D _MainTex;
			sampler2D uScrollingTexture;
			sampler2D uMultTexture;
			
			float uAmount;
			float RandomNumber;

			float2 uScrollAmount;
			float2 uOffsetAmount;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 mirrorFlipUV = reverseMirrorFlip(i.uv + uOffsetAmount);
				//mirrorFlipUV = Distort(mirrorFlipUV);
				//fixed4 col = tex2D(_MainTex, mirrorFlipUV);
				fixed4 col = tex2D(_MainTex, BarrelDistortion(mirrorFlipUV));
				// just invert the colors
				float3 vision;

				float2 RandomNumber2 = RandomNumber.rr;

				//outColor.rgb = mix(outColor.rgb, vec3(rand(vec2(uGrain.x + texcoord.x, uGrain.y + texcoord.y))), uAmount);
				float2 uvRound = floor(i.uv * 100.0f) / 100.0f; 
				uvRound.x = floor(i.uv.x * 177.7f) / 177.7f;
				uvRound.y = floor(i.uv.y * 100.0f) / 100.0f;
				//outColor.rgb = mix(source.rgb, vec3(luminance), uAmount);
				float3 filmGrain;
				filmGrain.x = rand(RandomNumber);
				col.rgb = lerp(col.rgb, 
					float3(rand(RandomNumber + uvRound), rand(RandomNumber + uvRound), rand(RandomNumber + uvRound)),
					uAmount);


				float4 scrollTex = tex2D(uScrollingTexture, mirrorFlipUV + uScrollAmount);
				col.rgb = lerp(col.rgb, scrollTex.rgb, scrollTex.a * uAmount * 1.75) * tex2D(uMultTexture, i.uv);
				//(float2(RandomNumber + i.uv.x, RandomNumber + i.uv.x)
				//col = rand(i.uv);

				return col;

			}
			ENDCG
		}
	}
}
