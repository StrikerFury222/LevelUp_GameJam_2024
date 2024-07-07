extends CharacterBody3D

@onready var areaRecoleccion = $Area3D
@onready var viewPort = $SubViewport

var numCristales: int:
	get:
		return areaRecoleccion.numCristales
	set(newValue):
		areaRecoleccion.numCristales = newValue
		areaRecoleccion.text.set_text(str(numCristales))
	
func _ready():
	var vendingAnimation = $StaticBody3D/AnimationVendingMachine
	vendingAnimation.play("On")
	
func picar() -> bool:
	#print("OUCH")
	if areaRecoleccion.numCristales > 0:
		areaRecoleccion.numCristales -= 1
		if numCristales > 9:
			viewPort.size = Vector2(36,viewPort.size.y)
		if numCristales > 99:
			viewPort.size = Vector2(54,viewPort.size.y)
		areaRecoleccion.text.set_text(str(numCristales))
		return false
	else:
		return true

func _process(delta):
	if numCristales > 9:
		viewPort.size = Vector2(36,viewPort.size.y)
	if numCristales > 99:
		viewPort.size = Vector2(54,viewPort.size.y)
	else:
		viewPort.size = Vector2(19,viewPort.size.y)
