extends Area3D

@onready var numCristales: int = 0
@onready var goalCristales: int = 100 
@onready var text := $"../SubViewport/NumCristales"
@onready var viewPort := $"../SubViewport"
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(collectCarry)
	viewPort.size = Vector2(19,40)
	text.set_text(str(numCristales))

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
