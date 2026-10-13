extends CharacterBody3D

var move = Vector3.ZERO
const gravity = Vector3(0, -9.8, 0)
var speed = 10.0
var sens = 0.01
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var crosshair = $Camera3D/Control/Label

var grounded = true
const INTERACT_CROSSHAIR_COLOR = Color.YELLOW
const DEFAULT_CROSSHAIR_COLOR = Color.WHITE
@export var viewBobbingLevel = 0.037;
@export var viewBobbingSpeed = 0.235;
@export var viewBobbingValue = 0.0;

@export var passiveBobbingLevel = 0.002
@export var passiveBobbingSpeed = 0.06


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if raycast.is_colliding() and crosshair != null:
		var obj = raycast.get_collider()
		if obj is Interactable:
			crosshair.add_theme_color_override("font_color", INTERACT_CROSSHAIR_COLOR)
		else:
			crosshair.add_theme_color_override("font_color",DEFAULT_CROSSHAIR_COLOR)
	else:
		crosshair.add_theme_color_override("font_color", DEFAULT_CROSSHAIR_COLOR)
func _physics_process(delta: float) -> void:
	velocity = gravity
	velocity += move * speed
	var horizontalVelocity = Vector2(velocity.x, velocity.z)
	if(horizontalVelocity.length() > 0.5 and grounded):
		viewBobbingValue +=  viewBobbingSpeed
		
		camera.position.y += sin(viewBobbingValue) * viewBobbingLevel
	else:
		viewBobbingValue +=  passiveBobbingSpeed
		camera.position.y += sin(viewBobbingValue) * passiveBobbingLevel
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var obj = raycast.get_collider()
			if obj is Interactable:
				obj._on_interact(self)
	if event is InputEventMouseMotion:
		camera.rotation += Vector3(-event.relative.y * sens, -event.relative.x * sens, 0)
	var v =Input.get_vector("right", "left", "backward", "forward")
	var angle = camera.rotation.y
	move = -Vector3(sin(angle), 0, cos(angle)) * v.y - Vector3(sin(angle+PI/2), 0, cos(angle+PI/2)) * v.x
	move = move.normalized()
	
