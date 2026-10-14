extends Node

var registered_items = {}

func spawn_item(pos, itm_id):
	if itm_id not in registered_items.keys():
		print("CANNOT SPAWN ITEM")
	else:
		var node = Node3D.new()
		var area = ItemPickup.new()
		area.prefab = load(registered_items[itm_id].new().prefab_path)
		var area_col = CollisionShape3D.new()
		var area_col_shape = SphereShape3D.new()
		var item = registered_items[itm_id].new()
		var rb = RigidBody3D.new()
		var mesh_instance = MeshInstance3D.new()
		var mesh: Mesh = load(item.prefab_path).instantiate().get_node(item.pickup_mesh_path).mesh
		var collider = CollisionShape3D.new()
		collider.shape = mesh.create_convex_shape()
		mesh_instance.mesh = mesh
		var pickup_rad = 1.0
		
		area_col_shape.radius = pickup_rad
		area_col.shape = area_col_shape
		
		rb.call_deferred("add_child", mesh_instance)
		
		rb.call_deferred("add_child", collider)
		rb.position = pos
		area.call_deferred("add_child", area_col)
		rb.call_deferred("add_child", area)
		call_deferred("add_child", rb)
		get_parent().call_deferred("add_child", rb)
		
		

func register_item(itm_class):
	var itm = itm_class.new()
	assert(itm.identifier not in registered_items.keys())
	registered_items[itm.identifier] = itm_class
	print(itm.identifier + " registered")
	pass
