extends Area3D

#TODO check area bodies, if bodies detected go to best pos detected by raycast (hopefully on same surface

var vel
var old_pos
var grounded = false
var best_pos = null
var ray_dist = 2
@export var verlet_dist = 4
var air_friction = 10


@onready var raycast = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_collision)
	old_pos = position
	pass # Replace with function body.

func _get_diff():
	return $"../Armature".get_node(name+"_c").global_position - global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_vel = position - old_pos
	raycast.target_position = true_vel.normalized() * ray_dist
	if not grounded:
		var diff = _get_diff()
		if diff.length() > verlet_dist:
			var center_pos = $"../Armature".get_node(name+"_c").global_position
			global_position = center_pos  - diff.normalized() * verlet_dist
		if raycast.is_colliding():
			best_pos = raycast.get_collision_point()
		var buff = position
		vel = Vector3(0, -9.8, 0)
		vel += -true_vel.normalized() * air_friction
		position = position * 2 - old_pos + vel * delta * delta
		old_pos = buff

func _on_collision(body):
	if body is not Skeleton3D:
		if best_pos != null:
			global_position = best_pos
			
			grounded = true
			best_pos = null
		
