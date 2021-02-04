using Godot;
using System.Collections.Generic;

public class Run : PlayerState
{
    [Export]
    float speedRun = 500.0f;
    [Export]
    float speedSprint = 800.0f;
    public override void _Ready()
    {
        base._Ready();
    }

    public override void UnhandledInput(InputEvent @event)
    {
        _parent.UnhandledInput(@event);
    }
    public override void PhysicsProcess(float delta)
    {
        (_parent as Move).moveSpeed = (Input.IsActionPressed("sprint") ? speedSprint : speedRun);
        (_player.skin as Mannequiny).SetPlaybackSpeed((_parent as Move).moveSpeed / speedRun);
        

        _parent.PhysicsProcess(delta);

        if (_player.IsOnFloor() || _player.IsOnWall())
        {
            if ((_parent as Move).velocity.Length() < 0.01)
            {
                (_stateMachine as StateMachine).TransitionTo("Move/Idle");
            }
        } else {
                (_stateMachine as StateMachine).TransitionTo("Move/Air");
        }
    }

    public override void Enter(Dictionary<string, object> msg = null)
    {
        (_skin as Mannequiny).TransitionTo(Mannequiny.States.RUN);
        _parent.Enter(msg);
    }

    public override void Exit()
    {
        _parent.Exit();
    }
}
