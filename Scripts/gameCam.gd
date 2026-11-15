extends Camera2D

var ssCount = 1;

@onready var focus = $"../Control/Focus"

#inner part of focus, I don't want the frame to be shown in screenshots
@onready var photo = $"../Control/Focus/Photo"


var size
var cropZone:Rect2i
var cameraMode:bool


func _ready():
	focus.visible = false
	cameraMode = false
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		ssCount +=1
	

	cropZone= Rect2i(focus.position, focus.size)



func screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	
	#bruh
	var globalPos = photo.get_global_transform_with_canvas().origin
	
	
	#based on global position...
	var focusRect = Rect2i(Vector2i(globalPos),Vector2i(photo.size))

	var viewportRect = Rect2i(Vector2i.ZERO, img.get_size())
	var cropRect = viewportRect.intersection(focusRect)

	var croppedImg = img.get_region(cropRect)

	
	croppedImg.save_png("user://screenshots/ss"+str(ssCount)+".png")
	ssCount +=1
	

	
func _input(event):
	#if press c, activate picture mode
	if event.is_action_pressed("Camera"):
		cameraModeToggle()
	if event is InputEventMouseMotion:
		# Update our TextureRect's position to the event position.
		
		#CanvasItem local coordinates to screen coordinates
		#basically we need to turn our local coordinates to global ones
		#if you don't, the box will NOT be near cursor
		#https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html headache
		var cursorPosition = event.position
		var whereisthemouse = focus.get_parent().get_global_transform_with_canvas().affine_inverse() * cursorPosition

		focus.set_position(whereisthemouse - (focus.size / 2.0))
	#so if you are handling mouse inputs... if you only include InputEventMouseButton.... it will count press and release
	#fun fact
	if event is InputEventMouseButton and event.pressed and cameraMode:
		screenshot()
		
			
#if pressing c, toggle camera on and off basically
func cameraModeToggle():
	#await get_tree().create_timer(time_in_seconds).timeout <- cool command for delays. thanks reddit
	if(cameraMode):
		focus.visible = false
		cameraMode = false
	else:
		focus.visible = true
		cameraMode = true


	
