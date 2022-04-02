extends Node

# ******************************************************************************

signal input_event(event)

var state := {}
var actions := []
var paused := false

# ******************************************************************************

func _ready() -> void:
	for action in InputMap.get_actions():
		state[action] = false
		actions.append(action)

func register(object) -> void:
	if object.has_method('handle_input'):
		connect('input_event', object, 'handle_input')

# ******************************************************************************

func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		paused = true
		for action in actions:
			state[action] = false
			var event = FakeEvent.new(action, false)
			emit_signal('input_event', event)
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		paused = false

# ******************************************************************************

func _input(event):
	if paused:
		return

	for action in actions:
		if event.is_action(action):
			if event.pressed != state[action]:
				state[action] = event.pressed
				var _event = FakeEvent.new(action, state[action])
				emit_signal('input_event', _event)

# ******************************************************************************
	
# this is a dummy class that lets us pretend to send actions across the network
class FakeEvent extends Node:
	var action = ''
	var pressed = false

	func _init(name='', value=false):
		action = name
		pressed = value

	func is_action(name):
		return action == name

	func is_action_pressed(name):
		if action == name:
			return pressed
			
	func is_action_released(name):
		if action == name:
			return !pressed

	func to_dict():
		return {
			'action': action,
			'pressed': pressed,
		}

	func from_dict(dict):
		action = dict.action
		pressed = dict.pressed
		return self

	func from_event(event):
		pass