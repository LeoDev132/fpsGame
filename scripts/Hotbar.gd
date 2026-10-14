class_name Hotbar extends HBoxContainer

var item_refs = []
var slot_objects = []

const EMPTY_SLOT = Vector2i(-1, -1)
var curr_slot = 0

func _ready():
	var slot = load("res://assets/hotbar_slot.tscn")
	var ratio = 0.75
	var win_size = get_viewport_rect().size
	var slot_size = 16
	var separation = 4
	add_theme_constant_override("separation", separation)
	var n = 5
	custom_maximum_size = Vector2(slot_size * n + separation*(n-1), slot_size)
	custom_minimum_size = custom_maximum_size
	position.y = win_size.y - slot_size
	 #position.x = TODO fix x ratio
	for i in range(n):
		var instance = slot.instantiate()
		instance.name = str(i)
		call_deferred("add_child", instance)

func _init():
	for i in range(5):
		item_refs.append(EMPTY_SLOT) #vec2(-1, -1) = no item
 
