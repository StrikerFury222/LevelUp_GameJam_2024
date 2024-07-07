extends CharacterBody3D
class_name Mineral

@export var vidaMax: int = 5
@onready var vida: int = vidaMax 
@onready var carried: bool = false
@onready var value: int = 5
@onready var influencia = $Influencia

#@onready var rng = RandomNumberGenerator.new()

#Para animaciones
@onready var animation = $FallAnimation
@onready var spriteFuego = $Fire
@onready var spriteOre = $SpriteOre
@onready var spriteImpacto = $Impact
@onready var spriteMineral = $SpriteMineral


var cayendo: bool
var impactHappened = false
var velocidadCaida: Vector3 = Vector3.ZERO
func setFall(rng: RandomNumberGenerator):
	
	#animation.play("Fall")
	spriteOre.frame = rng.randi_range(0,2)
	cayendo = true
	influencia.visible = false
	spriteImpacto.visible = false
	spriteMineral.visible = false
	velocidadCaida = Vector3(rng.randf_range(-0.7,0.7),-1,rng.randf_range(-0.7,0.7))
	
func _physics_process(delta):
	if cayendo:
		animation.play("Fall")
		velocity = velocidadCaida
		move_and_slide()
		if position.y < 0:
			cayendo = false
			influencia.visible = true
			spriteFuego.visible = false
			spriteImpacto.visible = true
			position.y = 0
			impactHappened = true
	elif impactHappened:
		animation.play("Impact")


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

func finImpacto():
	animation.stop()
	impactHappened = false
	spriteImpacto.frame = 6

func picar() -> bool:
	#print("OUCH")
	vida -= 1
	if vida > 0:
		return false
	else:
		spriteMineral.visible = true
		spriteOre.visible = false
		spriteImpacto.visible = false
		return true
