using Godot;
using System;
using System.Collections.Generic;

public class StateMachine : Node
{

    [Signal]
    delegate void Transitioned(NodePath statePath);
    [Export]
    NodePath initialState = null;
    State state = null;
    String _stateName { get; set; } = "";
    public bool isActive
    {
        get
        {
            return this.isActive;
        }
        set
        {
            SetIsActive(value);
        }
    }

    void SetIsActive(bool value)
    {
        this.isActive = value;
        SetProcess(value);
        SetPhysicsProcess(value);
        SetProcessUnhandledInput(value);
        state.isActive = value;
    }

    public StateMachine()
    {
        AddToGroup("stateMachine");
    }

    public override void _Ready()
    {
        WaitForParentNode();
        
       state = GetNode(initialState) as State;
        if (state == null)
        {
            GD.PushError("initalstate in statemachine is null!");
        }
    }

    private async void WaitForParentNode()
    {
        await ToSignal(Owner, "ready");
        state.Enter();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        state.UnhandledInput(@event);
    }

    public override void _Process(float delta)
    {
        state.Process(delta);
    }

    public override void _PhysicsProcess(float delta)
    {
        state.PhysicsProcess(delta);
    }

    public void TransitionTo(String targetStatePath, Dictionary<string, object> msg = null)
    {
        if (!HasNode(targetStatePath))
            return;

        State targetState = GetNode(targetStatePath) as State;

        state.Exit();
        this.state = targetState;
        state.Enter(msg);
        EmitSignal("Transitioned", targetStatePath);
    }

    public void SetState(State value)
    {
        state = value;
        _stateName = state.Name;
    }
}
