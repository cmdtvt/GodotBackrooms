extends Spatial

onready var master_vars = get_node("/root/MasterVariables")

export var forcetype = false
export(String,"default","360cam","oneway","armored_oneway","heat") var type
export var cameraRange = 30
export var speed = 2

var files 
var bodies
var playerPosition
var players = [] # Contains names of player nodes
var startrot
var playerInRange = false
# Called when the node enters the scene tree for the first time.

func _ready():
	$visualizer.queue_free()
	startrot = self.rotation
	
	
	var base = "res://assets/security/models/"
	var file = "camera1.tscn"
	match type:
		"default": # This should select random camera type.
			file = "camera1.tsnc"
			
		"360cam":
			file = "camera1.tscn"
			
		"oneway":
			pass
		"armored_oneway":
			pass
		"heat":
			pass
			
	self.add_child(master_vars.loadRecource(base+file))

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bodies = $CameraDetectArea.get_overlapping_bodies()
	players = []
	for i in bodies:
		if "PlayerController" in i.get_name():
			players.append(i.get_name())
			playerPosition = i.global_transform.origin
			# to detect player use playercontrollers detect(rate) function.
				
	for i in range(0,len(players)):
		var cast
		var foundCast = false
		
		# Check if camera has raycast for the player.
		for x in self.get_children():
			if x.get_name() == "cast_"+players[i]:
				foundCast = true
				break
				
		if foundCast == false: # If not create new raycast.

			cast = RayCast.new()
			cast.transform.origin = Vector3(0,0,0)
			cast.enabled = true
			cast.set_name("cast_"+players[i])
			cast.cast_to = Vector3(0,0,-20)
			self.add_child(cast)
			
		else: # Check if raycast can see the player.
			for cast in self.get_children():
				if "cast_PlayerController" in cast.get_name():
					cast.look_at(playerPosition,Vector3.UP)
					
					if cast.get_collider():
						var target = cast.get_collider()
						print(target.get_name())
						if "PlayerController" in target.get_name():
							if target.has_method("detect"):
								target.detect(speed)
							else:
								target.notdetected()
