# Changelog #

This document lists the new features, improvements, changes, and bug fixes in each new release of the Open 3D Mannequin.

## Open 3D Mannequin 0.4 ##

### Improvements ###

- The mannequin now smoothly rotates instead of changing direction instantly.

## Open 3D Mannequin 0.3 ##

### New features ###

- Smooth camera zoom in and out using the mouse wheel.
- Added debug panel to monitor object properties. Toggle open with <kbd>TAB</kbd>.


### Improvements ###

- Toggle fullscreen with <kbd>F11</kbd>.
- Improved the light settings for nicer looking shadows.
- The `SpringArm` now projects a capsule to prevent the camera from going below the floor.

### Changes ###

In this release, we mostly refactored and improved the code for future development, but also for the release of our [3D game creation course](https://gdquest.mavenseed.com/courses/code-a-professional-3d-character-with-godot), based on this project.

- Refactored the code
    - Use PI for angles in radians, replace magic values with constants.
    - Removed unused values in the Move state.
    - Removed unused jump delay feature.
    - Changed the `get_look_direction` calculation for correct y inversion.
    - Replaced all docstrings with comment blocks.
    - Use `Vector3.ZERO` constant instead of `Vector3(0, 0, 0)`.
    - Improved encapsulation of code in the Aim state.
    - Renamed input actions to all use action verbs.
    - Moved mouse capture mode code to a game class, improve logic.
    - Simplified camera code, in particular the rotation code.
    - Simplified variables.
    - Simplified and encapsulated the logic for the `AimTarget`.

### Bug fixes ###

- Fixed `SpringArm` not returning to its start position after aiming.
- Fixed type error in the latest Godot 3.2 build.
- Fixed calculating the opposite value for camera Y inversion logic.
- Fixed slow camera movement on monitors with high refresh rates. We now use `_process` instead of `_physics_process` for camera movement.
- Fixed a memory leak in Godot 3.2.

## Known Issues ##

I started refactoring the Zip state, that takes the character to a wall or
ground the player is aiming at. It is not working at the moment.

## Open 3D Mannequin 0.2 ##

### New features ###

- Added analog movement with joysticks and Walk -> Run animation blending.
- Added smooth camera motion.

### Improvements ###

- Re-rigged and re-targeted the character using [AutoRig Pro](https://blendermarket.com/products/auto-rig-pro), getting it down from 100+ joints to 44 after export.
- Improved the animation tree to add an interruptable land animation.
- Reworked lighting for more contrasted visuals.
- Improved default environment to make it easier to work inside the editor.
- Added boilerplate classes to get autocompletion and type checks in state classes.

### Changes ###

- Made animation tree code controllable from the player's state machine, instead of using signals.
- Refactored the code to make it simpler.
- Reorganized files and folders to make the project easier to browse.

### Bug fixes ###

- Fixed the character sometimes playing the fall animation over ridges in the level's collision boxes.
- Fixed the AimTarget blinking on the surface it was projected on.

## Open 3D Mannequin 0.1 ##

This was the initial release of the project

### Features ###

- Camera rig with zoom to aim and auto-rotation features
- Mouse/keyboard and gamepad support
- 10 professional animations
- Extensible as it's based on a Finite State Machine
