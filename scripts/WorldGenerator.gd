extends Node3D


@export var max_rooms = 20
var offset = 10
var world = {}
var loadedInstances = {}
var basedir = "res://levels/level0/rooms/"
var td = [
	{
		"filename": "room_template.tscn",
		"rotation": 0,
		"sides": {
			"up": "normal",
			"down": "normal",
			"left": "normal",
			"right": "normal"
		},
		"type": null
	},
	{
		"filename": "room_wall_1.tscn",
		"rotation": 0,
		"sides": {
			"up": null,
			"down": null,
			"left": null,
			"right": null
		},
		"type": null
	},
	{
		"filename": "room_wall_2.tscn",
		"rotation": 0,
		"sides": {
			"up": null,
			"down": null,
			"left": null,
			"right": null
		},
		"type": "normal"
	}
]


func _ready():
	GenerateV2()

func GenerateV2():
	var max_size = 10
	var cur_size = 0
	var offset = 10 #Size of one tile
	
	var current_x = 0
	var current_z = 0
	var direction = 0
	var world = {[0,0]:"start"}

	var newTiles = CreateAllRotations()
	
	
	#Preload and store instanced rooms
	for tile in newTiles:
		var fname = tile["filename"]

		#var rotation_deg = [0,90,180,360][tile["rotation"]]
		#var loadedTile = load(basedir+fname)
		#loadedTile = loadedTile.instantiate()
		#loadedTile.rotate_y(deg_to_rad(rotation_deg))
		#loadedTile.transform.origin = Vector3(current_x*offset,0,current_z*offset)
		#$NavigationRegion3D/Rooms.add_child(loadedTile)


	while cur_size < max_size:
		var dirc = randi_range(1,4)
		match dirc:
			1:
				current_z -= 1
			2:
				current_z += 1
			3:
				current_x -= 1
			4:
				current_x += 1


		#Check if rooms exsists in position
		if [current_x,current_z] not in world:
			
			
			#FIXME: This should return obj straight not array?
			var ValidRoom = GetValidRoom("room_template.tscn",dirc,newTiles)



			world[[current_x,current_z]] = ValidRoom
			
			#FIXME: This is stupid please convert newTiles to dictionary
			var ValidRoomData = null
			for data in newTiles:
				if data["filename"] == ValidRoom["filename"]:
					ValidRoomData = data

			
			
			
			var rotation_deg = [0,90,180,360][ValidRoomData["rotation"]]
			var loadedTile = load(basedir+ValidRoomData["filename"])
			loadedTile = loadedTile.instantiate()
			loadedTile.rotate_y(deg_to_rad(rotation_deg))
			loadedTile.transform.origin = Vector3(current_x*offset,0,current_z*offset)
			$NavigationRegion3D/Rooms.add_child(loadedTile)
			
			
			
			cur_size += 1
		else:
			#If place for the room was alreayd taken.
			#Choose random position from already made rooms
			#and continue from there
			#This should remove dublicate rooms on same tile
			var temp = GetRandomKeyFromDict(world)
			current_x = temp[0]
			current_z = temp[1]


	print(world)



func GetRandomFromDict(dict):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return dict[a]
	
func GetRandomKeyFromDict(dict):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return a





func GetValidRoom(currentroom,dirc,newTiles):
	
	var dircs = {1:"up",2:"down",3:"left",4:"right"}
	var direction = dircs[dirc]
	
	#Find data for certain rule with given filename
	var cur = null
	for t in newTiles:
		if t["filename"] == currentroom:
			cur = t
			break

	var wanted = cur["sides"][direction]
	var foundRooms = []
	for tile in newTiles:
		#print("yeet")
		#print(tile)
		var temp = tile["type"]
		if temp == wanted:
			foundRooms.append(newTiles)
			print("Found: "+str(temp)+" | "+str(wanted))
	randomize()
	
	#I have no idea why index 0 is needed in foundRooms? Where does the second
	#List come from?
	var randomChoise = foundRooms[0][randi() % foundRooms[0].size()]
	return randomChoise
	


func CreateAllRotations():
	var newTiles = []
	for tile in td:
		newTiles.append(tile)
		for rotation in range(1,4):
			newTiles.append(CreateRoomData(tile,rotation))
	return newTiles

#Creates room's "json" data for certain rotation
func CreateRoomData(tile,rotation):
	var side_rot = {
		0 : ["up","down","left","right"],
		1 : ["down","left","right","up"],
		2 : ["left","right","up","down"],
		3 : ["right","up","down","left"] 
	}
	side_rot = side_rot[rotation]

	var new_tile = {
		"filename": "room_template.tscn",
		"rotation": rotation,
		"sides": {
			"up": tile["sides"][side_rot[0]],
			"down": tile["sides"][side_rot[1]],
			"left": tile["sides"][side_rot[2]],
			"right": tile["sides"][side_rot[3]],
		},
		"type": tile["type"]
	}
	return new_tile
