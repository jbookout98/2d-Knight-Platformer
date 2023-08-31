extends CharacterBody2D

var goalPosition:Vector2=Vector2.ZERO
var speed = 16
var t= 0.0
var timeStart=0.0
var goTowards=true
var duration =1.0
var origin
var tween 
var tweenEndTime=0.0
var hit :bool=false
var beingDrawnBack:bool = false
var direction
@onready var collision = $CollisionShape2D
@onready var dustSpawned = preload("res://SwordDust.tscn")
var dustBits :bool = true
var falling: bool =false
var prematureEnded:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	origin = self.position
	tween = get_tree().create_tween()

	$AnimatedSprite2D.play("moving")
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if(falling):
		
	
	if(goTowards):
		
		#find distance 
		#you want to find duration
		#speed = 200
		

		
		var time = (goalPosition-origin).length()/640
		
		tween.tween_property(self,"global_position",goalPosition,time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		goTowards=false
		
	else:
		if(tween.is_running()==false):
			$AnimatedSprite2D.play("default")
			tweenEndTime+=delta
			self.collision_layer=1
			self.collision_mask=1
			if(collision!=null):
				collision.call_deferred("set_disabled",false)
			if(dustBits and prematureEnded==false):
				SpawnDustHere(self.position)
		else:
		
			self.collision_layer=2
			self.collision_mask=2
	pass
	
	

func removeOneWay():
	
	$CollisionShape2D.set_deferred("one_way_collision",false)
func deactivateSwordCollision():
	if(tween.is_running()==true):
		prematureEnded=true
	tween.stop()
	collision.queue_free()
	return true
func SpawnDustHere(p):
	var dust=dustSpawned.instantiate()
	self.get_parent().add_child(dust)
	dust.position = p
	if(scale.x==-1):
		dust.scale.x=-1
	else:
		dust.rotation= self.rotation
	dustBits=false
func _on_area_2d_body_entered(body):
	if(body.is_in_group("Breakable")):
		if(tweenEndTime<=0.2):
			body.isHitBySword()
	
	if beingDrawnBack==false:
		#Reparent
		
		falling = true
		pass
		#Activate a falling object
	
			
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if(beingDrawnBack):
		print("Drop No Matter what")
	pass # Replace with function body.
