extends Node2D

# ******************************************************************************

# these assignments are by reference

var inventory_file := 'inventory.json'

var key_items := []
var money := 0

var save_requested := false

# ******************************************************************************

func _ready():
	load_inventory()

var limiter = RateLimiter.new(.5)
func _physics_process(delta):
	if !limiter.check_time(delta):
		return

	if save_requested:
		save_inventory()
		save_requested = false

# ------------------------------------------------------------------------------

func give_items(items):
	pass

func give_item(item) -> bool:
	var result = false
	var parts
	var item_name = item
	var quantity = 1

	if item.find(' x') > -1:
		parts = item.split(' x')
		item_name = parts[0]
		quantity = int(parts[1])

	if item_name == 'money':
		money += quantity
		result = true

	# if item_name in Items.key_items:
	# 	if !(item_name in key_items):
	# 		key_items.append(item_name)
	# 		result = true

	# if item_name in Items.consumables:
	# 	if !(item_name in consumables):
	# 		consumables.append(item_name)
	# 		result = true

	# if item_name in Items.plugins:
	# 	if !(item_name in plugins):
	# 		plugins.append(item_name)
	# 		result = true
			
	# if item_name in Items.libraries:
	# 	if !(item_name in libraries):
	# 		libraries.append(item_name)
	# 		result = true
			
	save_requested = true
	return result

# ******************************************************************************

func save_inventory():
	var inv = {
		key_items = key_items,
		money = money,
	}

	Files.save_json(inventory_file, inv)

func load_inventory():
	var result = Files.load_json(inventory_file)
	if result is Dictionary:
		for category in result:
			if category in self:
				self[category] = result[category]
	else:
		Console.write_line('Failed to load player inventory')
