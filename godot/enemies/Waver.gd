extends Node2D

export var type = 1

func _ready() -> void:
	$AnimatedSprite.animation = "idle"+String(type)

func _process(delta: float) -> void:
	if abs(Player.character.global_position.x-global_position.x) < 300:
		$AnimatedSprite.animation = "attack"+String(type)
		if type != 0: $AnimationPlayer.play("Attack")
	else: $AnimatedSprite.animation = "idle"+String(type)

func dead():
	$AnimatedSprite/AnimationPlayer.play("Death")
	yield(get_tree().create_timer(.3), "timeout")
	queue_free()
