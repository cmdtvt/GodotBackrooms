extends Node3D

@export_flags("Floor", "Wall", "Ceiling") var decotype = 0
@export_flags("Any","Small", "Medium", "Large") var decosize = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Debug.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
