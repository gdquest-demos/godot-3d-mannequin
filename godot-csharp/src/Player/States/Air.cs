using Godot;
using System.Collections.Generic;

public class Air : PlayerState
{
    public override void _Ready()
    {
        base._Ready();
    }

    public override void PhysicsProcess(float delta)
    {
        (_parent as Move).PhysicsProcess(delta);

        if (_player.IsOnFloor())
        {
            Vector3 inputDirection = Move.GetInputDirection();
            // See if moving then return after fall to run else idle
            if (inputDirection.Length() > 0.001)
            {
                (_stateMachine as StateMachine).TransitionTo("Move/Run");
            }
            else
            {
                (_stateMachine as StateMachine).TransitionTo("Move/Idle");
            }
        }
    }

    public override void Enter(Dictionary<string, object> msg)
    {
        if (msg != null)
        {
            // TODO: maybe change to consts or an enum for dictionary keys for easier use
            if (msg.ContainsKey("velocity") && msg.ContainsKey("jumpImpulse"))
            {
                var v = (Vector3)msg["velocity"];
                var j = (float)msg["jumpImpulse"];
                (_parent as Move).velocity = v + new Vector3(0.0f, j, 0.0f);
            }
        }
        (_skin as Mannequiny).TransitionTo(Mannequiny.States.AIR);
        _parent.Enter(msg);
    }

    public override void Exit()
    {
        (_parent as Move).Exit();
    }
}
