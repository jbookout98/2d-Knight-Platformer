extends Node2D

var base = null
var currentLevel:int=1
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func LoadLevel(value):
	var levelToLoad = load("res://Levels/"+"Level"+str(value)+".tscn")
	var loadedLevel  = levelToLoad.instantiate()
	
	checkIfBase()
	base.add_child(loadedLevel)
	
	loadedLevel.position=Vector2.ZERO
	print(loadedLevel.name)
	base.get_node("Player/Target/Camera2D").Limter=loadedLevel.get_node("TileMap/Limit")
	base.get_node("Player").global_position= Vector2(0,-32)
	
	base.get_node("Player/Target/Camera2D").LimitStuff()

func checkIfBase():
	
	if(base==null):
		var toLoad = load("res://Levels/base_level.tscn")
		base = toLoad.instantiate()
		get_tree().get_root().add_child(base)
	
	return true
	
func startPlay(MenuToBeDeleted,levelToStartAt):
	MenuToBeDeleted.queue_free()
	checkIfBase()
	currentLevel=levelToStartAt
	LoadLevel(currentLevel)
	
	
	
	
	
func nextLevel(nextLev,Player):
	#delete the currentLevel
	checkIfBase()
	Player.currentRespawnPoint=Vector2(0,-32)
	var curr = base.get_node("Level"+str(currentLevel))
	base.remove_child(curr)
	curr.queue_free()
	#Spawn stuff
	LoadLevel(nextLev)
	currentLevel=nextLev
	
	


func endsUpDead(Player):
	#if dead move player back to the current player respawn point
	#player_dead = false
	#enemies respawned maybe
	checkIfBase()
	print(Player.currentRespawnPoint)
	var basedLevel = base.get_node("Level"+str(currentLevel))
	base.remove_child(basedLevel)
	basedLevel.queue_free()
	LoadLevel(currentLevel)
	Player.swordThrown=false
	if(Player.swordToDelete!=null):
		Player.swordToDelete.queue_free()
	Player.velocity.y=0
	Player.get_node("FlippableObjects").position = Vector2.ZERO
	Player.position = Player.currentRespawnPoint
	Player.playerDead=false
	
	
	
	
