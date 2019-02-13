 Shader "Custom/GeometryShaderCube" {
	SubShader {
		Tags {"Queue" = "Geometry" "RenderType" = "Opaque"}

        Pass {
			Tags {"LightMode" = "ForwardBase"}
			LOD 100

	        CGPROGRAM
			uniform StructuredBuffer<float3>	points;

			float rotate_x;
			float rotate_y;
			float rotate_z;

	        // シェーダーモデルは5.0を指定
	        // #pragma target 5.0
	        
	        // シェーダー関数を設定 
	        #pragma vertex vert
			#pragma geometry geom
	        #pragma fragment frag
			// #pragma multi_compile_fog
	        
	        #include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

	        struct VSOut {
				fixed4 diff : COLOR0;
				float4 pos : SV_POSITION;
	        };

			float4 ToRotatedPos(float3 pos) {
				float degrad = 3.14159265359 / 1.8;
				float rx = rotate_x * degrad;
				float ry = rotate_y * degrad;
				float rz = rotate_z * degrad;

				float3x3 rotX = { 1, 0, 0, 0, cos(rx), -sin(rx), 0, sin(rx), cos(rx) };
				float3x3 rotY = { cos(ry), 0, sin(ry), 0, 1, 0, -sin(ry), 0, cos(ry) };
				float3x3 rotZ = { cos(rz), -sin(rz), 0, sin(rz), cos(rz), 0, 0, 0, 1 };

				float3 newpos = mul(mul(mul(rotY, rotZ), rotX), pos);
				return float4(newpos * 2.0f, 1);
			}

			fixed4 LigthDiff(float3 normal) {
				half3 worldNormal = UnityObjectToWorldNormal(normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				fixed4 diff = nl * _LightColor0;
				diff.rgb += ShadeSH9(half4(worldNormal, 1));
				return diff;
			}

	        // 頂点シェーダ
			VSOut vert (uint id : SV_VertexID)
	       	{
				VSOut output;
				output.pos = ToRotatedPos(points[id]);
				output.diff = float4(1, 1, 1, 1);
	            return output;
	       	}
	       	
	       	// ジオメトリシェーダ
		   	[maxvertexcount(24)]
		   	void geom(point VSOut input[1], inout TriangleStream<VSOut> outStream)
		   	{
		     	VSOut output;
		      	float4 pos = input[0].pos;
				float scale = 0.8;
		      	
				{
					// 手前
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 0) * scale));
					output.diff = LigthDiff(float3(0, 0, -1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 0) * scale));
					output.diff = LigthDiff(float3(0, 0, -1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 0) * scale));
					output.diff = LigthDiff(float3(0, 0, -1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 0) * scale));
					output.diff = LigthDiff(float3(0, 0, -1));
					outStream.Append(output);
					outStream.RestartStrip();
					// 奥
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 1) * scale));
					output.diff = LigthDiff(float3(0, 0, 1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 1) * scale));
					output.diff = LigthDiff(float3(0, 0, 1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 1) * scale));
					output.diff = LigthDiff(float3(0, 0, 1));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 1) * scale));
					output.diff = LigthDiff(float3(0, 0, 1));
					outStream.Append(output);
					outStream.RestartStrip();
					// 上
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 0) * scale));
					output.diff = LigthDiff(float3(0, 1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 1) * scale));
					output.diff = LigthDiff(float3(0, 1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 0) * scale));
					output.diff = LigthDiff(float3(0, 1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 1) * scale));
					output.diff = LigthDiff(float3(0, 1, 0));
					outStream.Append(output);
					outStream.RestartStrip();
					// 下
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 1) * scale));
					output.diff = LigthDiff(float3(0, -1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 1) * scale));
					output.diff = LigthDiff(float3(0, -1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 0) * scale));
					output.diff = LigthDiff(float3(0, -1, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 0) * scale));
					output.diff = LigthDiff(float3(0, -1, 0));
					outStream.Append(output);
					outStream.RestartStrip();
					// 左
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 0) * scale));
					output.diff = LigthDiff(float3(-1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 0, 1) * scale));
					output.diff = LigthDiff(float3(-1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 0) * scale));
					output.diff = LigthDiff(float3(-1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(0, 1, 1) * scale));
					output.diff = LigthDiff(float3(-1, 0, 0));
					outStream.Append(output);
					outStream.RestartStrip();
					// 右
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 1) * scale));
					output.diff = LigthDiff(float3(1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 1) * scale));
					output.diff = LigthDiff(float3(1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 1, 0) * scale));
					output.diff = LigthDiff(float3(1, 0, 0));
					outStream.Append(output);
					output.pos = mul(UNITY_MATRIX_VP, pos + ToRotatedPos(float3(1, 0, 0) * scale));
					output.diff = LigthDiff(float3(1, 0, 0));
					outStream.Append(output);
					outStream.RestartStrip();
				}
		   	}
			
			// ピクセルシェーダー
	        fixed4 frag (VSOut i) : COLOR
	        {
	        	// 画面座標系のx、yから色を決める
	            return float4(1, 1, 1, 1) * i.diff;
	        }
	         
	        ENDCG
	     } 
     }
 }