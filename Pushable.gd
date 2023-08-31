extends CharacterBody2D
class_name Pushable
var direction = 1
@export var canDebug = false
@export var pushSpeed =90

var thingAbove = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("Pushable")
	pass # Replace with function body.

var isPushed:bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Input.get_axis("game_left", "game_right")
	if(is_on_floor()==false):
		applyGravity(delta)
	else:
		velocity.y=0
	if $RayCast2D.get_collider():
		if($RayCast2D.get_collider().is_in_group("Pushable")):
			thingAbove =$RayCast2D.get_collider().thingAbove+1
	else:
		thingAbove=0
	if(isPushed and thingAbove<1):
		
		if(direction!=0):
			velocity.x=pushSpeed*direction
		
	else:
		velocity.x=0
	
	move_and_slide()
	isPushed=false


func RemoveFore():
	isPushed=false


func applyGravity(delta):
	
	velocity.y+=640*delta


	pass # Replace with function body.
