extends Node3D


@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var AreaOpen:Area3D = $Area3D
@onready var canInteract = false

@export var automatic:bool = true
@export var isOpen:bool = false
@export var hasShelving:bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	if automatic:
		randomize()
		isOpen = bool(randi() % 2 == 0)
		randomize()
		hasShelving = bool(randi() % 2 == 0)
	
	if isOpen:
		anim.play("Open")
	if not hasShelving:
		$shelving.queue_free()
		
	anim.play("GetIn")

func PlayerInterracts():
	if isOpen:
		anim.play_backwards("Open")
		isOpen = false
	else:
		anim.play("Open")
		isOpen = true
		#anim.play_backwards("Open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and canInteract:
		PlayerInterracts()


func _on_area_3d_body_entered(body):
	if body.name == "Player_v2":
		canInteract = true
		if body.has_method("PlayerHides"):
			body.PlayerHides(true)

func _on_area_3d_body_exited(body):
	if body.name == "Player_v2":
		canInteract = false
		if body.has_method("PlayerHides"):
			body.PlayerHides(false)
