using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class GeometryShaderCube : MonoBehaviour
{
    public Shader shader;

    List<Vector3> points;
    Material material;
    ComputeBuffer buffer;

    /// <summary>
    /// 初期化
    /// </summary>
    void OnEnable()
    {
        material = new Material(shader);

        points = new List<Vector3>();
        for (int x = Gui.start; x < Gui.end; x++)
        {
            for (int z = Gui.start; z < Gui.end; z++)
            {
                points.Add(new Vector3(x, 0, z));
            }
        }

        buffer = new ComputeBuffer(points.Count, Marshal.SizeOf(typeof(Vector3)), ComputeBufferType.Default);
    }

    void Update()
    {
        if (points.Count == 0) return;

        var idx = 0;
        for (int x = Gui.start; x < Gui.end; x++)
        {
            for (int z = Gui.start; z < Gui.end; z++)
            {
                var y = Mathf.Sin(Mathf.Sqrt(x * x + z * z) / 10 + Time.realtimeSinceStartup) * 3;
                points[idx] = new Vector3(x, y, z);
                idx++;
            }
        }

        buffer.SetData(points);
        material.SetBuffer("points", buffer);
    }

    void OnDisable()
    {
        points.Clear();
        buffer.Release();
    }

    /// <summary>
    /// レンダリング
    /// </summary>
    void OnRenderObject()
    {
        material.SetPass(0);
        
        Graphics.DrawProcedural(MeshTopology.Points, points.Count);
    }
}
