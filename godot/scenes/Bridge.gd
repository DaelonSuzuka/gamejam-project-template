extends StaticBody2D

func _on_Area2D_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("Break")

func start():
	$AnimationPlayer.play("Break")
