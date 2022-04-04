extends Node2D

export var type = 1

func _ready() -> void:
	$AnimatedSprite.animation = "idle"+String(type)

func _process(delta: float) -> void:
	if abs(Player.global_position.x-global_position.x) < 1000:
		$AnimatedSprite.animation = "attack"+String(type)
	else: $AnimatedSprite.animation = "idle"+String(type)
	if type != 0: $AnimationPlayer.play("Attack")

func dead():
	queue_free()
