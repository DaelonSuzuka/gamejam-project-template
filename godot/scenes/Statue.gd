extends Path2D

func dead():
	$PathFollow2D.offset += 10
	if $PathFollow2D.unit_offset == 1 and $PathFollow2D/Node2D/StaticBody2D/CollisionShape2D.disabled == true:
		$AnimationPlayer.play("Fall")
