using Godot;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;

public class State : Node
{
    protected Node _stateMachine = null;
    protected State _parent = null;
    public bool isActive
    {
        set
        {
            SetIsActive(value);
        }
    }

    private void SetIsActive(bool value)
    {
        isActive = value;
        SetBlockSignals(!value);
    }

    public override void _Ready()
    {
        WaitForParentNode();
    }

    private async void WaitForParentNode()
    {
        await ToSignal(Owner, "ready");

        Node parent = GetParent();

        _stateMachine = GetStateMachine(this);

        if (parent == null) GD.PushError("parent in State is null!");

        if (!(parent.IsInGroup("stateMachine")))
            _parent = GetParent() as State;
    }
    public virtual void UnhandledInput(InputEvent @event)
    {

    }

    public virtual void Process(float delta)
    {

    }

    public virtual void PhysicsProcess(float delta)
    {

    }

    public virtual void Enter(Dictionary<string, object> msg = null)
    {

    }

    public virtual void Exit()
    {

    }

    private Node GetStateMachine(Node node)
    {
        if ((node != null) && !(node.IsInGroup("stateMachine")))
        {
            return GetStateMachine(node.GetParent());
        }
        return node;
    }


}
