extends CharacterBody3D
#Family friendly script for handling monster behavior

# Called when the node enters the scene tree for the first time.


@onready var head = $model/Rotator
@onready var player:CharacterBody3D = get_tree().get_root().get_node("Node3D/Player_v2")
@onready var area_precense:Area3D = $NavigationAgent3D/PrecenseArea
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var nav_target = null 
@onready var audio_player = $AudioStreamPlayer3D
@onready var timer_loitter:Timer = $AudioStreamPlayer3D/Timer_Loiter
@onready var timer_chase:Timer = $AudioStreamPlayer3D/Timer_Chase
@onready var timer_ischasing:Timer = $Timer_isChasing
@onready var player_detector:RayCast3D = $PlayerDetector

@onready var movement_velocity = null

@export var speed_walk = 2.5
@export var speed_run = 4
@export var mode = "loitter"
@export var ai_disable = false
@export var ai_silent = false
@export var maxChaseTime = 15

var SPEED = speed_walk


func _ready():
	if ai_disable == false:
		nav_target = ChooseNewTarget()	
	ChangeMode("loitter")

	

func ChangeMode(value:String):
	if value in ["loitter","chase"]:
		mode = value
	
		timer_loitter.stop()
		timer_chase.stop()
		ResetTimers()
		
		if mode == "loitter":
			timer_loitter.start()
			SPEED = speed_walk
			
		if mode == "chase":
			timer_chase.start()
			nav_target = ChooseNewTarget()
			SPEED = speed_run
			playsound(audio_player,"res://assets/sounds/monster-notice.ogg")
	else:
		print("Invalid value passed to ChangeMode")
		
func ResetTimers():
	print("Reset timers")
	randomize()
	timer_loitter.wait_time = randi_range(10,25)
	timer_chase.wait_time = randi_range(5,10)
	

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	
	if ai_disable == false:
		#Velocity is RigidBodys variable so it's not initialized anywhere here.
		velocity = velocity.move_toward(new_velocity, .25)
		movement_velocity = move_and_slide()


func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

	
func playsound(audio_player:AudioStreamPlayer3D,filepath:String):
	if ai_silent == false:
		audio_player.stream = load(filepath) 
		audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if head != null and player != null:
		
		if mode == "loitter":
			head.look_at(velocity, Vector3.UP)

		elif mode == "chase":
			var target = Vector3(player.global_transform.origin)
			head.look_at(target,Vector3.UP)
			
		elif mode == "search":
			pass
			#Monster searches the area where you went hiding
	
	if player.get("isSneaking"):
		#var length = (get_collision_point() - get_global_transform.origin).length()
		$PlayerDetector.target_position.z = -30
	else:
		$PlayerDetector.target_position.z = -40
	print($PlayerDetector.target_position.z)
		
	#Handle selecting new point for navigation and go there.
	#If player is spotted on the way switch to chacing it
	
	if ai_disable == false:
		if nav_agent.is_target_reached():
			nav_target = ChooseNewTarget()
			
		if nav_target != null:
			update_target_location(nav_target.global_transform.origin)
			
	if player != null:
		if not player.get("isHiding"):
			player_detector.look_at(player.transform.origin)
			if player_detector.is_colliding():
				var collider = player_detector.get_collider()
				if collider.get_name() == "Player_v2":
					
					timer_ischasing.stop()
					timer_ischasing.wait_time = maxChaseTime
					timer_ischasing.start()
					
					if mode != "chase":
						ChangeMode("chase")
		else:
			if mode == "chase":
				ChangeMode("loitter")
				nav_target = ChooseNewTarget()

	
func ChooseNewTarget():
	if mode == "chase" and not player.get("isHiding"):
		return player
		
	var entity_targets = get_tree().get_nodes_in_group("entity_target")
	return entity_targets[randi() % entity_targets.size()]

func _on_timer_chase_timeout():
	pass # Replace with function body.

func _on_timer_loiter_timeout():
	ResetTimers()
	playsound(audio_player,"res://assets/sounds/monster-angry.ogg")

func _on_timer_is_chasing_timeout():
	print("LOST INTREST")
	ChangeMode("loitter")
	playsound(audio_player,"res://assets/sounds/monster-close-1.ogg")

