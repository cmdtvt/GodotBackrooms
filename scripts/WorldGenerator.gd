

extends Node3D


@export var max_rooms = 20
var world = {}
var td = [
	{
		"filename": "room_template.tscn",
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
		"type": null
	}
]


func _ready():
	GenerateV2()

func GenerateV2():
	var newTiles = CreateAllRotations()
	






func CreateAllRotations():
	var newTiles = []
	for tile in td:
		newTiles.append(tile)
		for rotation in range(1,4):
			newTiles.append(CreateRoomData(tile,rotation))
	return newTiles

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
