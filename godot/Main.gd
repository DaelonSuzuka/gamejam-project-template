extends Node

func _ready():
	if Game.direct_launch:
		return

	# start game normally
	OS.set_window_title('Ludum Dare Game')

	var scene = 'mainmenu'
	if Args.scene:
		scene = Args.scene
	Game.load_scene(scene)
