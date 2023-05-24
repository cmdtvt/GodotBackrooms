extends CharacterBody3D


var SPEED = 5.0
var speed_walk = 3.0
var speed_run = 5.0
var speed_sneak = 2.0

const JUMP_VELOCITY = 4.5
var camera_locked = true
var isHiding = false
var isDisabled = false
var isSneaking = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
@onready var camera:Camera3D = $Camera3D
@onready var raycast:RayCast3D = $Camera3D/RayCast3D
@onready var anim:AnimationPlayer = $AnimationPlayer


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if isDisabled == false:
	# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	
	

		
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Input.is_action_just_pressed("esc"):
		if camera_locked:
			camera_locked = false
		else:
			camera_locked = true
			
	if camera_locked:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_pressed("sprint"):
		SPEED = speed_run
		
	if Input.is_action_just_released("sprint"):
		SPEED = speed_walk
		
	if Input.is_action_pressed("sneak"):
		SPEED = speed_sneak
		if not isSneaking:
			isSneaking = true
			anim.play("sneak")
		
		
	if Input.is_action_just_released("sneak"):
		SPEED = speed_walk
		anim.play_backwards("sneak")
		isSneaking = false

		
	

	#if Input.is_action_just_pressed("interact"):
		#if raycast.is_colliding():
			#var coll_node = raycast.get_collider()
			#print(coll_node.owner.get_name())
			#if coll_node.owner.has_method("PlayerInterracts"):
				#coll_node.owner.PlayerInterracts()
				
func PlayerHides(value:bool):
	isHiding = value
	DisableControls(value)
	
func DisableControls(value:bool):
	isDisabled = value
	
func FocusCamera():
	camera.make_current()
		
func _input(event):
	if camera_locked == true or isDisabled:
		if event is InputEventMouseMotion:
			if camera != null:
				rotate_y(-event.relative.x * look_sensitivity)
				camera.rotate_x(-event.relative.y * look_sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
				
