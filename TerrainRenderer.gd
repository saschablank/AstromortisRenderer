extends Camera3D

var is_rendering = false
@export var level_name: String = ""

@export var tile_count_x = 0
@export var tile_count_y = 0
@export var pack_output = false
var step_size = 0
var step_size_z = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Automatische Anpassung an Viewport-Breite
	var distance = abs(global_transform.origin.y)  # Entfernung zur Spielebene
	step_size =  2.0 * tan(fov * 0.5) * distance


func jump_and_render():
	await RenderingServer.frame_post_draw 
	var counter = 0
	var format = get_viewport().get_texture().get_image().get_format()
	var complete_map = Image.create_empty(tile_count_x * 1024, tile_count_y * 1024, false, format)
	var x = 0
	var y = 0
	var start_pos = global_position
	var window_width = 1024  # Ersetze dies mit deiner Fensterbreite
	for p_index in tile_count_x * tile_count_y:
		await RenderingServer.frame_post_draw 
		print(global_position)
		var image = self.get_viewport().get_texture().get_image()
		image.save_png("res://output/"+ str(counter) + ".png")
		global_position.x += size
		if pack_output == true:
			complete_map.blend_rect(image,Rect2i(0,0,1024,1024), Vector2(x * 1024,y * 1024))
		counter += 1
		x += 1
		if x >= tile_count_x:
			y += 1
			x = 0
			global_position.x = start_pos.x
			# 135 == 180 - 45 i dont fully understand why but it has somthing to do with the rotation of the camera
			global_position.z += size + (180 - abs(rotation_degrees.x)) 
	if pack_output == true:
		complete_map.save_png("res://output/level01_complete.png")
	get_tree().quit(0)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_rendering == false:
		jump_and_render()
		is_rendering = true
	
		
