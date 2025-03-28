extends Camera3D

var is_rendering = false
@export var level_name: String = ""

@export var tile_count_x = 0
@export var tile_count_y = 0
@export var pack_output = false
@export var output_folder:String = ""
var step_size = 0
var step_size_z = 0
var aspect_ratio = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Automatische Anpassung an Viewport-Breite
	var distance = abs(global_transform.origin.y)  # Entfernung zur Spielebene
	step_size =  2.0 * tan(fov * 0.5) * distance
	var viewport_size = get_viewport().size
	var step_size_z = viewport_size.y * 0.01 / 2
	
func get_world_height():
	var top_screen = Vector3(512, 0, 0)     # Oberer Bildschirmrand
	var bottom_screen = Vector3(512, 1024, 0)  # Unterer Bildschirmrand
	
	var world_top = unproject_position(top_screen)
	var world_bottom = unproject_position(bottom_screen)
	
	return abs(world_bottom.y - world_top.y)
	

func test_camera_movement():
	var screen_bottom = Vector3(512, 1024, 0)  # Punkt am unteren Rand des Viewports
	
	# Weltposition VOR der Bewegung
	var world_before = unproject_position(screen_bottom)
	print("World Position BEFORE move:", world_before)
	
	# Kamera um eine kleine Test-Strecke verschieben (z. B. 100)
	global_position.z += 100
	
	# Weltposition NACH der Bewegung
	var world_after = unproject_position(screen_bottom)
	print("World Position AFTER move:", world_after)
	
	# Tatsächliche Z-Verschiebung berechnen
	var diff_z = world_after.y - world_before.y
	print("Test Step Z: 100, Actual Step Z:", diff_z)

func measure_correct_z_shift():
	var screen_bottom = Vector3(512, 1024, 0)  # Unterer Rand des Screens
	
	# Weltposition VOR der Bewegung
	var world_before = unproject_position(screen_bottom)
	print("World Position BEFORE move:", world_before)
	
	# Kamera um die Bildschirmhöhe (size) verschieben
	position.z += size
	
	# Weltposition NACH der Bewegung
	var world_after = unproject_position(screen_bottom)
	print("World Position AFTER move:", world_after)
	
	# Exakte benötigte Z-Verschiebung berechnen
	var correct_z_step = world_after.y - world_before.y
	print("Correct Z Step:", correct_z_step)

func jump_and_render():
	await RenderingServer.frame_post_draw 
	var counter = 0
	var format = get_viewport().get_texture().get_image().get_format()
	var complete_map = Image.create_empty(tile_count_x * 1024, tile_count_y * 1024, false, format)
	var x = 0
	var y = 0
	var start_pos = global_position
	var window_width = 1024  # Ersetze dies mit deiner Fensterbreite
	var screen_bottom = Vector2(512, 1024)
	for p_index in tile_count_x * tile_count_y:
		#keep_aspect = KEEP_WIDTH
		await RenderingServer.frame_post_draw 
		#print(step_size_z)
		var image = self.get_viewport().get_texture().get_image()
		image.save_png(output_folder + str(counter) + ".png")
		global_position.x += size
		if pack_output == true:
			complete_map.blend_rect(image,Rect2i(0,0,1024,1024), Vector2(x * 1024,y * 1024))
		counter += 1
		x += 1
		if x >= tile_count_x:
			y += 1
			x = 0
			global_position.x = start_pos.x
			global_position.z += 71
	if pack_output == true:
		complete_map.save_png(output_folder + "level01_complete.png")
	get_tree().quit(0)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_rendering == false:
		jump_and_render()
		is_rendering = true
	
		
