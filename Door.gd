extends Area2D
var isFound=true
@export var levelToGoTo=2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(body):
	if(body.name=="Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($PointLight2D,"energy",2.16,0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		body.IsInExit(levelToGoTo)
	pass # Replace with function body.


func _on_body_exited(body):
	if(body.name=="Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($PointLight2D,"energy",0,0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		body.RemovesExit()
	pass # Replace with function body.
