tool
extends Node

# ******************************************************************************

var characters_path = 'characters/'
var character_map_path = characters_path + 'other_characters.json'
var characters := {}

var sandbox = load('res://addons/diagraph/Sandbox.gd').new()

var conversation_path := 'conversations/'
var conversations := {}

var plugin = null

signal refreshed

# ******************************************************************************

func _ready():
	if !Engine.editor_hint or plugin:
		validate_paths()
		call_deferred('refresh')

		if OS.has_feature('HTML5'):
			var files = get_files('res://' + conversation_path, '.json')
			for file in files:
				var from_path = 'res://' + conversation_path + file
				var to_path = 'user://' + conversation_path + file
				var convo = load_json(from_path)
				if convo:
					save_json(to_path, convo)

func refresh():
	load_conversations()
	load_characters()
	emit_signal('refreshed')

func load_conversations():
	conversations.clear()
	var json_conversations = get_all_files(prefix + conversation_path, '.json')
	for convo in json_conversations:
		conversations[path_to_name(convo)] = convo
	var yarn_conversations = get_all_files(prefix + conversation_path, '.yarn')
	for convo in yarn_conversations:
		conversations[path_to_name(convo)] = convo

func load_conversation(name, default=null):
	if !(name in conversations):
		return default

	var result = default
	if conversations[name].ends_with('.json'):
		result = load_json(conversations[name], default)
	if conversations[name].ends_with('.yarn'):
		result = load_yarn(conversations[name], default)
	return result

func save_conversation(name, data):
	if conversations[name].ends_with('.json'):
		save_json(conversations[name], data)
	# if conversations[name].ends_with('.yarn'):
	# 	load_yarn(conversations[name], default)

func load_characters():
	characters.clear()
	for file_name in get_all_files('res://' + characters_path, '.tscn'):
		var c = load(file_name).instance()
		characters[c.name] = c

	# for folder in get_files('res://' + characters_path):
	# 	for file in get_files('res://' + characters_path + folder, '.tscn'):
	# 		var file_name = 'res://' + characters_path + folder + '/' + file
	# 		if dir.file_exists(file_name):
	# 			var c = load(file_name).instance()
	# 			characters[c.name] = c

	# var dir := Directory.new()
	# var char_map = load_json(character_map_path, {})
	# for name in char_map:
	# 	if dir.file_exists(char_map[name]):
	# 		characters[name] = load(char_map[name]).instance()

# ******************************************************************************

func name_to_path(name):
	return conversation_path + name

func path_to_name(path):
	return path.trim_prefix(prefix + conversation_path).trim_suffix('.json').trim_suffix('.yarn')

func validate_paths():
	var dir = Directory.new()
	if !dir.dir_exists(prefix + characters_path):
		dir.make_dir_recursive(prefix + characters_path)
	if !dir.dir_exists(prefix + conversation_path):
		dir.make_dir_recursive(prefix + conversation_path)

func get_files(path, ext='') -> Array:
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

func get_all_files(path: String, ext:='', max_depth:=2, depth:=0, files:=[]) -> Array:
	if depth >= max_depth:
		return []

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

# ******************************************************************************

var prefix = 'user://' if OS.has_feature('HTML5') else 'res://'

func save_json(path, data):
	if !path.begins_with('res://') and !path.begins_with('user://'):
		path = prefix + path
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_string(JSON.print(data, "\t"))
	f.close()

func load_json(path, default=null):
	if !path.begins_with('res://') and !path.begins_with('user://'):
		path = prefix + path
	var result = default
	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		var text = f.get_as_text()
		f.close()
		var parse = JSON.parse(text)
		if parse.result is Dictionary:
			result = parse.result
	return result

# ******************************************************************************

func load_yarn(path, default=null):
	var result = default

	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		var text = f.get_as_text()
		f.close()
		parse_yarn(text)
		if nodes:
			result = nodes
	return result

var nodes := {}

func parse_yarn(text):
	nodes.clear()
	var mode := 'header'

	var header := []
	var body := []
	var i := 0
	var lines = text.split('\n')
	while i < lines.size():
		var line = lines[i]
		if line == '===': # end of node
			create_node(header, body)
			header.clear()
			body.clear()
			mode = 'header'
		elif line == '---': # end of header
			mode = 'body'
		else:
			if mode == 'header':
				header.append(line)
			if mode == 'body':
				body.append(line)
		i += 1

var used_ids = []

func get_id() -> int:
	var id = randi()
	if id in used_ids:
		id = get_id()
	used_ids.append(id)
	return id

func create_node(header, body):
	var node := {
		id = 0,
		type = '',
		name = '',
		text = '',
		next = 'none',
	}

	var fields := {}
	for line in header:
		var parts = line.split(':')
		if parts.size() != 2:
			continue
		fields[parts[0]] = parts[1].lstrip(' ')

	node.name = fields.title
	node.id = fields.get('id', get_id())
	node.type = fields.get('type', 'speech')

	if node.type == 'speech':
		node['show_choices'] = bool(fields.get('show_choices', false))

	var _body = body[0]
	var i = 1
	while i < body.size():
		_body += '\n' + body[i]
		i += 1
	node['text'] = _body

	nodes[str(node.id)] = node
