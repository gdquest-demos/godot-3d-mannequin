using Godot;
using System;

public class Camera : CameraState
{
   
    [Export]
    public float fovDefault = 70.0f;
    [Export]
    public bool isYInverted = true;
    [Export]
    public float deadZoneBackwards = 0.3f;
    [Export]
    public Vector2 sensivityGamePad = new Vector2(2.5f, 2.5f);
    [Export]
    public Vector2 sensivityMouse = new Vector2(0.1f, 0.1f);
   
    public bool isAiming = false;

    Vector2 _input_relative = Vector2.Zero;
    const float ZOOM_STEP = 0.1f;
    
    public override void _Ready()
    {
        base._Ready();
    }

    public override void Process(float delta)
    {

        // todo: is there a way to make that better
        var transform = cameraRig.Transform;
        transform.origin = new Vector3(cameraRig.player.GlobalTransform.origin + cameraRig._positionStart);
        cameraRig.GlobalTransform = transform;

        Vector2 lookDirection = GetLookDirection();
        Vector3 moveDirection = GetMoveDirection();

        if (_input_relative.Length() > 0.0f)
        {
            UpdateRotation(_input_relative * sensivityMouse * delta);
            _input_relative = Vector2.Zero;
        }

        if (lookDirection.Length() > 0.0f)
        {
            UpdateRotation(lookDirection * sensivityGamePad * delta);
        }

        bool isMovingTowardsCamera = ((
            moveDirection.x >= -deadZoneBackwards) &&
            (moveDirection.x <= deadZoneBackwards));

        if (!isMovingTowardsCamera && !isAiming) {
            AutoRotate(moveDirection);
        }

        // prevent winding
        var rot = cameraRig.Rotation;
        rot.y = Mathf.Wrap(cameraRig.Rotation.y, -Mathf.Pi, Mathf.Pi);
        cameraRig.Rotation = rot;
    }

    public override void UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("zoom_in")) {
            cameraRig.Zoom += ZOOM_STEP;
        }else if (@event.IsActionPressed("zoom_out")) {
            cameraRig.Zoom -= ZOOM_STEP;
        }
        else if ((@event is InputEventMouseMotion) && (Input.GetMouseMode() == Input.MouseMode.Captured))
        {
            _input_relative += (@event as InputEventMouseMotion).Relative;
        }
    }

    void AutoRotate(Vector3 moveDirection) {
        float offset = (cameraRig.player.Rotation.y - cameraRig.Rotation.y);
        float targetAngle = CalculateTargetAngle(offset);        
        var rot = cameraRig.Rotation;
        rot.y = Mathf.Lerp(rot.y, targetAngle, 0.015f);
        cameraRig.Rotation = rot;
    }

    float CalculateTargetAngle(float offset) {
        if (offset > Mathf.Pi) {
            return (cameraRig.player.Rotation.y - 2 * Mathf.Pi);
        } else if (offset < -Mathf.Pi) 
        {
            return (cameraRig.player.Rotation.y + 2 * Mathf.Pi);
        } else
        {
            return cameraRig.player.Rotation.y;
        }
    }

    void UpdateRotation(Vector2 offset)
    {

        // left right rotation
        var rot = cameraRig.Rotation;
        rot.y -= offset.x;
        cameraRig.Rotation = rot;

        // up down rotation
        rot.x += (isYInverted ? (offset.y * -1.0f) : offset.y);
        cameraRig.Rotation = rot;

        // limit camera rotation
        rot.x = Mathf.Clamp(rot.x, -0.75f, 1.25f);
        cameraRig.Rotation = rot;

        // not z rotation
        rot.z = 0.0f;
        cameraRig.Rotation = rot;
    }

    static Vector2 GetLookDirection()
    {
        return new Vector2(
            Input.GetActionStrength("look_right") - Input.GetActionStrength("look_left"),
            Input.GetActionStrength("look_up") - Input.GetActionStrength("look_down")
        );
    }

    static Vector3 GetMoveDirection()
    {
        return new Vector3(
            Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left"),
            0.0f,
            Input.GetActionStrength("move_back") - Input.GetActionStrength("move_front")
            );
    }
}
