using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class ComputeShaderCube : MonoBehaviour
{
    public Shader drawShader;

    public ComputeShader computeShader;

    ComputeBuffer buffer;
    Material material;
    int CSMain;

    void OnEnable()
    {
        // 頂点を生成
        var points = new List<Vector3>();
        for (int x = Gui.start; x < Gui.end; x++)
            for (int z = Gui.start; z < Gui.end; z++)
                points.Add(new Vector3(x, 0, z));

        // バッファを生成
        buffer = new ComputeBuffer(points.Count, Marshal.SizeOf(typeof(Vector3)), ComputeBufferType.Default);
        buffer.SetData(points);

        // 描画シェーダーにバッファを設定
        material = new Material(drawShader);
        material.SetBuffer("points", buffer);

        // コンピュータシェーダにバッファを設定
        computeShader.SetBuffer(0/*CSMain*/, "bufferXYZ", buffer);
    }

    void Update()
    {
        // コンピュータシェーダで再計算
        this.computeShader.SetFloat("realtimeSinceStartup", Time.realtimeSinceStartup);
        this.computeShader.Dispatch(0/*CSMain*/, 1, 1, 1);
    }

    void OnDisable()
    {
        buffer.Release();
    }

    /// <summary>
    /// 描画シェーダーの実行
    /// </summary>
    void OnRenderObject()
    {
        material.SetPass(0);

        Graphics.DrawProcedural(MeshTopology.Points, buffer.count);
    }
}
