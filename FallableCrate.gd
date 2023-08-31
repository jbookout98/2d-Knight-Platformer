extends StaticBody2D

@onready var broken= preload("res://breakCrate.tscn")
@onready var shake = preload("res://Shake.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func SpawnAnimationAndDeleteCrate():
	var instanced = broken.instantiate()
	self.get_parent().add_child(instanced)
	instanced.global_position = self.global_position
	self.queue_free()
	
	pass



func _on_area_2d_body_entered(body):
	if(body.name=="Player"):
		var p = shake.instantiate()
		self.add_child(p)
		
		p.position =Vector2(0,0)
		$Sprite2D.visible=false
		$AnimationPlayer.play("Shake")
	pass # Replace with function body.
