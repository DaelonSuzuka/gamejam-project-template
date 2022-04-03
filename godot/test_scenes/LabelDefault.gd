extends RichTextLabel

func _ready() -> void:
	visible_characters = 0

func start():
	for i in text.length():
		visible_characters += 1
