extends Node3D

var is_render_taken: bool = false
@export var building_name: String = ""
@export var building_node: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_render_taken == false and building_name.is_empty() == false:
		is_render_taken = true
		for i in range(0,4):
			await RenderingServer.frame_post_draw 
			var image: Image = $Camera3D.get_viewport().get_texture().get_image()
			image.save_png("res://output/buildings/" + building_name + "_" +str(i) + ".png" )
			building_node.rotation_degrees.y += 90
		get_tree().quit(0)
			
