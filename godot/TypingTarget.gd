tool
extends CanvasItem

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
export var show_word = true
export var distance = 100

signal matched()
signal mistake()

var progress := 0

export var word := '' setget set_word
func set_word(value):
	if not show_word: return
	word = value
	$Word/Label.text = value
	update_hint()

# ******************************************************************************

func update_hint():
	if custom_hint:
		$Hint/Label.bbcode_text = '[shake rate=5 level=10]%s' % custom_hint
	else:
		$Hint/Label.bbcode_text = '[shake rate=5 level=10]%s' % word

func _ready():
	$Word/Label.bbcode_enabled = true
	$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word
	$Hint/Label.bbcode_enabled = true
	set_word(word)
	set_active(active)
	$Word/Label.visible_characters = 0
	if auto_death: connect("matched", get_parent(), "dead")

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
