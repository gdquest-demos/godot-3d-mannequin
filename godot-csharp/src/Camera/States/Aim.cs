using Godot;
using System;

public class Aim : CameraState
{
    Tween tween = null;
    [Export]
    float fov = 40.0f;
    [Export]
    Vector3 offsetCamera = new Vector3(0.75f, -0.7f, 0);
    public override void _Ready()
    {
        base._Ready();
        tween = GetNode<Tween>("Tween");
        if (tween == null) GD.PushError("Tween reference not found!");
    }

    public override void UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("toggle_aim"))
        {
            (_stateMachine as StateMachine).TransitionTo("Camera/Default");
        }
        else
        {
            _parent.UnhandledInput(@event);
        }
    }

    public override void Process(float delta)
    {
        _parent.Process(delta);
        cameraRig.aimTarget.Update(cameraRig.aimRay);
    }

    public override void Enter(System.Collections.Generic.Dictionary<string, object> msg = null)
    {
        (_parent as Camera).isAiming = true;
        cameraRig.aimTarget.Visible = true;

        cameraRig.springArm.Translation = cameraRig._positionStart + offsetCamera;

        tween.InterpolateProperty(cameraRig.camera, "fov", cameraRig.camera.Fov, fov, 0.5f, Tween.TransitionType.Quad, Tween.EaseType.Out);
        tween.Start();
    }

    public override void Exit()
    {
        (_parent as Camera).isAiming = false;
        cameraRig.aimTarget.Visible = false;

        cameraRig.springArm.Translation = cameraRig.springArm._positionStart;

        tween.InterpolateProperty(cameraRig.camera, "fov", cameraRig.camera.Fov, (_parent as Camera).fovDefault, 0.5f, Tween.TransitionType.Quad, Tween.EaseType.Out);
        tween.Start();
    }
}
