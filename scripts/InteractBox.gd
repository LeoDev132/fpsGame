extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var offset = Vector2(0.2 * get_viewport_rect().size.x - size.x * 0.5, -0.5 * size.y)
	position = get_viewport_rect().size / 2.0 + offset
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
