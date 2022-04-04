extends Node

func _ready():
	OS.set_window_title('Nightwaker')

	# do not automatically load scene if game was launched via F6
	if Game.direct_launch:
		return

	var scene = 'countryside'
	if Args.scene:
		scene = Args.scene
	Game.load_scene(scene)
