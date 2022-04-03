extends StaticBody2D

func dead():
	$Sprite.texture = load("res://assets/gate_open.png")


func _on_Area2D_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("Break")
