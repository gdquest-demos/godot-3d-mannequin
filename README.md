![banner image showing the character in several poses](https://repository-images.githubusercontent.com/199621943/d1716f00-1fe7-11ea-9d26-88ac15f865c7)

Open 3D Mannequin is an Open Source 3d character and character controller for the [Godot game engine](https://godotengine.org/)

⚠ The project only supports Godot version 3.2 and above.

➡ Follow us on [Twitter](https://twitter.com/NathanGDQuest) and [YouTube](https://www.youtube.com/c/gdquest/) for free game creation tutorials, tips, and news! Get one of our [Godot game creation courses](https://gdquest.mavenseed.com/) to support our work on Free Software.

![The mannequin in-game](./images/mannequiny-0.2.png)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->

**Table of Contents**

- [Quick Start Guide](#quick-start-guide)
  - [Controls](#controls)
- [How it works](#how-it-works)
  - [Player](#player)
  - [CameraRig](#camera)
- [Configuration](#configuration)
- [Customization](#customization)
- [Credits](#credits)
- [Support our work](#support-our-work)

<!-- markdown-toc end -->

This is a third person character controller designed to work both with the keyboard and a gamepad. It features a camera that can auto-rotate or that can be controlled with a joystick.

## Quick Start Guide

The 3D Third Person Character Controller is made of two scenes:

- `CameraRig.tscn` - A 3D camera rig with a state machine for aiming
- `Player.tscn` - A `KinematicBody` with a state machine for player movement. Contains an instance of `CameraRig`. It also includes the animated 3D mannequin.

To use the default character, instance `Player` in your game. See `Game.tscn` for an example. In this demo, the obstacles are mesh instances with static body collisions making up a cube world.

### Controls

The game supports both mouse and keyboard, and the gamepad.

## How it works

### Player

The scene that deals with the movement, collision, and logic of the player. The player is a KinematicBody with a capsule collision shape, and the movement logic is within a [Finite State Machine](http://gameprogrammingpatterns.com/state.html).

The scene also holds an instance of the `PlayerMesh` for animation purposes. This scene lives in the `PlayerMesh.tscn` scene. It holds the skeletal rig for the mesh's animation, the 3D model of the body and head sepearately, and the animation tree and player to control the animation workflow of the model. The lot is wrapped up in a spatial node with some logic to transition to which animation based on which state the player is in.

### CameraRig

The scene that deals with the CameraRig movement. It follows the Player in the game, but in code it moves and rotates separately from it. It has a `SpringArm` node to help with preventing collision with level geometry - moving the viewpoint forwards to prevent moving the camera inside geometry. It also has a system that holds the raycast for aiming-mode, and the 3D sprite that is a projected reticule. The logic is held in a finite state machine.

## Configuration

To change the player and the camera's behavior, you need to change properties on the corresponding states in their state machine.

Most of the configuration available for player movement are located on the `Move` state in the Player scene - the player speed and the rotational speed.

The CameraRig has more options. On the main CameraRig state in the CameraRig scene are items like the default field of view, whether Y is inverted, and sensitivity.

In addition, the Aim state allows some finer-tuned changes, like whether the aiming camera is first or third person, and by how much it should be offset over-the-shoulder of the character.

## Customization

While the scenes can be modified extensively with new nodes and raw code, the state machine model allow for some simple, new functionality with relative ease.

As an example, there is the `Extensions` folder which contains additional player states for using the aiming view to fire a hookshot that pulls you towards the reticle. Once those states have been added to the Player's `Move` state, you only need to replace the return statement in Move's `enter` with code like `owner.camera.connect("aim_fired", self, "on_Camera_aim_fired")` and Move's `exit` with code like `owner.camera.disconnect("aim_fired", self, "on_Camera_aim_fired")`

## Animating the character

The source Blender file is available in the [releases tab](releases). The character comes with all its animations. At first glance, it can look like it is lacking a rig.

Instead of a complex rig with many controls, we use ephemeral rigs as seen in Richard Lico's 2018 GDC talk [Animating Quill](https://www.youtube.com/watch?v=u3CzLVpuE4k&t=2011s). To do so, we work with the Blender add-on [Rig on the Fly](https://gitlab.com/dypsloom/rigonthefly/). This allows you to quickly generate a rig and controls adapted to the animation at hand. Once the animation is done, you bake it, and you're done!

## Credits

1. The Godot mannequin is a character made by [Luciano Muñoz](https://twitter.com/lucianomunoz_) In blender 2.80.
1. Godot code by Josh aka [Cheeseness](https://twitter.com/ValiantCheese)
1. Additional code by Francois Belair aka [Razoric480](https://twitter.com/Razoric480)

## Support our work

GDQuest is a social company focused on education and bringing people together around Free Software.

This Free Software is sponsored by our course [Code a Professional 3D Character with Godot](https://gdquest.mavenseed.com/courses/code-a-professional-3d-character-with-godot).

We share **the techniques professionals use to make games** and open source the code for most of our projects on [our GitHub page](https://github.com/GDquest/).

You can:

- Join the community on [Discord](https://discord.gg/dKUX7m3)
- Follow us on [Twitter](https://twitter.com/NathanGDQuest)

## Licenses

This project is dual-licensed:

- The source code is available under the MIT license.
- Art assets (images, audio files) are [CC-By 4.0](https://creativecommons.org/licenses/by/4.0/). You can attribute them to `GDQuest and contributors (https://www.gdquest.com/)`.
