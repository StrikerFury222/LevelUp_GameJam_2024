extends CharacterBody3D
class_name Mineral

@export var vidaMax: int = 5
@onready var vida: int = vidaMax 
@onready var carried: bool = false
@onready var value: int = 5

'''
@onready var sprite: Sprite3D = $SpriteMineral
func _physics_process(delta):
	if carried:
		sprite.visible = false
	else:
		sprite.visible = true
'''
func eliminarme():
	print("I WAS PLAYED")
	self.queue_free()

func picar() -> bool:
	#print("OUCH")
	vida -= 1
	if vida > 0:
		return false
	else:
		return true
