extends Node2D

export (int) var limit_top
export (int) var limit_bottom
export (int) var limit_left
export (int) var limit_right

var checkpoint = "Default"


func _ready() -> void:
	if limit_bottom != 0:
		Player.camera.limit_bottom = limit_bottom
	if limit_top != 0: 
		Player.camera.limit_top = limit_top
	if limit_left != 0: 
		Player.camera.limit_left = limit_left
	if limit_right != 0: 
		Player.camera.limit_right = limit_right


func _on_Checkpoint_body_entered(body: Node) -> void:
	checkpoint = "Checkpoint"
func _on_Checkpoint2_body_entered(body: Node) -> void:
	checkpoint = "Checkpoint2"


func _on_Bridge_breaking():
	pass # Replace with function body.
