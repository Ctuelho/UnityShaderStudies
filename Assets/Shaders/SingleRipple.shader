Shader "Custom/SingleRipple"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		_Freq("Frequence", float) = 1
		_Amp("Amplitude", float) = 1
		_Len("Length", float) = 1
		_Origin("Wave origin", vector) = (0, 0, 0, 0)
		_Ripple("If 0 won't do anything", int) = 0
		_Power("Intensity of the ripple", float) = 0

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
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
				float4 tangent: TANGENT;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 changeColor : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _Freq;
			float _Amp;
			float _Len;
			float4 _Origin;
			int _Ripple;
			float _Power;
			
			float4 getNewVertex(float4 p, float dist)
			{
				
				dist = (dist % _Len) / _Len;
				p.y = _Amp * abs(sin(_Time.y * 3.14 * _Freq + 3.14 * dist));
				return p;
			}

			float distanceOnSphere(float radius, float3 p1, float3 p2) 
			{
				//float pi = 3.14f;
				float l = (p1.x * p2.x) + (p1.y * p2.y) + (p1.z * p2.z);
				l = l / (radius * radius);
				float dist = radius * acos(l);
				return dist;
			}

			v2f vert (appdata v)
			{
				v2f o;

				float4 posInWorld = UnityObjectToClipPos(v.vertex);
				float4 newPos = v.vertex;
				//float dist = distance(posInWorld, _Origin.xyz);
					
				float dist = distanceOnSphere(0.5, newPos.xyz, _Origin.xyz);
				//float dist = distanceOnSphere(0.5, posInWorld.xyz, _Origin.xyz);

				if (dist > _Len) 
				{
					dist = _Len;
				}

				float normalizedDist = dist / _Len;
				float invertedDist = _Len - dist;

				o.changeColor = float4(invertedDist, 0, 0, 1);

				newPos += float4(v.normal * pow(_Power, 6) * (_Amp * abs(sin(_Time.y * 3.14 * _Freq + 3.14 * invertedDist))), newPos.w);

				o.vertex = UnityObjectToClipPos(newPos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 col;
				
				col = i.changeColor;

				//col = tex2D(_MainTex, i.uv);

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
