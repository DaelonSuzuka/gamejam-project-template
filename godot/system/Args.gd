extends Node

# ******************************************************************************
# default args

# general
var scene = ''

# ******************************************************************************

func _ready():
	parse()

# parses command line arguments of the following formats:
# "--key=value"
# "--key value"
# "--key"
func parse():
	for arg in OS.get_cmdline_args():
		if arg.find('=') > -1:
			var parts = arg.split('=')
			set(parts[0].lstrip('--'), parts[1])
		elif arg.find(' ') > -1:
			var parts = arg.split(' ')
			set(parts[0].lstrip('--'), parts[1])
		else:
			set(arg.lstrip('--'), true)
