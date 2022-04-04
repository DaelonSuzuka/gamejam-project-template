extends CanvasLayer

# ******************************************************************************

func _ready():
	for child in $DebugControls.get_children():
		if child is Button:
			child.connect('pressed', self, 'debug_button', [child])

func debug_button(button):
	match button.name:
		'Eyes':
			$Eyes.active = !$Eyes.active
		'Countryside':
			Game.load_scene('countryside')
		'City':
			Game.load_scene('city')
		'Beach':
			Game.load_scene('beach')
		'Forest':
			Game.load_scene('forest')
		'House':
			Game.load_scene('house')

# ******************************************************************************

func show_debug():
	$Debug.show()

func hide_debug():
	$Debug.hide()

# ------------------------------------------------------------------------------

var debug_labels := {}

func debug(name, text):
	if name in debug_labels:
		debug_labels[name].text = text
		return

	var label = $Debug/Spacer.duplicate(true)
	label.text = text
	$Debug.add_child(label)
	debug_labels[name] = label


func start_tutorial():
	$AnimationPlayer.play('EyeTuto')
