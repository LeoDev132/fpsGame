extends Node

var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ItemRegistry.register_item(TestItem)
	ItemRegistry.register_item(Crowbar)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
