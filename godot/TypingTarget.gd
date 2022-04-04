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
export var show_word = true setget set_show_word
export var distance = 100

signal matched()
signal mistake()

var progress := 0

export var word := '' setget set_word
export var stay_active = false

func set_word(value):
	word = value
	$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word.to_upper()
	update_hint()

func set_show_word(value):
	print("ok")
	show_word = value
	$Word.visible = active and show_word
# ******************************************************************************

func update_hint():
	if custom_hint:
		$Hint/Label.bbcode_text = '[shake rate=5 level=10]%s' % custom_hint
	else:
		$Hint/Label.bbcode_text = '[shake rate=5 level=10]%s' % word.to_upper()

func start():
	set_show_hint(true)
#	$Hint/Label.text = ""
#	update_hint()
#	print($Hint/Label.text.length())

func _ready():
	$Word/Label.bbcode_enabled = true
	$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word.to_upper()
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
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = '[wave amp=50 freq=10]%s' % word.to_upper()
			$AnimationPlayer.play('matched')
			active = stay_active
			emit_signal('matched')
			if active:
				$AnimationPlayer.play_backwards('matched')
				reset()
	else:
		if progress > 0:
			reset()
			emit_signal('mistake')
			$Word/Label.bbcode_enabled = true
			$Word/Label.bbcode_text = '[shake rate=5 level=10]%s' % word.to_upper()
			$AnimationPlayer.play('mistake')

func reset():
	progress = 0
