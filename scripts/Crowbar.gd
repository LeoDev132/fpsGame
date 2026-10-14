class_name Crowbar extends Item


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	self.identifier = "crowbar"
	self.custom_attributes = {}
	self.display_name = "Crowbar"
	self.equippable = true
	self.prefab_path = "res://assets/crowbar.tscn"
	self.pickup_mesh_path = "Plane"
	pass # Replace with function body.

func on_equip(entity):
	$Plane.scale = Vector3(0.2, 0.2, 0.2)
	$AnimationPlayer.play("crowbar_switch")
	get_parent().get_node("AnimationPlayer").play("crowbar_switch")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
