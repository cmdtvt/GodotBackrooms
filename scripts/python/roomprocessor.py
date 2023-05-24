import tools as kalut

ut = kalut.UtilityTools()

generated = []
rooms = [
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

rooms = [
	"room_template.tscn",
	"room_wall_1.tscn",
	"room_wall_2.tscn",
]


#group kertoo minkä niminen tile on ja sidet ketroo minkä nimisiä
#tilejä haluaa virekkäin
for r in rooms:
	temp = {
		"filename":r,
		"rotation":0,
		"sides":{
			"up":None,
			"down":None,
			"left":None,
			"right":None
		},
		"type": None
		
	}
	generated.append(temp)
print(ut.WriteFile("output.json",generated))