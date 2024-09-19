using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Test : MonoBehaviour
{
    private Vector3 bl;
    private Vector3 br;
    private Vector3 tl;
    private Vector3 tr;

    [SerializeField] private Material _shaderMaterial;
    [SerializeField] private float _meshDistanceThreshold;

    private MeshFilter _mf;
    private MeshRenderer _mr;
    private Mesh _mesh;

    [SerializeField] private float _debug;

    private void OnEnable()
    {

        _mf = GetComponent<MeshFilter>();
        _mr = GetComponent<MeshRenderer>();

        _mesh = new Mesh
        {
            name = "Procedural Mesh"
        };

        _mr.material = _shaderMaterial;
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(bl, 1F);

        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(br, 1F);

        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(tl, 1F);

        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(tr, 1F);
    }

    private void Update()
    {

        Camera cam = Camera.main;

        bl = cam.ViewportToWorldPoint(new Vector3(0, 0, cam.farClipPlane));
        br = cam.ViewportToWorldPoint(new Vector3(1, 0, cam.farClipPlane));
        tl = cam.ViewportToWorldPoint(new Vector3(0, 1, cam.farClipPlane));
        tr = cam.ViewportToWorldPoint(new Vector3(1, 1, cam.farClipPlane));

        _mesh.vertices = new[] { bl, br, tl, tr };

        _mesh.normals = new Vector3[] {
            Vector3.back, Vector3.back, Vector3.back, Vector3.back
        };

        //mesh.normals = new Vector3[] {
        //    Vector3.forward, Vector3.forward, Vector3.forward, Vector3.forward
        //};

        _mesh.tangents = new Vector4[] {
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f)
        };

        _mesh.uv = new Vector2[] {
            Vector2.zero, Vector2.right, Vector2.up, Vector2.one
        };

        _mesh.triangles = new int[] {
            0, 2, 1, 1, 2, 3
        };

        _mf.mesh = _mesh;

        transform.position = Vector3.back * (cam.focalLength/10f);
    }
}
