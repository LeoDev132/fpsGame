extends RigidBody3D

var tilt = Vector3.ZERO
var throttle = 0.0
const MAX_FAN_SPEED = 200.0
const ROT_SPEED = 20.0
const HEIGHT_SPEED_ANGLE = 10.0
const HORIZONTAL_SPEED_ANGLE = 5.0
var height_fan_val = 0.3
var old_pos = Vector3.ZERO
var rot = Vector3.ZERO
var old_rot
var on = false
var MAX_TILT_ANGLE = deg_to_rad(10)
@onready var FL = $FL
@onready var FR = $FR
@onready var RL = $RL
@onready var RR = $RR

var angleMode = true
var y_rot = 0.0

var targetHeight = 0
var dt = 0.01

func _ready() -> void:
	targetHeight = position.y
	old_pos = position
	old_rot = rot
	pass # Replace with function body.

func _input(event: InputEvent):
	if angleMode:
		_input_angle(event)

func _input_angle(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_drone"):
		on = !on
	var t = Input.get_vector("drone_tilt_forward", "drone_tilt_backward", "drone_tilt_left", "drone_tilt_right")
	tilt = Vector3(t.x, tilt.y, -t.y)
	tilt.y = Input.get_axis("drone_left", "drone_right")
	throttle = Input.get_axis("drone_down", "drone_up")
	#tilt = tilt.normalized()



func _process_angle(delta: float):
	if on:
		var b = rot
		y_rot += tilt.y * -0.1
		var rot_target = Vector3(tilt.x * MAX_TILT_ANGLE, y_rot, tilt.z * MAX_TILT_ANGLE)
		var rot_vel = (rot_target - rot)
		var true_vel = rot - old_rot
		print(rot_target)
		if rot.z > rot_target.z and true_vel.z > 0.0:
			old_rot.z = rot.z - true_vel.z * 0.7
		elif rot.z < rot_target.z and true_vel.z < 0.0:
			old_rot.z = rot.z - true_vel.z * 0.7

		if rot.x > rot_target.x and true_vel.x > 0.0:
			old_rot.x = rot.x - true_vel.x * 0.7
		elif rot.x < rot_target.x and true_vel.x < 0.0:
			old_rot.x = rot.x - true_vel.x * 0.7
		print(rot.y, "|", rot_target.y)
		if rot.y > rot_target.y and true_vel.y > 0.0:
			old_rot.y = rot.y
		elif rot.y < rot_target.y and true_vel.y < 0.0:
			old_rot.y = rot.y


		rot = rot * 2 - old_rot + rot_vel * ROT_SPEED * delta * delta

		old_rot = b
		rot.y = y_rot
		transform.basis = Basis.from_euler(rot)
		#apply_torque(tilt * 0.01)
		#rotation = rot
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		var scaled = mass * gravity
		var v = Vector3(0, scaled + throttle * HEIGHT_SPEED_ANGLE, 0)
		var fwd = $Fwd.global_position - global_position
		fwd.y = 0
		fwd = fwd.normalized()
		var left = $Left.global_position - global_position
		left.y = 0
		left = left.normalized()
		v += fwd * -tilt.x * HORIZONTAL_SPEED_ANGLE
		v += left * tilt.z * HORIZONTAL_SPEED_ANGLE
		if throttle == 0.0:
			var vel = position - old_pos
			if vel.y < 0.0:
				v = Vector3(v.x, scaled + max(2.0, -vel.y * 300.0), v.z)
			elif vel.y > 0.0:
				v = Vector3(v.x, scaled - max(2.0, vel.y * 300.0), v.z)
		apply_central_force(v)
		old_pos = position

	
	pass
func _process_acro(delta: float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	dt = delta
	if angleMode:
		_process_angle(delta)
	pass
