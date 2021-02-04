using Godot;
using System;

public class Label : Godot.Label
{
    StateMachine stateMachine = null;

    public override void _Ready() {
        stateMachine = GetNode<StateMachine>("../StateMachine");
        if (stateMachine == null) GD.PushError("statemachine in Label null");
    }

    public void _on_StateMachine_Transitioned(NodePath statePath) {
        Text = statePath;
    }
}
