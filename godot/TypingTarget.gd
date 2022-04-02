tool
extends Node2D

# ******************************************************************************

export var word := '' setget set_word
func set_word(value):
	word = value
	$Word/Label.text = value
	$Hint/Label.text = value

export var active := true setget set_active
func set_active(value):
	active = value
	$Hint.visible = value

signal matched()
signal mistake()

var progress := 0

# ******************************************************************************

func _ready():
	$Word/Label.bbcode_enabled = true
	$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word
	$Hint/Label.bbcode_enabled = true
	$Hint/Label.bbcode_text = '[shake rate=5 level=10]%s' % word
	set_word(word)
	set_active(active)
	$Word/Label.visible_characters = 0

func _input(event):
	if !active:
		return
	if !(event is InputEventKey) or !event.pressed:
		return
	if !word:
		return

	var c = char(event.unicode).to_lower()
	if event.shift:
		c = c.to_upper()

	if progress >= word.length():
		progress = word.length()

	if word[progress] == c:
		if progress < word.length():
			progress += 1
		$Word/Label.visible_characters = progress

		if progress == word.length():
			emit_signal('matched')
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = '[wave amp=50 freq=10]%s' % word
			$AnimationPlayer.play('matched')
			active = false
	else:
		if progress > 0:
			progress = 0
			emit_signal('mistake')
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word
			$AnimationPlayer.play('mistake')
