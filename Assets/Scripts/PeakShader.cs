using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PeakShader : MonoBehaviour {

    public Transform ObjectCenter;

    public Material material;

    private void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if(Physics.Raycast(ray, out hit))
        {
            material.SetVector("_MousePosInWorld", hit.point);
        }

        material.SetVector("_ObjectCenter", ObjectCenter.position);
    }
}
