import json
td = [
    {
        "filename": "room_template.tscn",
        "rotation": 0,
        "sides": {
            "up": None,
            "down": None,
            "left": None,
            "right": None
        },
        "type": None
    },
    {
        "filename": "room_wall_1.tscn",
        "rotation": 0,
        "sides": {
            "up": None,
            "down": None,
            "left": None,
            "right": None
        },
        "type": None
    },
    {
        "filename": "room_wall_2.tscn",
        "rotation": 0,
        "sides": {
            "up": None,
            "down": None,
            "left": None,
            "right": None
        },
        "type": None
    }
]

def CreateAllRotations(td):
	newTiles = []
	for tile in td:
		newTiles.append(tile)
		for rotation in range(1,4):
			newTiles.append(CreateRoomData(tile,rotation))
	return json.dumps(newTiles,indent=4)

#Creates data representation of given tile/room
#but in a different rotation
def CreateRoomData(tile,rotation):
	side_rot = {
		0 : ["up","down","left","right"],
		1 : ["down","left","right","up"],
		2 : ["left","right","up","down"],
		3 : ["right","up","down","left"] 
	}
	side_rot = side_rot[rotation]

	new_tile = {
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




print(CreateAllRotations(td))