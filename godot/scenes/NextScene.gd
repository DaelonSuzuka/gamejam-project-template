extends Area2D

export var next:String

func _on_NextScene_body_entered(body: Node) -> void:
	Game.load_scene(next)
