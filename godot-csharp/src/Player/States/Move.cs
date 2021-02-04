using Godot;
using System.Collections.Generic;

public class Move : PlayerState
{
    public Vector3 velocity = Vector3.Zero;
    public float moveSpeed = 100.0f;
    public Vector3 moveDirection = Vector3.Zero;
    [Export]
    float maxSpeed = 50.0f;    
    [Export]
    float gravity = -80.0f;
    [Export]
    float jumpImpulse = 25.0f;
    public override void _Ready()
    {
        base._Ready();
    }

    public override void UnhandledInput(InputEvent @event) {
        if (@event.IsActionPressed("jump")) {
            
            var msg = new Dictionary<string, object>();
            msg.Add("velocity", velocity);
            msg.Add("jumpImpulse", jumpImpulse);

            (_stateMachine as StateMachine).TransitionTo("Move/Air", msg);
        }
    }

    public override void PhysicsProcess(float delta)
    {
        Vector3 inputDirection = GetInputDirection();

        // only forward direction if player trying to move forward or right
        Vector3 forwards = _player.camera.GlobalTransform.basis.z * inputDirection.z;
        Vector3 right = _player.camera.GlobalTransform.basis.x * inputDirection.x;

        // Get Move Direction relative to the camera
        moveDirection = forwards + right;
        if (moveDirection.Length() > 1.0f)
        {
            moveDirection = moveDirection.Normalized();
        }
        moveDirection.y = 0.0f;

        (_skin as Mannequiny).setMoveDirection(moveDirection);

        // check if player hits key and rotate
        if (moveDirection.Length() > 0.001)
        {
            _player.LookAt(_player.GlobalTransform.origin + moveDirection, Vector3.Up);
        }

        // move character
        velocity = CalculateVelocity(velocity, moveDirection, delta);
        velocity = _player.MoveAndSlide(velocity, Vector3.Up);
    }

    public static Vector3 GetInputDirection()
    {
        return new Vector3(
            Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left"),
            0.0f,
            Input.GetActionStrength("move_back") - Input.GetActionStrength("move_front")
            );
    }

    Vector3 CalculateVelocity(Vector3 velocityCurrent, Vector3 moveDirection, float delta)
    {
        Vector3 velocityNew = velocityCurrent;
        velocityNew = moveDirection * delta * moveSpeed;
        if ( velocityNew.Length() > maxSpeed) {
            velocityNew = velocityNew.Normalized() * maxSpeed;
        }
        // override because start value is 0.0f
        velocityNew.y = velocityCurrent.y + gravity * delta;

        return velocityNew;
    }
}
