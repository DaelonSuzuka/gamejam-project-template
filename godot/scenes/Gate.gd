extends StaticBody2D

func dead():
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("Break")
