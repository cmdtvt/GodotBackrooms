extends Node

@onready var light = $Light
@onready var light_omni = $OmniLight3D
var timer = 0
var timer_limit = 10 # in miliseconds
var ison = true
var safe = randi_range(0,100)
var timer_offset = randi_range(0,15)


#@export_flags("True","False", "Auto") var isSafe

# Called when the node enters the scene tree for the first time.
func _ready():

	timer -= timer_offset
	if safe > 50:
		safe = true
	else:
		safe = false

		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if safe == false:
		if (timer > timer_limit):
			timer -= timer_limit
		
			if ison:
				light_omni.hide()
				light.hide()
				ison = false
			else:
				ison = true
				light_omni.show()
				light.show()
		
		
		
		
	
