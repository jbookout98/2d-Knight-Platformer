extends CharacterBody2D


@export var speed = 120.0



@export var jump_timeToPeak :float
@export var jump_time_to_descent:float
@export var jump_height:float

@onready var flash = preload("res://Player/flash.tscn")
@onready var coinFlash = preload("res://Levels/coinFlash.tscn")
@onready var variable_jump_height:float = jump_height/4

@onready var jump_velocity : float = -1*((2.0 * jump_height)/jump_timeToPeak)
@onready var jump_gravity :float = -1*((-2.0*jump_height)/(jump_timeToPeak*jump_timeToPeak))
@onready var variable_jump_gravity:float = (jump_velocity*jump_velocity)/(2*variable_jump_height)
@onready var fall_gravity :float = -((-2.0*jump_height)/(jump_time_to_descent*jump_timeToPeak))


@onready var deathBoop = preload("res://Player/Death.tscn")
@onready var landDust = preload("res://Player/jumpLand.tscn")
@onready var jumpRightDust = preload("res://Player/JumpRight.tscn")
@onready var jumpStraightDust = preload("res://Player/jumpStraight.tscn")
@onready var jumpLeftDust = preload("res://Player/jumpLeft.tscn")
@onready var swordFile = preload("res://Sword.tscn")
@onready var downswordFile = preload("res://DownSword.tscn")
var deathHitBeforeTimer =0.0
var speedFalling=-4
var deleteSwordBuffer = 0.0
var deleteSwords = false
var swordThrown :bool =false
var swordToDelete =null

var deathDirection=1

var landingTimer = 0.0
var isGrounded:bool=false

var coyoteTimeCounter=0
var coyoteTime=.2
var val=0
var jumpReleased=false

var sword_Fired:bool = false
var shotAnimBuffer = 0.0
var shotTrigger=false

var swordShotDirection:Vector2
var distanceToUse=26
var t =0
var playerDead=false
var currentRespawnPoint:Vector2=Vector2(0,-32)
var isPushing :bool =false
var upDownTimer=0.0
var nextLevel=1
var isAbleToLeave=false
var beenInAir =0.0


var flashed = 0.0

func _physics_process(delta):
	
	
	if is_on_floor():
		coyoteTimeCounter=coyoteTime
		val=32
		
		if(isGrounded==false):
			
			isGrounded=true	
			if(beenInAir>0.65):
				var D = landDust.instantiate()
				self.get_parent().add_child(D)
				D.global_position = self.global_position
			landingTimer=0.25
		if(landingTimer>0):
			
			landingTimer-=delta	
		
		beenInAir=0.0
	else:
		isGrounded=false
		beenInAir+=delta
		velocity.y+=get_gravity()*delta
		coyoteTimeCounter-=delta
		val=12
	
	if(Input.is_action_just_pressed("ui_accept") and coyoteTimeCounter>0.0):
		velocity.y=jump_velocity
	
		
		
		if(velocity.x<0):
			var D = jumpRightDust.instantiate()
			self.get_parent().add_child(D)
			D.global_position = self.global_position
			
		elif(velocity.x>0):
			var D = jumpLeftDust.instantiate()
			self.get_parent().add_child(D)
			D.global_position = self.global_position
			
		else:
			
			var D = jumpStraightDust.instantiate()
			self.get_parent().add_child(D)
			D.global_position = self.global_position
		jumpReleased=false
		
	
	elif(Input.is_action_just_released("ui_accept")):
		jumpReleased=true
	if(Input.is_action_just_pressed("ThrowAction")):
		$DrawSwordToPlayer.process_mode=Node.PROCESS_MODE_INHERIT
		SpawnSword()
	
	var upDown = Input.get_axis("game_up","game_down")
	if(upDown!=0):
		upDownTimer+=delta
	else:
		upDownTimer=0
	PushingCheck()
	var direction = Input.get_axis("game_left", "game_right")
	
	if(isAbleToLeave):
		if(Input.is_action_just_pressed("game_up")):
			LevelLoad.nextLevel(nextLevel,self)
			isAbleToLeave=false
	
	if(direction):
		apply_acceleration(direction)
		if(direction != $FlippableObjects.scale.x):
			if(direction>0):
				$FlippableObjects.scale.x=1
			elif(direction<0):
				$FlippableObjects.scale.x*=-1
		if(upDown):
			swordShotDirection= Vector2(0,upDown)
		else:
			swordShotDirection=Vector2(0,0)
	else:
		if(upDown):
			swordShotDirection=Vector2(0,upDown)
		else:
			swordShotDirection=Vector2(0,0)
		set_friction(val)
		
	$FlippableObjects/RayCast2D.rotation=swordShotDirection.angle()	
	shotAnimBuffer-=delta
	if(shotAnimBuffer<0.0):
		shotTrigger=false
	
	
		
	$FlippableObjects/Node2D.position = swordShotDirection*16
	if(upDownTimer>1.5):
		if(velocity.y>0):
			$Target.position = swordShotDirection*48
	else:
		$Target.position = Vector2(0,0)
	if(swordShotDirection.y>0):
		$FlippableObjects/Node2D.position = swordShotDirection*40
	deleteSwordBuffer-=delta

	
	if(playerDead==false):
		move_and_slide()
	else:
		
		if(flashed<=0):
			self.z_index=25
		
			if(deathHitBeforeTimer>=0.1825):
				$FlippableObjects.position+=Vector2(deathDirection*2,speedFalling)
				speedFalling+=pow(4,pow((deathHitBeforeTimer-0.1),3)/11)/2
				
			deathHitBeforeTimer+=delta
		flashed -=delta
func springImpact():
	
	velocity.y=jump_velocity*4

func springDirImpact(speedMult, rotDir):
	velocity = rotDir* jump_velocity*speedMult
func DustDespawn():
		$DustSprite.visible=false
func get_gravity():
	
	if(jumpReleased):
		return variable_jump_gravity if velocity.y<0.0 else fall_gravity
	else:
		return jump_gravity if velocity.y<0.0 else fall_gravity

func set_friction(value):
	velocity.x=move_toward(velocity.x,0,value)
	
func apply_acceleration(dir):
	velocity.x=move_toward(velocity.x,speed*dir,16)

func DisableSwordAttractor():
	$DrawSwordToPlayer.process_mode=Node.PROCESS_MODE_DISABLED




func PushingCheck():
	if($FlippableObjects/RayCast2D.is_colliding()):
		var vec1 = $FlippableObjects/RayCast2D.get_collision_point()
		var vec
		var collidedWith =$FlippableObjects/RayCast2D.get_collider()
		if(collidedWith!=null):
			if(collidedWith.is_in_group("Pushable")):
				if((vec1-$FlippableObjects/RayCast2D.global_position).length()<8):
					isPushing=true
					speed=$FlippableObjects/RayCast2D.get_collider().pushSpeed
					
					$FlippableObjects/RayCast2D.get_collider().isPushed=true
			else:
				speed=112
				isPushing=false

func SpawnAtPosition(objectToSpawn,pos,endPos):
	var object = objectToSpawn.instantiate()
	object.global_position=pos
	object.collision_layer=2
	object.collision_mask=2
	if(swordShotDirection.length()==0):
		if($FlippableObjects.scale.x>0):
			object.scale.x=1.0
			object.actualScale =1.0
		elif($FlippableObjects.scale.x<0):
			object.scale.x=-1.0
			object.actualScale =-1.0
	else:
		if(swordShotDirection.y>0):
			object.rotation=swordShotDirection.angle()
			object.removeOneWay()
		elif(swordShotDirection.y<0):
			object.rotation=swordShotDirection.angle()
	
	object.direction=swordShotDirection
	shotAnimBuffer=0.25

	self.get_parent().add_child(object)
	swordToDelete=object
	pass
	
func SpawnSword():
	
	if swordThrown==false:
		if($FlippableObjects/RayCast2D.get_collider()):
			#Check distance
			
			var distance = ($FlippableObjects/RayCast2D.get_collision_point()-$FlippableObjects/RayCast2D.global_position).length()
			
			if(abs(distance)>11):
				
				shotTrigger=true
				if(swordShotDirection.y!=0):
					SpawnAtPosition(downswordFile,$FlippableObjects/Node2D.global_position,$FlippableObjects/RayCast2D.get_collision_point())
				else:
					SpawnAtPosition(swordFile,$FlippableObjects/Node2D.global_position,$FlippableObjects/RayCast2D.get_collision_point())
				swordThrown=true
				$DrawSwordToPlayer.process_mode=Node.PROCESS_MODE_DISABLED
		else:
			
			print("Cant Throw")
	else:
		
		var direction = (swordToDelete.position-self.position)
		var dist = direction.length()
		direction= direction.normalized()
		deleteSwordBuffer=0.5
		swordToDelete.goTowards=false
		deleteSwords=true
		pass
		
	
	
func IsInExit(nLevel):
	nextLevel=nLevel
	isAbleToLeave=true
func RemovesExit():
	isAbleToLeave=false
func _on_visible_on_screen_notifier_2d_screen_exited():
	if(playerDead):
		deathHitBeforeTimer=0
		speedFalling=-4
		LevelLoad.endsUpDead(self)
	pass # Replace with function body.


func _on_damage_detector_area_entered(area):
	print(area.name)
	if("Spike" in area.name or "Enemy" in area.name ):
		var f =flash.instantiate()
		
		self.add_child(f)
		
		f.position = Vector2.ZERO
		flashed=0.25
		var d = deathBoop.instantiate()
		self.get_parent().add_child(d)
		d.global_position= self.global_position
		#flash freeze for a couple of frames then let the character fall
		playerDead=true
		deathDirection=randi_range(-1,1)
	if "Coin" in area.name:
		var pos = area.global_position
		
		area.queue_free()
		var c = coinFlash.instantiate()
		self.get_parent().add_child(c)
		
		c.global_position =pos
		print(c.global_position)
	pass # Replace with function body.


func _on_damage_detector_body_entered(body):
	
	if("Enemy" in body.name ):
		var f =flash.instantiate()
		
		self.add_child(f)
		
		f.position = Vector2.ZERO
		flashed=0.25
		var d = deathBoop.instantiate()
		self.get_parent().add_child(d)
		d.global_position= self.global_position
		#flash freeze for a couple of frames then let the character fall
		playerDead=true
		deathDirection=randi_range(-1,1)
	pass # Replace with function body.
