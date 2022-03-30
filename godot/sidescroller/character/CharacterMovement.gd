extends Node2D

# ******************************************************************************

onready var avatar = get_parent()

var gravity = 100

# ******************************************************************************

func calculate_speed() -> float:
	var _speed = 1
	
	if avatar.input_state['run']:
		_speed += 0.25

	return _speed

func calculate_velocity() -> Vector2:
	var vel := Vector2()
	if avatar.input_state['move_left']:
		vel.x = -1
	if avatar.input_state['move_right']:
		vel.x = 1
	return vel.normalized()

# ------------------------------------------------------------------------------

func calculate_direction(vel:Vector2) -> int:
	var dir = 0
	if vel.length() > 0.01:
		dir = (int(8 * vel.angle() / (2 * PI) + 8.5) + 3) % 8
	return dir
