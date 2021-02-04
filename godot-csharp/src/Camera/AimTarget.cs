using Godot;
using System;

public class AimTarget : Sprite3D
{

    public override void _Ready()
    {
        SetAsToplevel(true);
        Visible = false;
    }

    public void Update(RayCast ray) {
        // update manually instead only once per frame in process
        ray.ForceRaycastUpdate();
        var isColliding = ray.IsColliding();
        Visible = isColliding;

        if (isColliding) {
            Vector3 collisionPoint = ray.GetCollisionPoint();
            Vector3 collisionNormal = ray.GetCollisionNormal();

            var transform = this.GlobalTransform;                        
            transform.origin = collisionPoint + collisionNormal * 0.01f;
            GlobalTransform = transform;

            LookAt(collisionPoint - collisionNormal, GlobalTransform.basis.y.Normalized());
        }
    }


}
