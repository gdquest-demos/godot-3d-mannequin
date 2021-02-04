using Godot;
using System;



public class Mannequiny : Spatial
{
    public enum States
    {
        IDLE, RUN, AIR
    }

    AnimationTree animationTree = null;
    AnimationNodeStateMachinePlayback playback = null;
    AnimationPlayer animationPlayer = null;
    float playbackSpeed = 0.0f;
    Vector3 moveDirection;

       public override void _Ready()
    {
        moveDirection = Vector3.Zero;

        animationTree = GetNode<AnimationTree>("AnimationTree");
        if (animationTree == null)
        {
            GD.PushError("AnimationTree reference is null!");
        }
        else
        {
            animationTree.Active = true;
            playback = animationTree.Get("parameters/playback") as AnimationNodeStateMachinePlayback;
        }
        animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        if (animationPlayer == null) GD.PushError("AnimationPlayer reference is null!");
    }

    public void SetPlaybackSpeed(float speed) {
        playbackSpeed = speed;
        animationPlayer.PlaybackSpeed = speed;
    }

     public void setMoveDirection(Vector3 direction) {
        moveDirection = direction;
        animationTree.Set("parameters/move_ground/blend_position", direction.Length());
    }


    public void TransitionTo(States stateID)
    {
        switch (stateID)
        {
            case States.IDLE:
                playback.Travel("idle");
                break;
            case States.RUN:
                playback.Travel("move_ground");
                break;
            case States.AIR:
                playback.Travel("jump");
                break;
            default:
                playback.Travel("idle");
                break;
        }
    }

}