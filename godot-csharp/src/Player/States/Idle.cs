using Godot;
using System.Collections.Generic;

public class Idle : PlayerState
{
    public override void _Ready()
    {
        base._Ready();   
    }

    public override void UnhandledInput(InputEvent @event) {
        (_parent as Move).UnhandledInput(@event);
    }
    public override void PhysicsProcess(float delta) {
        (_parent as Move).PhysicsProcess(delta);

        if (_player.IsOnFloor() && (_parent as Move).velocity.Length() > 0.01) {
            (_stateMachine as StateMachine).TransitionTo("Move/Run");
        } else if (!_player.IsOnFloor()) {
            (_stateMachine as StateMachine).TransitionTo("Move/Air");
        }
    }

    public override void Enter(Dictionary<string, object> msg = null) {
        (_parent as Move).velocity = Vector3.Zero;
        (_skin as Mannequiny).TransitionTo(Mannequiny.States.IDLE);
        _parent.Enter(msg);
    }

    public override void Exit() {
        (_parent as Move).Exit();
    }
}
