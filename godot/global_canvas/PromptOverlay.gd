extends CanvasLayer

# ******************************************************************************

var active = false

func _ready():
	reset_prompts()
	$Prompt.show()
	GlobalCanvas.hide_debug()
	$Prompt.hide()

var limiter = RateLimiter.new(.5)
func _process(delta):
	if active:
		if !limiter.check_time(delta):
			show_prompts()

# ******************************************************************************

func toggle_active():
	active = !active
	show_prompts()

func reset_prompts():
	for child in get_children():
		child.hide()

func show_prompts():
	GlobalCanvas.show_debug()
	# reset_prompts()
	# if active:
	# 	GlobalCanvas.hide_debug()
	# 	if PauseMenu.active:
	# 		$Menu.show()
	# 	elif Player.current_battle:
	# 		if Player.current_battle.ShardWindow.active:
	# 			$ShardWindow.show()
	# 		else:
	# 			$Battle.show()
	# 	elif Network.net_id in AvatarManager.avatars:
	# 		if AvatarManager.avatars[Network.net_id].visible:
	# 			$Overworld.show()
	# 	else:
	# 		$Menu.show()

func _input(event):
	if event.is_action_pressed('toggle_input_prompt'):
		toggle_active()
