using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gui : MonoBehaviour
{
    public static int start = -500;
    public static int end = 500;

    public GameObject GameObject1;
    public GameObject GameObject2;

    public void OnGUI()
    {
        GUI.color = (this.GameObject1.activeSelf) ? Color.white : Color.black;
        var cb1 = GUI.Button(new Rect(Screen.width - 150 - 10, 10, 150, 25), "Geometry(CPU) Shader");
        GUI.color = (this.GameObject2.activeSelf) ? Color.white : Color.black;
        var cb2 = GUI.Button(new Rect(Screen.width - 150 - 10, 40, 150, 25), "Computer Shader");

        if (cb1)
        {
            this.GameObject1.SetActive(true);
            this.GameObject2.SetActive(false);
        }
        else if (cb2)
        {
            this.GameObject1.SetActive(false);
            this.GameObject2.SetActive(true);
        }
    }
}
