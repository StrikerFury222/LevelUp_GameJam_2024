extends CharacterBody3D

@onready var areaRecoleccion = $Area3D
var numCristales: int:
	get:
		return areaRecoleccion.numCristales
	set(newValue):
		areaRecoleccion.numCristales = newValue
		areaRecoleccion.text.set_text(str(numCristales))
		
func picar() -> bool:
	#print("OUCH")
	if areaRecoleccion.numCristales > 0:
		areaRecoleccion.numCristales -= 1
		areaRecoleccion.text.set_text(str(numCristales))
		return false
	else:
		return true
