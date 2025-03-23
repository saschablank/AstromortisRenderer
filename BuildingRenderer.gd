extends Node3D

var is_render_taken: bool = false
@export var building_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_render_taken == false and building_name.is_empty() == false:
		var image: Image = $Camera3D.get_viewport().get_texture().get_image()
		image.save_png("res://output/buildings/" + building_name + ".png" )
		get_tree().quit(0)
