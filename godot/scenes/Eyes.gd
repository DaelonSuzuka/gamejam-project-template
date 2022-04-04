extends Control

# ******************************************************************************

const MAX_CLOSED = 1000
export var left_closed := 0
export var right_closed := 0
var inc = .5

onready var Left := $Left
onready var Right := $Right

var active := true

# ******************************************************************************

func _physics_process(delta: float) -> void:
	if !visible or !active:
		return

	if left_closed == MAX_CLOSED and right_closed == MAX_CLOSED and not Player.character.dead:
		Player.character.dead()
		left_closed = 0
		right_closed = 0

	left_closed = min(MAX_CLOSED,left_closed+inc)
	right_closed =  min(MAX_CLOSED,right_closed+inc)

	Left.frame = int(1 + left_closed / 250)
	Right.frame = int(1 + right_closed / 250)

	match int(max(Left.frame,Right.frame)):
		0: inc = 20
		1,3: inc = 2
		2,4: inc = 10

func _input(event: InputEvent) -> void:
	if !visible or !active:
		return

	if event.is_action_pressed("AwakeLeft"):
		left_closed = max(0, left_closed - 250)
	if event.is_action_pressed("AwakeRight"):
		right_closed = max(0, right_closed - 250)


