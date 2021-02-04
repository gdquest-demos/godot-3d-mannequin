using Godot;
using System;

public class Default : CameraState
{

    public override void _Ready()
    {
        base._Ready();
    }

    public override void UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("toggle_aim")  || @event.IsActionPressed("fire"))
        {
            (_stateMachine as StateMachine).TransitionTo("Camera/Aim");
        }
        else
        {
            _parent.UnhandledInput(@event);
        }
    }

    public override void Process(float delta) {
        _parent.Process(delta);
    }
}
