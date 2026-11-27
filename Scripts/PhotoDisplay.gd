
extends Control

@onready var albumDisplay: GridContainer = $CenterContainer/AlbumDisplay
@onready var rightArrow = $CenterContainer/rightArrow
@onready var leftArrow = $CenterContainer/leftArrow

var currentPage = 0
var slots = 9
var pages: Array[GridContainer] = []

func _ready():
	pages.append(albumDisplay)
	loadAlbum()

func loadAlbum():
	var photos = PhotoAlbum.photos

	if photos.is_empty():
		print("No photos found")
		return

	#gets pages basaed on how many photos taken
	var pageCount = ceili(float(photos.size()) / slots)


	#creates enough album displays based on pages
	for i in range(1, pageCount):
		var newPage = albumDisplay.duplicate()
		albumDisplay.get_parent().add_child(newPage)
		#hide other pages as they are made. only want page we are on
		newPage.hide()
		pages.append(newPage)

	for i in range(photos.size()):
		var pageIndex = i / slots
		var slotIndex = i % slots

		var page = pages[pageIndex]
		var slot = page.get_child(slotIndex)
		var photo = slot.get_node("Photo")

		var texture = ImageTexture.create_from_image(photos[i])
		photo.texture = texture



func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if rightArrow.get_rect().has_point(rightArrow.to_local(event.position)):
				nextPage()

			elif leftArrow.get_rect().has_point(leftArrow.to_local(event.position)):
				previousPage()
	if Input.is_action_pressed("Album"):
		visible = !visible
				
func nextPage():
	if currentPage < pages.size() - 1:
		pages[currentPage].hide()
		currentPage += 1
		pages[currentPage].show()


func previousPage():
	if currentPage > 0:
		pages[currentPage].hide()
		currentPage -= 1
		pages[currentPage].show()
