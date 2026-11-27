extends Node


#@onready var photos = "/Photo"
@onready var photo: TextureRect = $Photo

func _ready():
	if PhotoAlbum.photos.size() > 0:
		var img = PhotoAlbum.photos[0]
		var tex = ImageTexture.create_from_image(img)
		photo.texture = tex
