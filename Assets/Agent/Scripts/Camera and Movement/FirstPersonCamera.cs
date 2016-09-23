﻿using UnityEngine;
using UnityEngine.Networking;
using System.Collections;

public class FirstPersonCamera : NetworkBehaviour
{

    private Camera playerCamera;
    private Transform playerTransform;

    private Vector2 MouseMovement;
    public float MaxCameraY;
    public float MinCameraY;

    private Quaternion rot;

    // Use this for initialization
    void Start()
    {
        
    }

    // Called on clients for player objects for the local client (only)
    public override void OnStartLocalPlayer()
    {
        MouseMovement = new Vector2(0.0f, 0.0f);

        playerCamera = Camera.main;
        playerTransform = GetComponent<Transform>();
        playerCamera.transform.position = GetComponent<Transform>().position;// + new Vector3(0.0f, 0.5f, 0.0f);
    }



    // Update is called once per frame
    void Update()
    {
        //Fetch mouse movement
        MouseMovement.x += Input.GetAxis("Mouse X");
        MouseMovement.y += Input.GetAxis("Mouse Y");

        MouseMovement.x += Input.GetAxis("GamePad X");
        MouseMovement.y += Input.GetAxis("GamePad Y");

        //Clamp pitch angle
        MouseMovement.y = Mathf.Clamp(MouseMovement.y, MinCameraY, MaxCameraY);

        //Generate rotation quaternion
        rot = Quaternion.Euler(-MouseMovement.y, MouseMovement.x, 0.0f);
        playerCamera.transform.position = GetComponent<Transform>().position;
        playerTransform.rotation = playerCamera.transform.rotation = rot;
    }
}
