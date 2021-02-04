using Godot;
using System;

public class Player : KinematicBody
{
	public CameraRig camera = null;
	public Mannequiny skin = null;
	public StateMachine stateMachine = null;
	
	public override void _Ready()
	{
		camera = GetNode<CameraRig>("CameraRig");
		if (camera == null) GD.PushError("CameraRig reference is null!");

		skin = GetNode<Mannequiny>("Mannequiny");
		if (skin == null) GD.PushError("Mannequiny reference is null!");

		stateMachine = GetNode<StateMachine>("StateMachine");
		if (stateMachine == null) GD.PushError("stateMachine reference is null!");
	}
}
