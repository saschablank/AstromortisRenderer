extends Node3D

var is_render_taken: bool = false
@export var building_name: String = ""
@export var building_node: Node3D = null


func _ready() -> void:
	pass


func cleanup_image(image: Image):
	var filtered_pixels: Array = []
	for x in range(0,1024):
		for y in range(0,1024):
			var pixel_color: Color = image.get_pixel(x,y)
			if pixel_color != Color(1, 0, 1, 1):
				filtered_pixels.append(Vector2(x,y))
	var size: Vector2 = image.get_size()
	var new_image = Image.create_empty(size.x, size.y,false, Image.FORMAT_BPTC_RGBA)
	print(new_image.get_size())
	print(new_image.decompress())
	for it in filtered_pixels:
		new_image.set_pixel(it.x, it.y, image.get_pixel(it.x, it.y))
	return new_image


func _process(delta: float) -> void:
	if is_render_taken == false and building_name.is_empty() == false:
		is_render_taken = true
		for i in range(0,4):
			await RenderingServer.frame_post_draw 
			var image: Image = $Camera3D.get_viewport().get_texture().get_image()
			image = cleanup_image(image)
			image.save_png("res://output/buildings/" + building_name +"_" + str(i)  + ".png" )
			building_node.rotation_degrees.y += 90
		get_tree().quit(0)
