class_name Inventory extends VBoxContainer

var inv_size = 50

var items = []

var inv_line = preload("res://assets/inventory_line.tscn")

var player = null

var y_ratio = 0.7
var x_ratio = 0.4
@onready var win_size = get_viewport_rect().size

func _ready():
	get_parent().custom_minimum_size = Vector2(win_size.x * x_ratio, win_size.y * y_ratio)
	pass
func add_item(instance: Item):
	var line = inv_line.instantiate()
	line.text = instance.name
	line.item_index = items.size()
	items.push_back(instance)
	line.custom_minimum_size = Vector2(win_size.x * x_ratio, 0)
	call_deferred("add_child", line)
	
