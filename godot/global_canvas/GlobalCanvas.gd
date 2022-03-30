extends CanvasLayer

# ******************************************************************************

func show_debug():
	$Debug.show()

func hide_debug():
	$Debug.hide()

# ------------------------------------------------------------------------------

var debug_labels := {}

func debug(name, text):
	if name in debug_labels:
		debug_labels[name].text = text
		return

	var label = $Debug/Spacer.duplicate(true)
	label.text = text
	$Debug.add_child(label)
	debug_labels[name] = label
