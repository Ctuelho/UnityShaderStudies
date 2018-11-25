using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingleRipple : MonoBehaviour {

    Material _material;

    public float rippleMinDuration = 1.0f;
    public float rippleMaxDuration = 3.0f;

    public float rippleMinLength = 1.0f;
    public float rippleMaxLength = 3.0f;

    public float rippleMinAmp = 1.0f;
    public float rippleMaxAmp = 3.0f;

    public float rippleMinFreq = 1.0f;
    public float rippleMaxFreq = 3.0f;

    public GameObject cursor;
    public GameObject particles;

    public class Riplle
    {
        public float duration;
        public float length;
        public float amp;
        public float freq;
        public Vector3 center;

        public float startDuration;

        public bool dead;

        public Riplle(float d, float l, float a, float f, Vector3 c)
        {
            duration = d;
            length = l;
            amp = a;
            freq = f;
            center = c;
            dead = false;

            startDuration = d;
        }
    }

    private Riplle _ripple;

    // Use this for initialization
    void Start ()
    {
        _material = GetComponent<Renderer>().material;
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                Debug.Log(hit.point);

                var startDuration = Mathf.Max(rippleMinDuration, Random.Range(rippleMinDuration, rippleMaxDuration));
                _ripple = new Riplle(
                        startDuration,
                        Mathf.Max(rippleMinLength, Random.Range(rippleMinLength, rippleMaxLength)),
                        Mathf.Max(rippleMinAmp, Random.Range(rippleMinAmp, rippleMaxAmp)),
                        Mathf.Max(rippleMinFreq, Random.Range(rippleMinFreq, rippleMaxFreq)),
                        hit.point);

                _ripple.center = new Vector3(_ripple.center.x, _ripple.center.y, _ripple.center.z);

                cursor.transform.position = hit.point;

                particles.transform.position = hit.point;
                particles.GetComponent<ParticleSystem>().Play();

            }
        }

        if (_ripple != null)
        {
            _ripple.duration -= Time.deltaTime;

            if (_ripple.duration <= 0)
            {
                _ripple = null;
                _material.SetInt("_Ripple", 0);
                return;
            }

            _material.SetInt("_Ripple", 1);
            _material.SetFloat("_Freq", _ripple.freq);
            _material.SetFloat("_Amp", _ripple.amp);
            _material.SetFloat("_Len", _ripple.length);
            _material.SetVector("_Origin", _ripple.center);
            _material.SetFloat("_Power", _ripple.duration/_ripple.startDuration);

        }

        
    }
}
