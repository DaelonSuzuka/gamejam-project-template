extends Node2D

# ******************************************************************************

onready var inventory: Node = $Inventory
onready var camera: Node = $Camera

var world_avatar = null

# ******************************************************************************

func _ready() -> void:
	InputManager.register(self)
	Game.connect('scene_changed', self, 'scene_changed')

func scene_changed():
	if !Game.world.has_node('Spawns'):
		return

	world_avatar = null

	var spawns = Game.world.get_node('Spawns').get_children()
	
	if 'Iso' in Game.world.name:
		world_avatar = load('res://isometric/character/Character.tscn').instance()
		world_avatar.enter_world(Game.world)
		camera.follow(world_avatar, Vector2(.5, .5))

	if 'Side' in Game.world.name:
		world_avatar = load('res://sidescroller/character/Character.tscn').instance()
		world_avatar.enter_world(Game.world)
		camera.follow(world_avatar, Vector2(.75, .75))

# ******************************************************************************

var menu_stack = []

func push_menu(menu):
	menu_stack.push_front(menu)

func pop_menu():
	menu_stack.pop_front()

# ------------------------------------------------------------------------------

var input_proxy = null

func set_input_proxy(proxy=null) -> void:
	input_proxy = proxy

# ******************************************************************************

func handle_input(event) -> void:
	if Console.Line.has_focus():
		return

	if menu_stack and is_instance_valid(menu_stack[0]):
		if menu_stack[0].has_method('handle_input'):
			menu_stack[0].handle_input(event)
		return

	# this will forcibly remove any input proxy that gets deleted
	# if !is_instance_valid(input_proxy):
	# 	input_proxy = null

	if input_proxy:
		if is_instance_valid(input_proxy):
			if input_proxy.has_method('handle_input'):
				input_proxy.handle_input(event)
		return

	if event.is_action_pressed("ui_cancel"):
		PauseMenu.open()
		return

	if world_avatar:
		world_avatar.handle_input(event)
	# send input to game

# ******************************************************************************

var accepting_clicks := true

func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		accepting_clicks = false

func get_objects_under_mouse():
	var space = get_world_2d().direct_space_state
	var mousePos = get_global_mouse_position()
	var result := []
	for o in space.intersect_point(mousePos, 32, [], 2147483647, true, true):
		result.append(o.collider)
	return result

func get_interactables_under_mouse():
	var objects = get_objects_under_mouse()
	for object in objects:
		if object.has_method('interact'):
			return object
	return null

# ******************************************************************************

var left_click_hold = false

func _input(event):
	if input_proxy:
		return

	if event is InputEventMouseMotion:
		if left_click_hold and accepting_clicks:
			var pos = get_global_mouse_position()
			# click and drag

	if event is InputEventMouseButton:
		if !event.pressed:
			if event.button_index == 1:
				left_click_hold = false
			return
		
		if !accepting_clicks:
			accepting_clicks = true
			return
		if event.button_index == 1:
			left_click_hold = true

			# check if the click is on an interactable
			var object = get_interactables_under_mouse()
			
			# add the click location as a waypoint
			var pos = get_global_mouse_position()
			var force = !Input.is_key_pressed(KEY_SHIFT)
