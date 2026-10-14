class_name SpiderEnemy extends Node3D

@onready var skeleton: Skeleton3D = $Armature/Skeleton3D

@onready var a_l = $a_l
@onready var b_l = $b_l
@onready var c_l = $c_l
@onready var d_l = $d_l
@onready var a_r = $a_r
@onready var b_r = $b_r
@onready var c_r = $c_r
@onready var d_r = $d_r


var ground_dist = 1

var limbs = []
var old_limbs = []
var distances = []

@onready var raycast = $Armature/RayCast3D

func _check_legs():#returns true if considered grounded
	for l in limbs:
		if l.grounded:
			return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limbs = [a_l, b_l, c_l, d_l, a_r, b_r, c_r, d_r]
	for i in range(limbs.size()):
		old_limbs.push_back(limbs[i].global_position)
		var diff = limbs[i].global_position - $Armature.global_position
		distances.push_back(diff.length())
	pass # Replace with function body.

var v = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_legs():
		if raycast.is_colliding():
			$Armature.apply_central_force(Vector3.UP * 11)
		else:
			print($Armature.linear_velocity)
			$Armature.apply_central_force(Vector3.UP * 9.8)
	"""v+=0.1
	var air_friction = 5
	var vel = Vector3.ZERO
	for i in range(limbs.size()):
		#limbs[i].freeze = true
			var buff = limbs[i].global_position
			var true_vel = (old_limbs[i] - limbs[i].global_position)
			
			vel = true_vel.normalized() * 10
			vel += Vector3(0, -9.8, 0)
			limbs[i].global_position = buff * 2 - old_limbs[i] + vel * delta * delta
			old_limbs[i] = buff
			var diff: Vector3 = limbs[i].global_position - $Armature.global_position
			if diff.length() > distances[i]:
				limbs[i].global_position = $Armature.global_position + diff.normalized() * distances[i]
				#limbs[i].linear_velocity = -diff.normalized() * (diff.length() - distances[i])
		#for i in range(vals.size()):
	 	#	vals[i] += 3 * delta
		#zwz	limbs[i].position.y += sin(vals[i]) * 0.3"""
		
	pass
