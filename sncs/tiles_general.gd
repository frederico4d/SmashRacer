extends Spatial
var Type = "" # "flat" "obstacle" "hole"

func _ready():
	pass # Replace with function body.

func _on_Tile_flat_visibility_changed():
	if visible == false:
		queue_free()
