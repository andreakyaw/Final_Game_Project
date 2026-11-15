extends Camera2D

var ssCount = 1;

@onready var focus = $"../Control/Focus"

#inner part of focus, I don't want the frame to be shown in screenshots
@onready var photo = $"../Control/Focus/Photo"


var size
var crop_zone:Rect2i

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		ssCount +=1
	

	crop_zone= Rect2i(focus.position, focus.size)



func screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	
	#bruh
	var global_pos = photo.get_global_transform_with_canvas().origin
	
	
	#based on global position...
	var focus_rect = Rect2i(Vector2i(global_pos),Vector2i(photo.size))

	var viewport_rect = Rect2i(Vector2i.ZERO, img.get_size())
	var crop_rect = viewport_rect.intersection(focus_rect)

	var cropped_img = img.get_region(crop_rect)

	
	cropped_img.save_png("user://screenshots/ss"+str(ssCount)+".png")
	ssCount +=1
	

	
func _input(event):
	if event is InputEventMouseMotion:
		# Update our TextureRect's position to the event position.
		
		#CanvasItem local coordinates to screen coordinates
		#basically we need to turn our local coordinates to global ones
		#if you don't, the box will NOT be near cursor
		#https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html headache
		var whereisthemouse = focus.get_parent().get_global_transform_with_canvas().affine_inverse() * event.position

		focus.set_position(whereisthemouse - (focus.size / 2.0))
	#so if you are handling mouse inputs... if you only include InputEventMouseButton.... it will count press and release
	#fun fact
	if event is InputEventMouseButton and event.pressed:
		screenshot()
		
		


	
