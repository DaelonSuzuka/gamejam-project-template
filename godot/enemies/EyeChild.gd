extends KinematicBody2D

# ******************************************************************************

onready var body = $Body

var direction := 0
var velocity := Vector2()
var speed := 0.0
var movement_enabled = true
var dead := false
var gravity = 500

export var walk_speed = 200
var dir = 0

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

func _ready() -> void:
	$Body.animation = "idle"
	randomize()

func _process(delta):
	var distance = Player.character.global_position.x-global_position.x
	var spotted = (Player.character.global_position.distance_to(global_position) < 1000)

	if spotted:
		$Body.animation = "run"
		dir = sign(distance)
		speed = 2
	else:
		$Body.animation = "idle"
		speed = 1
		dir = [0,-dir,dir][randi()%3]

	match int(dir):
		1: $Body.scale.x = -.2
		-1: $Body.scale.x = .2


	if dir != 0: velocity.x = lerp(velocity.x, dir * walk_speed * speed, acceleration)
	else: velocity.x = lerp(velocity.x, 0, friction)

	velocity.y += gravity
	if is_on_floor():
		velocity.y = 0

	if movement_enabled:
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true)

#	body.scale.x = 0.2 if velocity.x > 0 else -0.2

func dead():
	queue_free()
