extends Area3D

@onready var numCristales: int = 0
@onready var goalCristales: int = 100 
@onready var text := $"../SubViewport/NumCristales"
@onready var viewPort := $"../SubViewport"
@onready var spriteNave := $"../SpriteNave"
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(collectCarry)
	viewPort.size = Vector2(19,40)
	text.set_text(str(numCristales))

func _process(delta):
	var porcentaje: float = float(numCristales)/goalCristales
	if porcentaje < 10:
		spriteNave.frame = 0
	elif porcentaje < 20:
		spriteNave.frame = 1
	elif porcentaje < 30:
		spriteNave.frame = 2
	elif porcentaje < 40:
		spriteNave.frame = 3
	elif porcentaje < 50:
		spriteNave.frame = 4
	elif porcentaje < 60:
		spriteNave.frame = 5
	elif porcentaje < 70:
		spriteNave.frame = 6
	elif porcentaje < 80:
		spriteNave.frame = 7
	elif porcentaje < 90:
		spriteNave.frame = 8
	else:
		spriteNave.frame = 9

func collectCarry(body):
	if body.carry:
		numCristales += body.carry.value
		body.carry.eliminarme() #La eliminación se podría hacer con un onCollisionEnter en la nave
		body.carry = null
		if numCristales > 9:
			viewPort.size = Vector2(36,viewPort.size.y)
		if numCristales > 99:
			viewPort.size = Vector2(54,viewPort.size.y)
		text.set_text(str(numCristales))
