extends CharacterBody3D
class_name Trabajador

@onready var sensorMinerales: Sensor = $SensorMinerales as Sensor
var target = null
var carry = null
@onready var animation: AnimationPlayer = $Animation as AnimationPlayer
@onready var soul: Sprite3D = $IndicadorAlma
var base_coordinates: Vector3 = Vector3(0,0,0.5)

@export var tiempoLapsoInfluencia: float = 1
var counter: float = 0

var corrupcion: float = 0
@export var minCorrupcion = -255
@export var maxCorrupcion = 5#255
@export var ritmoCorrupcion = 0.1

@export var moveSpeed: float = 5
@export var umbralPicar: float = 0.1

func _physics_process(delta):
	counter += delta
	var moving = false
	if (carry and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
		animation.play("Move")
		moving = true
		if(self.global_position.distance_to(base_coordinates) < umbralPicar):
			carry.eliminarme() #La eliminación se podría hacer con un onCollisionEnter en la nave
			carry = null
			
		else:
			self.velocity = moveSpeed * (base_coordinates - self.global_position).normalized() * delta
			carry.velocity = self.velocity
			move_and_slide()
			carry.move_and_slide()
	elif (sensorMinerales.target and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
		if (sensorMinerales.target_distance < umbralPicar):
			animation.play("Picar")
			moving = true
		else:
			animation.play("Move")
			moving = true
			self.velocity = moveSpeed * sensorMinerales.target_direction.normalized() * delta
			move_and_slide()
	if (counter >= tiempoLapsoInfluencia):
		counter = 0
		corrupcion += sensorMinerales.colisiones.size() * ritmoCorrupcion
		print(corrupcion)
		if (corrupcion >= maxCorrupcion):
			if (carry):
				carry.carried = false
				carry = null
			animation.play("Die")
		elif (not moving):
			animation.play("Standing")
			
func eliminarme():
	print("I'm Dying")
	self.queue_free()

func picar():
	print("Picando...")
	if (sensorMinerales.target and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
		if sensorMinerales.target.picar():
			sensorMinerales.target.carried = true;
			carry = sensorMinerales.target
			#sensorMinerales.remove_body(sensorMinerales.target)
			#sensorMinerales.target.eliminarme()
			#sensorMinerales.target = null
	else:
		animation.play("Standing")

