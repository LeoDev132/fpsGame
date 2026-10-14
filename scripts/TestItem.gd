class_name TestItem extends Item

func _init() -> void:
	var m = BoxMesh.new()
	m.size = Vector3(0.3, 0.3, 0.3)
	self.pickup_mesh_path = m
	self.prefab_path = "res://assets/test_item.tscn"
	self.identifier = "test_item"
	self.display_name = "test_item" #TODO JSON local file
	self.rarity = 0
	self.pickup_rot = Vector3(20, 20, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.

func on_equip(entity):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
