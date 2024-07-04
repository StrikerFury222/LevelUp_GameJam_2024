extends CharacterBody3D

@onready var areaRecoleccion = $Area3D
var numCristales: int:
	get:
		return areaRecoleccion.numCristales
	set(newValue):
		areaRecoleccion.numCristales = newValue
		areaRecoleccion.text.set_text(str(numCristales))
