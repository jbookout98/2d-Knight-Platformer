extends Node2D

@onready var player = get_parent()
@onready var FlippableNode = get_parent().get_node("FlippableObjects/Node2D")
var deactivated=false
var swordDeactive = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(player.deleteSwords):
		if(player.swordToDelete.get_parent()==player.get_parent()):
			if(player.swordToDelete!= null):
				
				if(deactivated==false):
					player.swordToDelete.deactivateSwordCollision()
					
					deactivated=true
					swordDeactive=true
				if(swordDeactive):
					var vec1 =FlippableNode.global_position
					
					
					player.swordToDelete.beingDrawnBack =true
					
					if((player.swordToDelete.global_position-vec1).length()>24):
						var dir = (vec1-player.swordToDelete.global_position)
						if(player.swordToDelete.scale.x>0):
							dir = (player.swordToDelete.global_position-vec1)
						
							
						player.swordToDelete.rotation=(dir.angle())
						var vec2 = player.swordToDelete.global_position
						player.t+=delta/0.5
						player.swordToDelete.global_position = lerp(player.swordToDelete.global_position,vec1,player.t)
							
					else:
							
						player.t=0
						
						player.swordToDelete.queue_free()
						player.swordThrown=false
						player.deleteSwords=false
						player.shotAnimBuffer=0.25
						player.shotTrigger=true
						deactivated=false
						self.process_mode=Node.PROCESS_MODE_DISABLED
		else:
			player.swordToDelete.call_deferred("reparent",player.get_parent())
	
	pass
