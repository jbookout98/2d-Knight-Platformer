extends Camera2D


@export var Limter:CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if(Limter!=null):
		LimitStuff()
func LimitStuff():
	var mapRect = Limter.shape.extents
	var position = Limter.position
	var left = -mapRect.x+position.x
	
	print(mapRect.x)
	limit_left=left
	limit_right=mapRect.x+position.x
	limit_bottom=mapRect.y+position.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass
