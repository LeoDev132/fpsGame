extends MeshInstance3D

#transforms 2D coordonates into a point in 3D space
func _apply_noise(n: Noise4D, v: Vector2, vertical_scale: float, horizontal_scale: float):
	return Vector3(v.x, n.get_noise_2d(v.x * horizontal_scale, v.y * horizontal_scale) * vertical_scale, v.y)
func _get_normal(v1: Vector3, v2: Vector3, v3: Vector3):
	var U = v2 - v1
	var V = v3 - v1
	var n = Vector3.ZERO
	n.x = U.y * V.z - U.z * V.y
	n.y = U.z * V.x - U.x * V.z
	n.z = U.x * V.y - U.y * V.x
	return n.normalized()
func _ready() -> void:
	var vertices = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	#get_tree().debug_collisions_hint = true
	var size = 100
	var spacing = 2.0
	var n = Noise4D.new()
	for i in range(size):
		for j in range(size):

			var v_scale = 40.0
			var tex_scale = 0.2
			var h_scale = 0.3
			var top_left = _apply_noise(n, Vector2(i, j) * spacing, v_scale, h_scale)
			var top_right = _apply_noise(n, Vector2(i+1, j) * spacing, v_scale, h_scale)
			var bottom_left = _apply_noise(n, Vector2(i, j+1) * spacing, v_scale, h_scale)
			var bottom_right = _apply_noise(n, Vector2(i+1, j+1) * spacing, v_scale, h_scale)
			vertices.append(top_left)
			uvs.append(Vector2(top_left.x, top_left.z) * tex_scale)
			vertices.append(top_right)
			uvs.append(Vector2(top_right.x, top_right.z) * tex_scale)
			vertices.append(bottom_left)
			uvs.append(Vector2(bottom_left.x, bottom_left.z) * tex_scale)
			var normal = _get_normal(top_left, top_right, bottom_left)
			normals.append(-normal)
			normals.append(-normal)
			normals.append(-normal)

			if(i == floor(size/2.0) and j == floor(size/2.0)):
				$"../../CharacterBody3D".position = top_right + Vector3(0, 3, 0)

			vertices.append(top_right)
			uvs.append(Vector2(top_right.x, top_right.z) * tex_scale)
			vertices.append(bottom_right)
			uvs.append(Vector2(bottom_right.x, bottom_right.z) * tex_scale)
			vertices.append(bottom_left)
			uvs.append(Vector2(bottom_left.x, bottom_left.z) * tex_scale)
			normal = _get_normal(top_right, bottom_right, bottom_left)
			normals.append(-normal)
			normals.append(-normal)
			normals.append(-normal)
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs;
	arrays[Mesh.ARRAY_NORMAL] = normals;
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = self

	var shape = CollisionShape3D.new()
	$"../CollisionShape3D".shape = arr_mesh.create_trimesh_shape()
	arr_mesh.surface_set_material(0, load("res://ambientcg/Extracted/Ground106_2K-JPG.tres"))
	m.mesh = arr_mesh
func _process(delta: float) -> void:
	var faces = mesh.get_faces()
	for i in range(faces.size() / 3):
		var index = i * 3
		var v1 = faces[index]
		var v2 = faces[index+1]
		var v3 = faces[index+2]
		var normal = -_get_normal(v1, v2, v3)
		var face_center = (v1 + v2 + v3) / 3.0
		#$"../../DebugDraw3D".draw_line(face_center, face_center + normal)
