extends Node2D

export var type = 0

func _ready() -> void:
	match type:
		0: $AnimatedSprite.animation = "idle"+String(type)

func _process(delta: float) -> void:
	if abs(Player.global_position.x-global_position.x) < 1000:
		pass
		#attack animation

func dead():
	queue_free()
