tool
extends Node2D

# ******************************************************************************


export var active := true setget set_active
func set_active(value):
	active = value
	$Hint.visible = active and show_hint

export var show_hint := true setget set_show_hint
func set_show_hint(value):
	show_hint = value
	$Hint.visible = active and show_hint


export var custom_hint := '' setget set_custom_hint
func set_custom_hint(value):
	custom_hint = value
	update_hint()

export var auto_death = true
export var show_word = true setget set_show_word
export var distance = 1000

signal matched()
signal mistake()

var progress := 0

export var word := '' setget set_word
export var stay_active = false

export var word_bbcode = '[shake rate=5 level=10][color=fuchsia]'
export var hint_bbcode = '[shake rate=5 level=10][color=fuchsia]'

func set_word(value):
	word = value
	$Word/Label.bbcode_text = word_bbcode + word.to_upper()
	update_hint()

func set_show_word(value):
	show_word = value
	$Word.visible = active and show_word
# ******************************************************************************

func update_hint():
	if custom_hint:
		$Hint/Label.bbcode_text = hint_bbcode + custom_hint
	else:
		$Hint/Label.bbcode_text = hint_bbcode + word.to_upper()

func start():
	set_show_hint(true)
#	$Hint/Label.text = ""
#	update_hint()
#	print($Hint/Label.text.length())

func _ready():
	$Word/Label.bbcode_enabled = true
	$Word/Label.bbcode_text = word_bbcode + word.to_upper()
	$Hint/Label.bbcode_enabled = true
	set_word(word)
	set_active(active)
	$Word/Label.visible_characters = 0

	if auto_death: 
		if get_parent().has_method('dead'):
			connect("matched", get_parent(), "dead")

func _input(event):
	if !active:
		return
#	if show_word:
#		if Player.character.global_position.distance_to(global_position) > distance:
#			$Hint.visible = false
	$Hint.visible = show_hint and Player.character and Player.character.global_position.distance_to(global_position) < distance
	if !(event is InputEventKey) or !event.pressed:
		return
	if !word:
		return

	var c = char(event.unicode).to_lower()
	if event.shift:
		c = c.to_upper()

	if progress >= word.length():
		progress = word.length()
		

	if word[progress] == c and Player.character.global_position.distance_to(global_position) < distance:
		if progress < word.length():
			progress += 1
		$Word/Label.visible_characters = progress

		if progress == word.length():
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = '[wave amp=50 freq=10]' + word.to_upper()
			$MatchSound.play()
			$AnimationPlayer.play('matched')
			active = stay_active
			emit_signal('matched')
			Player.character.punch()
			if active:
				$AnimationPlayer.play_backwards('matched')
				reset()
	else:
		if progress > 0:
			reset()
			emit_signal('mistake')
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = word_bbcode + word.to_upper()
			$AnimationPlayer.play('mistake')

func reset():
	progress = 0
