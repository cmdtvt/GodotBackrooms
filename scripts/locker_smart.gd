extends Node3D

var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var hasHider:bool = false

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var anim_camera:Camera3D = $Camera3D
@onready var AreaOpen:Area3D = $Area3D
@onready var canInteract = false
@onready var player:CharacterBody3D = get_tree().get_root().get_node("Node3D/Player_v2")

@export var automatic:bool = true
@export var isOpen:bool = false
@export var hasShelving:bool = false


func _ready():
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
				player.hide()
				if player.has_method("DisableControls"):
					player.PlayerHides(true)
					
		if hasHider:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				anim.play("Peek")
				

func _input(event):
	if event is InputEventMouseMotion:
		if anim_camera != null and hasHider:
				#print(anim_camera.rotation_degrees)
				#if anim_camera.rotation_degrees.y < 90:
			anim_camera.rotate_y(-event.relative.x * look_sensitivity)
				#anim_camera.rotate_x(-event.relative.y * look_sensitivity)
			anim_camera.rotation.x = clamp(anim_camera.rotation.x, -PI/2, PI/2)
				#print(anim_camera.rotation.y)	



func _on_area_3d_body_entered(body):
	if body.name == "Player_v2":
		canInteract = true


func _on_area_3d_body_exited(body):
	if body.name == "Player_v2":
		canInteract = false



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GetOut":
		player.rotation.y = anim_camera.rotation.y
		player.PlayerHides(false)
		player.show()
		player.FocusCamera()
