using UnityEngine;

public class Spin : MonoBehaviour
{
    public float rotationSpeed = 100f;

    void Update()
    {
        // Rotate the object around the world's up axis (Vector3.up)
        transform.RotateAround(transform.position, Vector3.up, rotationSpeed * Time.deltaTime);
    }
}