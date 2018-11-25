using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MultipleRipples : MonoBehaviour {

    public float rippleMinDuration = 1.0f;
    public float rippleMaxDuration = 3.0f;

    public float rippleMinLength = 1.0f;
    public float rippleMaxLength = 3.0f;

    public float rippleMinAmp = 1.0f;
    public float rippleMaxAmp = 3.0f;

    public float rippleMinFreq = 1.0f;
    public float rippleMaxFreq = 3.0f;

    [SerializeField]
    public class Riplle
    {
        public float duration;
        public float length;
        public float amp;
        public float freq;
        public Vector3 center;

        public bool dead;

        public Riplle(float d, float l, float a, float f, Vector3 c)
        {
            duration = d;
            length = l;
            amp = a;
            freq = f;
            center = c;
            dead = false;
        }
    }

    public Material material;

    [SerializeField]
    public List<Riplle> Ripples;



    // Use this for initialization
    void Start () {
        Ripples = new List<Riplle>();
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                Ripples.Add(
                    new Riplle
                    (
                        Mathf.Max(rippleMinDuration, Random.Range(rippleMinDuration, rippleMaxDuration)),
                        Mathf.Max(rippleMinLength, Random.Range(rippleMinLength, rippleMaxDuration)),
                        Mathf.Max(rippleMinAmp, Random.Range(rippleMinAmp, rippleMaxAmp)),
                        Mathf.Max(rippleMinAmp, Random.Range(rippleMinFreq, rippleMaxFreq)),
                        hit.point
                    )
                );
                Debug.Log("Added ripple with duration");
            }
        }

        var materialProperty = new MaterialPropertyBlock();


        materialProperty.SetInt("_Length", Ripples.Count);


        if (!Ripples.Any())
        {
            GetComponent<Renderer>().SetPropertyBlock(materialProperty);
            return;
        }

        float[] lengths = Ripples.Select(r => r.length).ToArray();
        float[] amps = Ripples.Select(r => r.amp).ToArray();
        float[] freqs = Ripples.Select(r => r.freq).ToArray();
        Vector4[] centers = Ripples.Select(r => new Vector4(r.center.x, r.center.y, r.center.z, 1)).ToArray();

        materialProperty.SetFloatArray("lengths", lengths);
        materialProperty.SetFloatArray("amps", amps);
        materialProperty.SetFloatArray("freqs", freqs);
        materialProperty.SetVectorArray("centers", centers);

        GetComponent<Renderer>().SetPropertyBlock(materialProperty);

        for (int i = 0; i < Ripples.Count; i++)
        {
            if (Ripples[i].dead)
                continue;

            Ripples[i].duration -= Time.deltaTime;

            if (Ripples[i].duration <= 0)
            {
                Ripples[i].dead = true;
                Debug.Log("Ripple died");
            }
                
        }

        //clean from the dead
        Ripples = Ripples.Where(r => !r.dead).ToList();
    }
}
