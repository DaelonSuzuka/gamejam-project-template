
# Project Structure

## Top level
The Makefile is use for automating various tasks. In this empty project, it only really has helpers for running the build steps on a remote server for creating an HTML5 export.

The Godot project is in a subfolder to allow placing assets or other tools inside this repository but guarantee that Godot can't see them and try to import them or include them in a build.

# Godot project folder

Todo: overview of project structure

Notable files:

- Main.tscn
- menus/MainMenu.tscn
- menus/PauseMenu.tscn
- player/Player.tscn
- system/Args.gd
- system/Game.gd
- system/Files.gd
- system/InputManager.gd
- system/Scenes.gd
- system/Utils.gd

# Main Systems

## Scene Management

This is designed to always have `Main.tscn` be the "current scene". Use `Game.load_scene()` to change scenes (`get_tree().set_current_scene()` should not be used).

You can launch a scene directly using F6, and the scene management system will automatically load `Main.tscn`, set it as the "current scene", and add the loaded scene as a child of `Main`.

`Game.load_scene()` can accept either a full path to a scene (`res://path/to/file.tscn`), or a scene nickname as defined in `system/Scenes.gd`.

`Game.load_scene()`'s second argument is the name of the spawn point you would like the player to start at. Character spawning is not handled by the scene management system, so this function will not attempt to validate spawn point names.

## Input Management


# API reference
## `Game.gd`

signal scene_changed()

func load_scene(scene_path: String, spawn:='', _continuing=false)

fade_out()

fade_in()

dim()

popup_dialog(object, conversation, options={})

start_dialog(object, conversation, options={})

pause_world()

resume_world()

## `Files.gd`

get_files(path, ext='')

get_all_files(path, ext='', max_depth=2, depth=0, files=[])

save_json(file_name: String, data, auto_prefix:=true)

load_json(file_name: String, auto_prefix:=true)

## `Utils.gd`

pause(node: Node):

resume(node: Node):