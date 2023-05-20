extends CharacterBody3D
@export var speed = 10
@export var jump_velocity = 4.5

var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y = 0

@onready var camera:Camera3D = $Camera3D

func _physics_process(delta):
	var horizontal_velocity = Input.get_vector("move_left","move_right","move_forward","move_backward").normalized() * speed
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	if is_on_floor():
		velocity_y = jump_velocity if Input.is_action_just_pressed("jump") else 0
	else:
		velocity_y -= gravity * delta
		velocity.y = velocity_y
	move_and_slide()
	
		
func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if event is InputEventMouseMotion:
		if camera != null:
			rotate_y(-event.relative.x * look_sensitivity)
			camera.rotate_x(-event.relative.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
