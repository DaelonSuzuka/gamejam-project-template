extends Path2D

func dead():
	$PathFollow2D.offset += 10
	if $PathFollow2D.unit_offset == 1:
		$AnimationPlayer.play("Fall")
