extends CharacterBody3D
class_name Mineral

@export var vidaMax: int = 5
@onready var vida: int = vidaMax 
@onready var carried: bool = false
@onready var value: int = 5

#@onready var rng = RandomNumberGenerator.new()

var cayendo: bool
var velocidadCaida: Vector3 = Vector3.ZERO
func setFall(rng: RandomNumberGenerator):
	cayendo = true
	velocidadCaida = Vector3(rng.randf_range(-0.7,0.7),-1,rng.randf_range(-0.7,0.7))
	
func _physics_process(delta):
	if cayendo:
		velocity = velocidadCaida
		move_and_slide()
		if position.y < 0:
			cayendo = false


'''
@onready var sprite: Sprite3D = $SpriteMineral
func _physics_process(delta):
	if carried:
		sprite.visible = false
	else:
		sprite.visible = true
'''
func eliminarme():
	#print("I WAS PLAYED")
	self.queue_free()

func picar() -> bool:
	#print("OUCH")
	vida -= 1
	if vida > 0:
		return false
	else:
		return true
