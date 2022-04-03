extends Area2D

export var path:NodePath

func _on_TriggerDialog_body_entered(body: Node) -> void:
	if not get_node_or_null(path): return
	get_node_or_null(path).start()
	queue_free()
