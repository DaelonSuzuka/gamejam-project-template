extends Node

# ******************************************************************************

func _ready():
	Console.exec_locals = {
		'Game': Game,
		'Utils': Utils,
		'Player': Player,
	}

	Console.add_command('load_scene', self, 'load_scene')\
		.add_argument('scene', TYPE_STRING)\
		.set_description('Change the currently loaded scene.')\
		.register()

	Console.add_command('color_test', self, 'color_test')\
		.set_description('Prints the colors supported by the console')\
		.register()

	Console.add_command('reset_opened_items', self, 'reset_opened_items')\
		.set_description('Reset all world items')\
		.register()

	Console.add_command('give_item', Player.inventory, 'give_item')\
		.add_argument('shard', TYPE_STRING)\
		.set_description('Add item to player')\
		.register()

	Console.add_command('set_flag', Game, 'set_flag')\
		.add_argument('flag', TYPE_STRING)\
		.add_argument('value', TYPE_BOOL)\
		.set_description('EXPERIMENTAL - change flags')\
		.register()

# ******************************************************************************

var colors = [
	'aqua',
	'black',
	'blue',
	'fuchsia',
	'gray',
	'green',
	'lime',
	'maroon',
	'navy',
	'purple',
	'red',
	'silver',
	'teal',
	'white',
	'yellow',
]

func color_test():
	Console.write_line('Printing test colors')
	for color in colors:
		Console.write_line('[color=%s][%s][/color]' % [color, color])

# ------------------------------------------------------------------------------

func load_scene(scene):
	Game.load_scene(scene)
	Console.toggle_console()

func reset_opened_items():
	Console.write_line('resetting all opened items')
	var prefix = '/root/Main/World/'
	for item in Game.data.opened_items:
		var path = prefix + item
		var obj = get_node(path)
		if obj and obj.has_method('set_opened'):
			obj.set_opened(false)

	Game.data.opened_items.clear()
	Game.save_requested = true
