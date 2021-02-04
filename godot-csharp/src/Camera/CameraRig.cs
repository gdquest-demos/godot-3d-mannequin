using Godot;
using System.Threading.Tasks;

public class CameraRig : Spatial
{
    public RayCast aimRay = null;
    public AimTarget aimTarget = null;
    public InterpolatedCamera camera = null;
    public SpringArm springArm = null;
    public KinematicBody player = null;
    public Vector3 _positionStart;
    float zoom = 0.5f;

    public float Zoom {
        get { return zoom; }
        set { 
            zoom = Mathf.Clamp(value, 0.0f, 1.0f);
            springArm.Zoom = zoom;
        }
    }
    public override void _Ready()
    {
        aimTarget = GetNode<AimTarget>("AimTarget");
        if (aimTarget == null) GD.PushError("AimTarget reference not found!");


        aimRay = GetNode<RayCast>("InterpolatedCamera/AimRay");
        if (aimRay == null) GD.PushError("AimRay reference not found!");

        camera = GetNode<InterpolatedCamera>("InterpolatedCamera");
        if (camera == null) GD.PushError("InterpolatedCamera reference not found!");

        springArm = GetNode<SpringArm>("SpringArm");
        if (springArm == null) GD.PushError("SpringArm reference not found!");

        _positionStart = this.Translation;

        // node transformations only in Global Space
        SetAsToplevel(true);

        WaitForParentNode();
    }

    async void WaitForParentNode()
    {
        await ToSignal(Owner, "ready");
        player = (Owner as KinematicBody);
    }

}
