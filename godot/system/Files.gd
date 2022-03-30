tool
extends Node

# ******************************************************************************

func get_files(path, ext=''):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if ext:
				if file.ends_with(ext):
					files.append(file)
			else:
				files.append(file)

	dir.list_dir_end()

	return files

func get_all_files(path, ext='', max_depth=2, depth=0, files=[]):
	if depth >= max_depth:
		return
	
	var dir = Directory.new()
	dir.open(path)
	
	dir.list_dir_begin(true, true)

	var file = dir.get_next()
	while file != "":
		var file_path = dir.get_current_dir().plus_file(file)
		if dir.current_is_dir():
			get_all_files(file_path, ext, max_depth, depth + 1, files)
		else:
			if ext:
				if file.ends_with(ext):
					files.append(file_path)
			else:
				files.append(file_path)
		file = dir.get_next()

	dir.list_dir_end()

	return files

# ------------------------------------------------------------------------------

var file_prefix

func _ready():
	if OS.has_feature("standalone"):
		file_prefix = 'user://'
	else:
		file_prefix = 'res://data/'

func save_json(file_name: String, data, auto_prefix:=true):
	var f = File.new()
	if auto_prefix:
		file_name = file_prefix + file_name
	f.open(file_name, File.WRITE)
	f.store_string(JSON.print(data, "\t"))
	f.close()

func load_json(file_name: String, auto_prefix:=true):
	var result = null
	var f = File.new()
	if auto_prefix:
		file_name = file_prefix + file_name
	if f.file_exists(file_name):
		f.open(file_name, File.READ)
		var text = f.get_as_text()
		f.close()
		result = JSON.parse(text).result
	return result
