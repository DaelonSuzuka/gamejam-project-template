extends Path2D

export var speed = 10
export var loop = true

func _ready() -> void:
	$PathFollow2D.loop = loop
	set_process(false)

func start():
	$PathFollow2D/Body/Sprite.animation = "Fly"
	set_process(true)

func _process(delta: float) -> void:
	$PathFollow2D.offset += speed
	$TypingTarget.global_position = $PathFollow2D/Body/Area2D/CollisionShape2D.global_position - Vector2(0,50)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug+"):
		start()

func dead():
	$PathFollow2D/Body/Sprite/AnimationPlayerr.play("Death")
	yield(get_tree().create_timer(.3), "timeout")
	queue_free()
