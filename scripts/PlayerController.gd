class_name PlayerController extends CharacterBody3D

#TODO cleanup code, add inventory + hotbar UI + right click to 
#equip (only equippable) + JSON file for localization of item names
#remove item on removal (we need option to spawn item pickup from item instance)
#add focus support to inventory or right click with hover color change, maybe button use

var move = Vector3.ZERO
const gravity = Vector3(0, -9.8, 0)
var speed = 10.0
var sens = 0.01
var console = AdminConsole.new()
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var crosshair = $Camera3D/Control/Label
@onready var console_input = $Camera3D/Control/LineEdit
@onready var interact_box = $Camera3D/Control/InteractBox
@onready var arms = $Camera3D/arms
@onready var inventory = $Camera3D/Control/ScrollContainer/Inventory


var grounded = true
const INTERACT_CROSSHAIR_COLOR = Color.YELLOW
const DEFAULT_CROSSHAIR_COLOR = Color.WHITE
@export var viewBobbingLevel = 0.037;
@export var viewBobbingSpeed = 0.235;
@export var viewBobbingValue = 0.0;

@export var passiveBobbingLevel = 0.002
@export var passiveBobbingSpeed = 0.06

var inventory_x = 5
var inventory_y = 5

func _ready() -> void:
	inventory.player = self
	GameManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var win_size = get_viewport().get_visible_rect().size
	console_input.custom_minimum_size = Vector2(win_size.x, win_size.y / 7.0)
	

func _process(delta: float) -> void:
	$RayDebug.global_position = raycast.get_collision_point()
	if raycast.is_colliding() and crosshair != null:
		var obj = raycast.get_collider()
		
		if obj is Interactable:
			interact_box.visible = true
			interact_box.get_node("Label").text = "[E] to interact"
			crosshair.add_theme_color_override("font_color", INTERACT_CROSSHAIR_COLOR)
		elif obj is ItemPickup:
			interact_box.visible = true
			interact_box.get_node("Label").text = "[E] pickup"
		else:
			interact_box.visible = false
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

func get_eye_ray():
	return $Camera3D/RayCast3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_console"):
		console_input.get_node("Timer").start()
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = !inventory.visible
		if inventory.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if console_input.visible or inventory.visible:
		return

	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var obj = raycast.get_collider()
			if obj is Interactable:
				obj._on_interact(self)
			elif obj is ItemPickup:
				arms.get_node("AnimationPlayer").play("pickup")
				#try add to inventory
				#obj.obj_class.new().on_equip(self)
				var instance = obj.prefab.instantiate()
				instance.position = Vector3.ZERO
				instance.rotation = Vector3.ZERO
				instance.scale = Vector3(1.0, 1.0, 1.0)
				instance.visible = false
				arms.call_deferred("add_child", instance)
				inventory.add_item(instance)
				obj.get_parent().call_deferred("queue_free")

	if event is InputEventMouseMotion:
		camera.rotation += Vector3(-event.relative.y * sens, -event.relative.x * sens, 0)
	var v =Input.get_vector("right", "left", "backward", "forward")
	var angle = camera.rotation.y
	move = -Vector3(sin(angle), 0, cos(angle)) * v.y - Vector3(sin(angle+PI/2), 0, cos(angle+PI/2)) * v.x
	move = move.normalized()
	
func _send_command(cmd: String):

	console.send_command(cmd)
	console_input.visible = false
	console_input.release_focus()

func _toggle_timer():
	
	var b = console_input.visible
	console_input.visible = !b
	console_input.grab_focus()
