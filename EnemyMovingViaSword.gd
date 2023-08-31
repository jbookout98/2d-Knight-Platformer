extends CharacterBody2D

var activated:bool = false
@export var dir = Vector2(1,0)
@export var speed = 15.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(activated):
		self.move_and_collide(dir*speed*delta)
	pass


func _on_area_2d_body_entered(body):
	
	if("Player" in body.name):
		activated=true
		
	
	pass # Replace with function body.
