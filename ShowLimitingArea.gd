@tool
extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		var mapRect = get_parent().get_used_rect()
		var tileSize = get_parent().cell_quadrant_size
		var worldSizeInPixels = mapRect.size*tileSize/2
		get_parent().center
		shape.extents=worldSizeInPixels
		
	pass
