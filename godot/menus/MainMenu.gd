extends CanvasLayer

# ******************************************************************************

onready var MenuButtons = find_node('MenuButtons')

# ******************************************************************************

func _ready():
	if Game.dead_flag:
		Game.dead_flag = false
		return

	Player.push_menu(self)
	MenuButtons.hide()

	connect_button($Credits)

	for btn in MenuButtons.get_children():
		connect_button(btn)

	$Start.connect('matched', self, 'pressed', [$Start])

	MenuButtons.get_child(0).grab_focus()

	call_deferred('hide_eyes')

func hide_eyes():
	Player.camera.follow($'../CameraTarget', Vector2(2.0, 2.0))
	GlobalCanvas.get_node('Eyes').hide()

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
		'Start':
			Player.camera.follow(Player.character, Vector2(3.0, 3.0), .01)
			Player.pop_menu()
			$Credits.hide()
			GlobalCanvas.get_node('Eyes').show()
			# GlobalCanvas.get_node('Eyes').start_tutorial()
