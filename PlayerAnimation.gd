extends AnimatedSprite2D


@onready var playerController = self.get_parent().get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	var cAnim = applyAnimation()
	
	if(self.animation!=cAnim):
		
		self.play(cAnim)
	
func applyAnimation():
	
	var currentAnimation=""
	if(playerController.playerDead==false)	:
		if(playerController.swordThrown==false):
			if(playerController.is_on_floor()==true):
				
				if(playerController.velocity.x==0 ):
						currentAnimation="IdleS"
				
				elif(playerController.isPushing==false):
					currentAnimation="RunS"
				else:
					currentAnimation="RunPushS"
				if(playerController.shotTrigger):
					currentAnimation="CatchSword"
			else:
				if(playerController.velocity.y<0):
						currentAnimation="JumpS"
				elif(playerController.velocity.y>0):
					currentAnimation="FallS"
				if(playerController.shotTrigger):
					currentAnimation="CatchSwordAir"
			
		else:
			if(playerController.is_on_floor()==true):
				
				if(playerController.velocity.x==0 ):
						currentAnimation="Idle"
				
				elif(playerController.isPushing==false):
					currentAnimation="Run"
				else:
					currentAnimation="RunPush"
				if(playerController.shotTrigger):
					currentAnimation="FireSword"
					
			else:
				if(playerController.velocity.y<0):
						currentAnimation="Jump"
				elif(playerController.velocity.y>0):
					currentAnimation="Fall"
				if(playerController.shotTrigger):
					currentAnimation="FireSwordAir"
			
	return currentAnimation
		
	

	
