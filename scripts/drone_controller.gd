extends RigidBody3D

var tilt = Vector2.ZERO
var throttle = 0.0
var rot = 0.0
const MAX_FAN_SPEED = 200.0
const HEIGHT_SPEED_ANGLE = 20.0

@onready var FL = $FL
@onready var FR = $FR
@onready var RL = $RL
@onready var RR = $RR

var angleMode = true
var targetHeight = 0.0
var heightAnimVal = 0.0
#TODO use interpolation for height and write tilt animation 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0.0
	targetHeight = position.y
	pass # Replace with function body.

func _input(event: InputEvent):
	if angleMode:
		_input_angle(event)

func _input_angle(event: InputEvent) -> void:
	if event.is_action_pressed("drone_up"):
		throttle = 10.0
	elif event.is_action_pressed("drone_down"):
		throttle = -10.0
	if event.is_action_released("drone_up") and throttle > 0.0:
		throttle = 0
	if event.is_action_released("drone_down") and throttle < 0.0:
		throttle = 0
	tilt = Input.get_vector("drone_tilt_left", "drone_tilt_right", "drone_tilt_forward", "drone_tilt_backward")
	if event.is_action_pressed("drone_left"):
		rot = 1.0
	elif event.is_action_pressed("drone_right"):
		rot = -1.0
	else:
		rot = 0.0

func _process_angle(delta: float):
	targetHeight = position.y + throttle*delta*HEIGHT_SPEED_ANGLE
	$MeshInstance3D2.global_position = Vector3(position.x, targetHeight, position.z)
	var diff = Vector3(position.x, targetHeight, position.z) - position
	linear_velocity.y = (targetHeight - position.y)
	
	pass
func _process_acro(delta: float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if angleMode:
		_process_angle(delta)
	pass
