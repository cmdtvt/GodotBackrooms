extends Node



func isDebugOn():
	return true


func random_chance(chance):
	var randomNumber = randi()%101+1
	if randomNumber == chance:
		return true
	return false

func list_files_in_directory(path):
	var files = []
	#var dir = Directory.new()
	#dir.open(path)
	#dir.list_dir_begin()

	while true:
		#var file = dir.get_next()
		#if file == "":
			break
		#elif not file.begins_with("."):
			#files.append(file)

	#dir.list_dir_end()
	return files


#Use scanFolder instead.
func createBuildingJson(path):
	print("Creating building JSON")
	

	var dict = {}
	var files = list_files_in_directory(path)
	for f in files:
		if not ".tscn" in f:
			dict[f] = {}
			var innerfiles = list_files_in_directory(path+"/"+f)
			dict[f] = innerfiles
			#print(innerfiles)
	return dict


#Scan folder for other folders and files.
#Make dict out of them and return it.
func scanFolder(path):
	var ret = {}
	var files = list_files_in_directory(path)
	var did = false
	for f in files:
		if not ".tscn" in f:
			ret[f] = {}
			var innerfiles = scanFolder(path+"/"+f)
			ret[f] = innerfiles
		else:
			if not did:
				ret = []
				did = true
			ret.push_back(f)
	return ret
	
#Get random scene file from dict. Query defines from which "folder layer" start the search.
func getSceneFromDict(spath):
	var data = scanFolder(spath)
	var current = data
	
	while true:
		#if is array just choose random dont crawl
		if data.size() >= 1:
			data = findRandom(data)
		else:
			print(data)
			break

		
func findRandom(dict):
	var a = dict.keys()
	return a[randi() % a.size()]
