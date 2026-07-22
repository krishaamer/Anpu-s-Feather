Shader "AnpusFeather/AnpuUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _Additive ("Additive", Float) = 0
        [Toggle] _Point ("Point", Float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ _ADDITIVE_ON
            #pragma multi_compile __ _POINT_ON
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                // DrawMeshNow + GL.LoadProjectionMatrix — use the GL MVP matrix.
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = i.color;
                #ifdef _POINT_ON
                    float2 d = i.uv * 2.0 - 1.0;
                    float dist = dot(d, d);
                    if (dist > 1.0) discard;
                    col.a *= smoothstep(1.0, 0.2, dist);
                #else
                    fixed4 tex = tex2D(_MainTex, i.uv);
                    col.rgb *= tex.rgb;
                    col.a *= tex.a;
                #endif
                return col;
            }
            ENDCG
        }

        Pass
        {
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ _POINT_ON
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = i.color;
                #ifdef _POINT_ON
                    float2 d = i.uv * 2.0 - 1.0;
                    float dist = dot(d, d);
                    if (dist > 1.0) discard;
                    col.a *= smoothstep(1.0, 0.2, dist);
                #else
                    fixed4 tex = tex2D(_MainTex, i.uv);
                    col.rgb *= tex.rgb;
                    col.a *= tex.a;
                #endif
                return col;
            }
            ENDCG
        }
    }
}
