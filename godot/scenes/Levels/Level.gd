extends Node2D

export (int) var limit_top
export (int) var limit_bottom
export (int) var limit_left
export (int) var limit_right

var checkpoint = "Default"


func _on_Checkpoint_body_entered(body: Node) -> void:
	checkpoint = body.name


func _on_Checkpoint2_body_entered(body: Node) -> void:
	checkpoint = body.name
