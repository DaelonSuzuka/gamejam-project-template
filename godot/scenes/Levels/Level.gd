extends Node2D

export (int) var limit_top
export (int) var limit_bottom
export (int) var limit_left
export (int) var limit_right

var checkpoint = "Default"


func _on_Checkpoint_area_entered(area: Area2D) -> void:
	checkpoint = area.name
