extends CharacterBody3D
class_name Mineral

@export var vidaMax: int = 3
@onready var vida: int = vidaMax 
@onready var carried: bool = false

func eliminarme():
	print("I WAS PLAYED")
	self.queue_free()

func picar() -> bool:
	print("OUCH")
	vida -= 1
	if vida > 0:
		return false
	else:
		return true
