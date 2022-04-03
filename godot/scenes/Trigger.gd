extends Area2D



func _on_TriggerDialog_body_entered(body: Node) -> void:
	if $LabelDefault.visible_characters == 0:
		$LabelDefault.start()
