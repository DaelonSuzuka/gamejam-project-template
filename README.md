
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