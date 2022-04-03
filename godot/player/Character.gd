extends KinematicBody2D

# ******************************************************************************

onready var body = $Body
onready var interactors = $Interactors

# ******************************************************************************

func _ready():
	pass

# ******************************************************************************

func enter_world(world: Node):
	if !world.has_node('Spawns/Default'):
		return
	world.add_child(self)

	var spawn_name = 'Default'
	var spawns = world.get_node('Spawns')

	if Game.continuing:
		position = Utils.dict_to_vec(Game.data.position)
		Game.continuing = false
	else:
		if Game.direct_launch:
			if spawns.has_node('Dev'):
				spawn_name = 'Dev'
		if Game.requested_spawn:
			if spawns.has_node(Game.requested_spawn):
				spawn_name = Game.requested_spawn

		position = spawns.get_node(spawn_name).position

	interactors.current_interactable = null
	visible = true

func activate():
	visible = true
	clear_input()

func deactivate():
	visible = false
	clear_input()

# ******************************************************************************

var input_state = {
	'run': false,
	'move_left': false,
	'move_right': false,
	'activate': false,
}

func clear_input():
	for input in input_state:
		input_state[input] = false

func handle_input(event):
	for action in input_state:
		if event.is_action(action):
			input_state[action] = event.pressed

	if event is InputEventKey:
		if event.pressed:
			if event.as_text() == 'F3':
				movement_enabled = !movement_enabled

# ******************************************************************************

var direction := 0
var velocity := Vector2()
var speed := 0.0
var movement_enabled = true
var dead := false

export var gravity = 500
export var walk_speed = 200

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

func _physics_process(delta):
	body.visible = true

	if input_state['activate']:
		input_state['activate'] = false
		interactors.attempt_interaction()

	speed = 1
	if input_state['run']:
		speed += 0.5

	var dir = 0
	if input_state['move_right']:
		dir += 1
	if input_state['move_left']:
		dir -= 1

	if dir != 0:
		body.playing = true
		velocity.x = lerp(velocity.x, dir * walk_speed * speed, acceleration)
	else:
		body.playing = false
		body.frame = 1
		velocity.x = lerp(velocity.x, 0, friction)

	velocity.y += gravity
	if is_on_floor():
		velocity.y = 0

	if movement_enabled:
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true)

	body.scale.x = 0.2 if velocity.x > 0 else -0.2

	var interact_velocity = Vector2()
	interact_velocity.x = velocity.x
	interactors.rotate_interactors(interact_velocity)
	interactors.check_tooltip()
