using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowClearer : MonoBehaviour
{
    public Camera mainCamera;       // The camera that renders the scene
    public RenderTexture maskRT;    // The mask RenderTexture
    //public Material eraseMaterial;  // Material used to draw black footprints
    //public float footprintSize = 0.05f; // relative UV size of the footprint

    void Update()
    {
        // Assume player position in world space is transform.position
        Vector3 worldPos = transform.position;

        // Convert world position to UV coordinates:
        // This depends on how you've mapped your snow sprite to the world.
        // Suppose your snow sprite covers a region from worldMin to worldMax:
        Vector2 worldMin = new Vector2(-5f, -5f);
        Vector2 worldMax = new Vector2(5f, 5f);

        float u = (worldPos.x - worldMin.x) / (worldMax.x - worldMin.x);
        float v = (worldPos.y - worldMin.y) / (worldMax.y - worldMin.y);

        // Create a temporary RenderTexture to draw the footprint
        RenderTexture tempRT = RenderTexture.GetTemporary(maskRT.width, maskRT.height, 0, maskRT.format);
        Graphics.Blit(maskRT, tempRT); // Copy current mask into temp

        //// Set up the eraseMaterial to draw a black circle at UV(u, v)
        //eraseMaterial.SetFloat("_FootprintU", u);
        //eraseMaterial.SetFloat("_FootprintV", v);
        //eraseMaterial.SetFloat("_FootprintSize", footprintSize);

        //// Now Blit from tempRT to maskRT using eraseMaterial (which draws the footprint)
        //Graphics.Blit(tempRT, maskRT, eraseMaterial);
        RenderTexture.ReleaseTemporary(tempRT);
    }
}

