extends Control

const MAX_CLOSED = 100
export var LeftClosed:int = 0
export var RightClosed:int = 0

func _process(delta: float) -> void:
	if LeftClosed == MAX_CLOSED: return
		#death
		#LeftClosed = 0
		#RightClosed = 0

	LeftClosed += 1
	RightClosed += 1
	$Left.texture = load("res://assets/eyes"+String(1+LeftClosed/25)+".png")
	$Right.texture = load("res://assets/eyes"+String(1+RightClosed/25)+".png")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("AwakeLeft"):
		LeftClosed = max(0,LeftClosed-25)
	if event.is_action_pressed("AwakeRight"):
		RightClosed = max(0,RightClosed-25)
