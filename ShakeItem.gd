extends Sprite2D

var t = 0
@onready var mod =get_parent().get_node("Modulate")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	self.position = Vector2(sin(t*32),cos(t*32))
	if(mod !=null):
		mod.position=self.position
	t+=delta
	pass
