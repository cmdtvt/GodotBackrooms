extends Node3D

var open = null
var hasShelving = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	open = bool(randi() % 2 == 0)
	randomize()
	hasShelving = bool(randi() % 2 == 0)
	
	if open:
		$locker_door.rotate_y(deg_to_rad(110))
	if not hasShelving:
		$shelving.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
