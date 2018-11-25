Shader "Custom/Peak"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaxHeight("Max peak height", Float) = 1.0
		_PeakBase("Peak width", Range(0, 1)) = 0.5
		_ObjectCenter("Center of object", Vector) = (0, 0, 0, 0)
		_MousePosInWorld("Mouse position in world", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal: NORMAL;
				float4 tangent: TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _ObjectCenter;
			float4 _MousePosInWorld;
			float _MaxHeight;
			float _PeakBase;
			
			v2f vert (appdata v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				//o.vertex += v.normal;


				float3 direction = normalize(_MousePosInWorld.xyz - _ObjectCenter.xyz);

				//float4 newPos = v.vertex;

				float spread = max(0, dot(direction, v.normal));

				//if (spread >= _PeakBase) 
				//{
				float4 newPos = float4((pow(spread, 16) * direction * _MaxHeight), v.vertex.w) + v.vertex;
				//}

				o.vertex = UnityObjectToClipPos(newPos);

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
