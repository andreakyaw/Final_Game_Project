extends Node
#gets images from the screenshots folder

var photos: Array[Image] = []

#the folder
const PHOTO_DIR = "user://screenshots/"

#load photos
func _ready():
	#open said folder
	var dir = DirAccess.open(PHOTO_DIR)
	
	if dir == null:
		print("no screenshots folder")
		return

	var files = dir.get_files()

	#loads everything from screenshots folder. When we reload game, our beautiful photos are saved
	for file in files:
		var img = Image.new()
		var error = img.load(PHOTO_DIR + file) #load picture
		if error == OK:
			photos.append(img)
			
		
