extends Node2D

var backAndForth:bool = true
var pos:int = 1
var runningTwee
@export var speed:float =  16.0
var tweenCreated=false
var tween
# Called when the node enter
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(backAndForth):
		var duration =($Node2D.position-$Line2D.points[pos]).length()/(3*speed)
		if tweenCreated==false:
			tween=create_tween()
			tweenCreated=true
			
		
			tween.tween_property($Node2D,"position",$Line2D.points[pos],duration)
		
		await tween.finished
		tweenCreated=false
		if($Node2D.position==$Line2D.points[pos]):
		
			if(pos==$Line2D.points.size()-1):
				pos =0
			else:
				pos +=1
	pass
