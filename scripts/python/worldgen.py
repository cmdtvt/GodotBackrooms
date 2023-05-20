import random

world = {}
size = 10

x = 0
y = 0
original_x = 0
original_y = 0

def getDirection(x,y):
	direction = random.choice(["up","down","left","right"])

	if direction == "up":
		y -=1
	elif direction == "down":
		y += 1
	elif direction == "left":
		x -= 1
	elif direction == "right":
		x += 1
	return [x,y]

def Render(world):
	temp = world
	string = ""


	for y in range(10):
		string += "\n"
		for x in range(10):
			if (x,y) in world:
				string += world[(x,y)]
	print(string)




for s in range(size):
	while True:
		original_x = x
		original_y = y
		vals = getDirection(x,y)
		x = vals[0]
		y = vals[1]
		key = (x,y)


		if key in world:
			x = original_x
			y = original_y
		else:
			world[key] = "X"
			break
		
'''
for y in range(10):
	for x in range(10):
		if (x,y) not in world:
			world[(x,y)] = "O"
'''


Render(world)
