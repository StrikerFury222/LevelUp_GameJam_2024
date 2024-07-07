extends StaticBody3D

@onready var animationVending = $AnimationVendingMachine
@onready var spawning = false
@onready var spawnContratar = get_parent().sceneTrabajador

func endSpawn():
	spawning = false
	var spawnedNode = spawnContratar.instantiate()
	#get_parent().numCristales = get_parent().numCristales - 5
	get_parent().get_parent().add_child(spawnedNode)
	spawnedNode.global_position = Vector3(235.18,0,245.15) + position
	animationVending.play("On")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
