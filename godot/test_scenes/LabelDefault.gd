extends RichTextLabel

func _ready() -> void:
	visible_characters = 0

func start():
	for i in text.length():
		visible_characters += 1
		yield(get_tree().create_timer(.05),"timeout")
