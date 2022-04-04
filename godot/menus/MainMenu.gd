extends CanvasLayer

# ******************************************************************************

onready var MenuButtons = find_node('MenuButtons')

# ******************************************************************************

func _ready():
	Player.push_menu(self)
	MenuButtons.hide()

	connect_button($Credits)

	for btn in MenuButtons.get_children():
		connect_button(btn)

	$Start.connect('matched', self, 'pressed', [$Start])

	MenuButtons.get_child(0).grab_focus()

func on_tree_exit():
	Player.pop_menu()

func connect_button(button):
	button.connect('pressed', self, 'pressed', [button])

# ******************************************************************************

func handle_input(event):
	if $CreditsImage.visible:
		if event.pressed and event.action == 'ui_cancel':
			$CreditsImage.hide()
			$Start.active = true

# ******************************************************************************

func pressed(button):
	match button.name:

		'Credits':
			if !$CreditsImage.visible:
				$CreditsImage.show()
				$Start.active = false
			else:
				$CreditsImage.hide()
				$Start.active = true
		'NewGame':
			pass
		'Start':
			MenuButtons.show()
		'DevRoom':
			Player.pop_menu()
			Game.load_scene('devroom')
		'City':
			Player.pop_menu()
			Game.load_scene('city')
		'Countryside':
			Player.pop_menu()
			Game.load_scene('countryside')
		'Beach':
			Player.pop_menu()
			Game.load_scene('beach')
		'Options':
			pass
		'Exit':
			get_tree().quit()
