extends Node3D

var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var hasHider:bool = false

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var anim_camera:Camera3D = $Camera3D
@onready var AreaOpen:Area3D = $Area3D
@onready var canInteract = false
@onready var player:CharacterBody3D = get_tree().get_root().get_node("Node3D/Player_v2")

@export var automatic:bool = true #Is the locker fully random
@export var isOpen:bool = false #is the locker already open
@export var hasShelving:bool = false #Does the locker have shelves. (player cant enter)


func _ready():
	#Lockers can randomly have shelves so the player cant use them to hide.
	if automatic:
		randomize()
		isOpen = bool(randi() % 2 == 0)
		randomize()
		hasShelving = bool(randi() % 2 == 0)
	

	if not hasShelving:
		$shelving.queue_free()
		
	#anim.play("GetOut")


func _process(delta):
	if canInteract:
		if Input.is_action_just_pressed("interact"):
			if hasHider:
				#part of the code is in animation finished signal
				anim.play("GetOut")
				hasHider = false
				
			else:
				hasHider = true
				anim_camera.make_current()
				anim.play("GetIn")
				
				#Player has functions for making it so that enemies wont detect
				#And also that player character controls are disbled
				player.hide()
				if player.has_method("DisableControls"): #FIXME: I think this is wrong.
					player.PlayerHides(true)
					
		if hasHider:
			# Player can open the locker door a bit and peek.
			if Input.is_action_just_pressed("sprint"):
				anim.play("Peek")
			elif Input.is_action_just_released("sprint"):
				anim.play_backwards("Peek")
				

func _input(event):
	#This makes the locker camera able to look around.
	if event is InputEventMouseMotion:
		if anim_camera != null and hasHider:
		
			anim_camera.rotate_y(-event.relative.x * look_sensitivity)
			anim_camera.rotation.x = clamp(anim_camera.rotation.x, -PI/2, PI/2)


#if player enters lockers detection area.
func _on_area_3d_body_entered(body):
	if body.name == "Player_v2":
		canInteract = true

#If player leaves lockers detection area.
func _on_area_3d_body_exited(body):
	if body.name == "Player_v2":
		canInteract = false


# when player exits locker animation ends. Turn player visible and make enemies to detect player again
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GetOut":
		player.rotation.y = anim_camera.rotation.y
		player.PlayerHides(false)
		player.show()
		player.FocusCamera()
