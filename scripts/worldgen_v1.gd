extends Node3D
# Called when the node enters the scene tree for the first time.

var basedir = "res://levels/level0/rooms/"
@export var max_width = 10
@export var max_height = 1
@export var offset = 10

func GetRandomDictKey(dict):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return a


func _ready():
	var allFiles = []
	allFiles = {
		"room_pillar_2": {
			"instance": "room_pillar_2.tscn",
			"direction": 0,
			"sides": {
				"up": "normal",
				"down": "normal",
				"left": "normal",
				"right": "normal"
			},
			"group": "normal"
		},
		"room_wall_corner": {
			"instance": "room_wall_corner.tscn",
			"direction": 0,
			"sides": {
				"up": null,
				"down": null,
				"left": null,
				"right": null
			},
			"group": "deco"
		},
		"room_door": {
			"instance": "room_door.tscn",
			"direction": 0,
			"sides": {
				"up": null,
				"down": null,
				"left": null,
				"right": null
			},
			"group": null
		}
	}
	generator_v2(allFiles)
	#generator_v1()
	
	
	#Handle spawning of the enemy entity.
	#This thing could be moved into the entity itself.
	randomize()
	var entity_spawnpoints = get_tree().get_nodes_in_group("entity_spawn")
	var entity_selected_spawn = entity_spawnpoints[randi() % entity_spawnpoints.size()]
	var entity_tscn = load("res://assets/components/monster.tscn")
	var loaded_entity = entity_tscn.instantiate()
	
	loaded_entity.global_position = entity_selected_spawn.global_position	
	#Why the fuck when we load scene this way it ignores the preset scale??
	loaded_entity.scale = Vector3(0.7,0.7,0.7)
	add_child(loaded_entity)
	
	
#This function should be changed so that it returns the full obj directly from rooms
#not just the name of the index.
func GetValidRoom(currentroom,direction,rooms):
	
	if direction == 1:
		direction = "up"
	elif direction == 2:
		direction = "down"
	elif direction == 3:
		direction = "left"
	elif direction == 4:
		direction = "right"
	
	var cur = rooms[currentroom]
	var wanted = cur["sides"][direction]
	var foundRooms = []
	for room in rooms:
		var temp = rooms[room]["group"]
		if temp == wanted:
			foundRooms.append(room)
			print("Found: "+str(temp)+" | "+str(wanted))
	randomize()			
	return foundRooms[randi() % foundRooms.size()]
	
	'''
	if direction == "up":
		pass
	elif direction == "down":
		pass
	elif direction == "left":
		pass
	elif direction == "right":
		pass
	'''

func generator_v2(roomFiles):
	
	#Muuta world keyt Vector2()
	var max_size = 10
	var cur_size = 0
	var current_x = 0
	var current_z = 0
	var direction = 0
	var world = {[0,0]:"start"}
	var rotations = [0,90,180,360]
	
	
	while cur_size < max_size:
		direction = randi_range(1,4)	
		if direction == 1:
			current_z -= 1
		elif direction == 2:
			current_z += 1
		elif direction == 3:
			current_x -= 1
		elif direction == 4:
			current_x += 1
		
		if [current_x,current_z] not in world:
			
			
			var resp = GetValidRoom("room_pillar_2",direction,roomFiles)
			world[[current_x,current_z]] = resp
			resp = roomFiles[resp]
			
			
			
			#Load tres file
			#TODO: Store loaded room to dict and first check if its theere already
			var scene_trs = load(basedir+resp["instance"])
			var scene = scene_trs.instantiate()

			scene.rotate_y(deg_to_rad(rotations[randi() % rotations.size()]))
			scene.transform.origin = Vector3(current_x*offset,0,current_z*offset)
			$NavigationRegion3D/Rooms.add_child(scene)
			cur_size += 1
			
		else:
			#If place for the room was alreayd taken.
			#Choose random position from already made rooms
			#and continue from there
			#This should remove dublicate rooms on same tile
			var temp = GetRandomDictKey(world)
			current_x = temp[0]
			current_z = temp[0]
			
	$NavigationRegion3D.bake_navigation_mesh()
	print(world)
		
		
	
	

func generator_v1():
	var allFiles = [
		"room_template.tscn",
		"room_wall_1.tscn",
		"room_wall_2.tscn",
		"room_wall_3.tscn",
		"room_pillar.tscn",
		"room_pillar_2.tscn",
		"room_wall_corner.tscn",
		"room_door.tscn",
		"room_door_2.tscn"
	]
	for x in max_width:
		for z in max_width:
			randomize()
			var file = allFiles[randi() % allFiles.size()]
			if file.get_extension() == "tscn":
				var scene_trs = load(basedir+file)
				var scene = scene_trs.instantiate()
				var rotations = [0,90,180,360]

				scene.rotate_y(deg_to_rad(rotations[randi() % rotations.size()]))
				scene.transform.origin = Vector3(x*offset,0,z*offset)
				$NavigationRegion3D/Rooms.add_child(scene)
		print("Loading rooms: "+str(x)+" /"+str(max_width))
	print("Generating Navigatiom...")
	$NavigationRegion3D.bake_navigation_mesh(true)
	print("Navigation Done")
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	#get_tree().call_group("entities", "update_target_location", $Player_v2.global_transform.origin)
