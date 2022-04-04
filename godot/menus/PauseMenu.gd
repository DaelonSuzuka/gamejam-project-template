extends CanvasLayer

# ******************************************************************************

onready var ScreenDimEffect = find_node('ScreenDimEffect')
onready var MenuButtons = find_node('MenuButtons')

var active := false

# ******************************************************************************

func _ready():
	if get_tree().get_current_scene() != self:
		MenuButtons.hide()
		$Textures.hide()
		$OptionMenu.hide()

	ScreenDimEffect.hide()

	for btn in MenuButtons.get_children():
		connect_button(btn)

	MenuButtons.get_child(0).grab_focus()

func connect_button(button):
	button.connect('pressed', self, 'pressed', [button])

func open():
	GlobalCanvas.get_node('Eyes').hide()
	Game.pause_world()
	active = true
	MenuButtons.show()
	$Textures.show()
	$OptionMenu.hide()
	# $PressSound.play()
	ScreenDimEffect.show()
	Player.push_menu(self)
	MenuButtons.get_child(0).grab_focus()

func close():
	Game.resume_world()
	active = false
	MenuButtons.hide()
	$Textures.hide()
	$OptionMenu.hide()
	ScreenDimEffect.hide()
	Player.pop_menu()
	GlobalCanvas.get_node('Eyes').show()

# ******************************************************************************

func handle_input(event):
	if event.is_action_pressed("ui_cancel"):
		close()

# ******************************************************************************

func pressed(button):
	match button.name:
		'Resume':
			$MenuClick.play()
			close()
		'Option':
			$MenuClick.play()
			MenuButtons.hide()
			$Textures.hide()
			$OptionMenu.show()
		'Exit':
			$MenuClick.play()
			close()
			Game.load_scene('mainmenu')
