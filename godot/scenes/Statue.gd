extends Path2D

export var collision = false

func dead():
	$Tween.interpolate_property($PathFollow2D, "offset", $PathFollow2D.offset, $PathFollow2D.offset+150,1)
	$Tween.start()
#	$PathFollow2D.offset += 80
	yield(get_tree().create_timer(1),"timeout")
	if $PathFollow2D.unit_offset >= 1 and $PathFollow2D/Node2D/StaticBody2D/CollisionShape2D.disabled == true:
		$AnimationPlayer.play("Fall")
	$TypingTarget.global_position = $PathFollow2D/Node2D/Sprite.global_position + Vector2(0,-150)

func _ready() -> void:
	if collision:
		$PathFollow2D/Node2D/StaticBody2D/CollisionShape2D.set_deferred("disabled",false)

