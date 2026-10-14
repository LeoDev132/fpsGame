extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_viewport_rect().size / 2.0
	position += -size / 2.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
