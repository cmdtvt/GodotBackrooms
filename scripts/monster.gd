extends CharacterBody3D
#Family friendly script for handling monster behavior

# Called when the node enters the scene tree for the first time.


@onready var head = $model/Rotator
@onready var player = get_tree().get_root().get_node("Node3D/Player_v2")
@onready var area_precense:Area3D = $NavigationAgent3D/PrecenseArea
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var nav_target = null 
@onready var audio_player = $AudioStreamPlayer3D
@onready var timer_loitter:Timer = $AudioStreamPlayer3D/Timer_Loiter
@onready var timer_chace:Timer = $AudioStreamPlayer3D/Timer_Chase

@onready var movement_velocity = null

@export var speed_walk = 2.5
@export var speed_run = 3.0
@export var mode = "loitter"

var SPEED = speed_walk


func _ready():
	nav_target = ChooseNewTarget()	
	ChangeMode("loitter")

	
	
func ChangeMode(mode:String):
	timer_loitter.stop()
	timer_chace.stop()
	ResetTimers()
	if mode == "loitter":
		timer_loitter.start()
	if mode == "chasing":
		timer_chace.start()
		
func ResetTimers():
	print("Reset timers")
	randomize()
	timer_loitter.wait_time = randi_range(10,25)
	timer_chace.wait_time = randi_range(5,10)
	

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	
	#Velocity is RigidBodys variable so it's not initialized anywhere here.
	velocity = velocity.move_toward(new_velocity, .25)
	movement_velocity = move_and_slide()


func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

	
func playsound(audio_player:AudioStreamPlayer3D,filepath:String):
	audio_player.stream = load(filepath) 
	audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if head != null and player != null:
		
		
		if mode == "loitter":
			
			#cache the current rotation
			#var rot = Quaternion(vec)
			# use look_at to look at the desired location
			#look_at(target_pos, Vector3.UP)
			# cache the new "target" rotation
			#var target_rot = Quat(rotation)
			#use Quat.Slerp to perform spherical interpolation to the target rotation
			#a weight like 0.1 works well
			#then set the rotation by converting the Quat back to a Eule
			#rotation = rotation.slerp(target_rot, weight).get_euler()
			var vec = Vector3(transform.origin + velocity)
			head.look_at(vec, Vector3.UP)
			head.rotation.x = 0
			print(vec)
		elif mode == "chasing":
			var target = Vector3(player.global_transform.origin)
			head.look_at(target,Vector3.UP)
			
		
	#Handle selecting new point for navigation and go there.
	#If player is spotted on the way switch to chacing it
	
	if nav_agent.is_target_reached():
		nav_target = ChooseNewTarget()
		print(nav_target)
		
	if nav_target != null:
		#print(self.global_transform.origin)
		update_target_location(nav_target.global_transform.origin)

func ChooseNewTarget():
	var entity_targets = get_tree().get_nodes_in_group("entity_target")
	return entity_targets[randi() % entity_targets.size()]

func _on_timer_chase_timeout():
	pass # Replace with function body.


func _on_timer_loiter_timeout():
	ResetTimers()
	playsound(audio_player,"res://assets/sounds/monster-angry.ogg")
