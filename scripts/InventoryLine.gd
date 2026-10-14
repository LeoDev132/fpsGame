extends MenuButton

var item_index = -1

func _ready():
	get_popup().add_item("Equip")
	get_popup().add_item("Cancel")
	get_popup().index_pressed.connect(_on_button_pressed)
	pass

func _on_button_pressed(index: int):
	print(index)
	if index == 0:
		get_parent().items[item_index].visible = !get_parent().items[item_index].visible
		get_parent().items[item_index].on_equip(get_parent().player)
	
