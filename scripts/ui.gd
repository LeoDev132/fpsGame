extends Control

func _ready() -> void:
	custom_minimum_size.x = get_viewport_rect().size.x
	custom_minimum_size.y = get_viewport_rect().size.y
	$Label.position += get_viewport_rect().size / 2.0
