Shader "Custom/MultipleRipples"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}		
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM

			uniform int _Length;
			uniform float _Lengths[1];
			uniform float _Amps[1];
			uniform float _Freqs[1];
			float4 _Centers[1];

			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				float4 worldPos = UnityObjectToClipPos(v.vertex);
				float4 finalPos = v.vertex;

				o.color = float4(1, 0, 0, 1);

				if (_Length > 0) 
				{
					//for (int i = 0; i < _Length; i++)
					//{
						
						int i = 0;
						
						//float distanceFromCenter = distance(worldPos, _Centers[i]);
						float distanceFromCenter = 0.5f;
	
						/*if (distanceFromCenter <= _Lengths[i])*/
						if (distanceFromCenter <= 1)
						{
							finalPos += v.normal * 1;

							o.color = float4(0, 1, 0, 1);
						}
						else
						{
							o.color = float4(0, 0, 1, 1);
						}
					//}
				} 
				
				o.vertex = UnityObjectToClipPos(finalPos);;

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = i.color;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
