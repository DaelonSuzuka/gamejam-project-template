extends KinematicBody2D

# ******************************************************************************

onready var body = $Body

var direction := 0
var velocity := Vector2()
var speed := 0.0
var movement_enabled = true
var dead := false

export var walk_speed = 200
var dir = 0

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

func _ready() -> void:
	randomize()

func _physics_process(delta):
	var distance = Player.global_position.x-global_position.x
	var spotted = (distance < 1000)


	if spotted: speed = 2
	else: speed = 1

	if spotted: sign(distance)
	else: dir = [0,-dir,dir,dir,dir,dir][randi()%6]

	if dir != 0:
		body.playing = true
		velocity.x = lerp(velocity.x, dir * walk_speed * speed, acceleration)
	else:
		body.playing = false
		velocity.x = lerp(velocity.x, 0, friction)

	if movement_enabled:
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true)

	body.scale.x = 0.2 if velocity.x > 0 else -0.2

func dead():
	queue_free()
