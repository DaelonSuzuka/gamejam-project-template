extends Node
class_name Timestamp

# ******************************************************************************

var _time: int

func _init(_period=1.0):
	_time = OS.get_ticks_msec()

func time_since():
	return OS.get_ticks_msec() - _time

func update():
	_time = OS.get_ticks_msec()

func _to_string():
	return 'timestamp: %dms, %dms ago' % [_time, time_since()]
