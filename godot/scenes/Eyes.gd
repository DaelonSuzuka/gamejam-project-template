extends Control

# ******************************************************************************

const MAX_CLOSED = 100
export var left_closed := 0
export var right_closed := 0

onready var Left := $Left
onready var Right := $Right

# ******************************************************************************

func _physics_process(delta: float) -> void:
	if left_closed == MAX_CLOSED and right_closed == MAX_CLOSED:
		return
		#death
		#left_closed = 0
		#right_closed = 0

	left_closed += 1
	right_closed += 1

	Left.frame = int(1 + left_closed / 25)
	Right.frame = int(1 + right_closed / 25)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("AwakeLeft"):
		left_closed = max(0, left_closed - 25)
	if event.is_action_pressed("AwakeRight"):
		right_closed = max(0, right_closed - 25)
