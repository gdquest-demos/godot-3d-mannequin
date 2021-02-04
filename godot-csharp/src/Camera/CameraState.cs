using Godot;
using System;

public class CameraState : State
{
    protected CameraRig cameraRig = null;

    public override void _Ready()
    {
        base._Ready();
        WaitForParentNode();   
        cameraRig = (Owner as CameraRig);
    }

    async void WaitForParentNode() {
        await ToSignal(Owner, "ready");
    }
}
