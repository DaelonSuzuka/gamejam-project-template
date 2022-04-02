tool
extends Node2D

# ******************************************************************************

export(NodePath) var left_target
export(String) var left_method
export(String) var left_args
export(NodePath) var right_target
export(String) var right_method
export(String) var right_args

var target = {
	'left': null,
	'right': null,
}
var method = {
	'left': null,
	'right': null,
}
var args = {
	'left': null,
	'right': null,
}

export var length := 1.0 setget set_length
func set_length(value):
	length = value
	$Left/CollisionShape2D.shape.extents.y = 100 * length
	$Right/CollisionShape2D.shape.extents.y = 100 * length

# ******************************************************************************

func _ready():
	$Left.connect('body_entered', self, 'body_entered', ['left'])
	$Left.connect('body_exited', self, 'body_exited', ['left'])
	$Right.connect('body_entered', self, 'body_entered', ['right'])
	$Right.connect('body_exited', self, 'body_exited', ['right'])
	$LeftLabel.visible = Engine.editor_hint
	$RightLabel.visible = Engine.editor_hint

	set_length(length)

	target = {
		'left': left_target,
		'right': right_target,
	}
	method = {
		'left': left_method,
		'right': right_method,
	}
	args = {
		'left': left_args,
		'right': right_args,
	}

func disable():
	$Left.set_collision_layer_bit(0, false)
	$Right.set_collision_layer_bit(0, false)
	$Left.set_collision_mask_bit(0, false)
	$Right.set_collision_mask_bit(0, false)

func enable():
	$Left.set_collision_layer_bit(0, true)
	$Right.set_collision_layer_bit(0, true)
	$Left.set_collision_mask_bit(0, true)
	$Right.set_collision_mask_bit(0, true)

# ******************************************************************************

var dict = {}
	
func body_entered(body, area):
	var path = body.get_path()
	if !(path in dict):
		dict[path] = 0
	dict[path] += 1

func body_exited(body, area):
	var path = body.get_path()
	dict[path] -= 1

	if dict[path] == 0:
		if target[area] and method[area]:
			var node = get_node(target[area])
			if node and node.has_method(method[area]):
				if args[area]:
					node.call(method[area], args[area])
				else:
					node.call(method[area])
