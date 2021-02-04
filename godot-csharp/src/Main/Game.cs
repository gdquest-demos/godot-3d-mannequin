using Godot;
using System;

public class Game : Node
{
	public override void _Ready()
	{
		Input.SetMouseMode(Input.MouseMode.Captured);       
	}

	public override void _Input(InputEvent @event) {
		
		// Toggle Cursor mode on click on window or escape key

		if (@event.IsActionPressed("click")) {
			if(Input.GetMouseMode() != Input.MouseMode.Captured) {
				Input.SetMouseMode(Input.MouseMode.Captured);
			}
		}

		
		if (@event.IsActionPressed("toggle_mouse_captured"))
		{
			if (Input.GetMouseMode() == Input.MouseMode.Captured) {
				Input.SetMouseMode(Input.MouseMode.Visible);
			} else {
				Input.SetMouseMode(Input.MouseMode.Captured);
			}
			// no other input function should get this
			GetTree().SetInputAsHandled();
		}
	}
}
