extends CharacterBody3D
class_name Trabajador

@onready var sensorNave: Sensor = $SensorNave as Sensor
@onready var sensorMinerales: Sensor = $SensorMinerales as Sensor
var target = null
var carry = null
@onready var animation: AnimationPlayer = $Animation as AnimationPlayer
@onready var soul: Sprite3D = $IndicadorAlma
@onready var sprite: Sprite3D = $Idle
var base_coordinates: Vector3 = Vector3(250,0,250)

@export var tiempoLapsoInfluencia: float = 1
var counter: float = 0

var corrupcion: float = 0
@export var minCorrupcion = -255
@export var maxCorrupcion = 255#8.5
@export var ritmoCorrupcion = 0.1

@export var moveSpeed: float = 5
@export var umbralPicar: float = 0.2

@onready var hitBox = $CollisionShape3D
@onready var holded: bool = false


const max_H = 280
const min_H = 210
const max_V = 280
const min_V = 205

func _ready():
	sensorNave.mineralMode = false

func _physics_process(delta):
	if (not holded):
		counter += delta
		var moving = false
		if (carry and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
			animation.play("Drag")
			moving = true
			self.velocity = moveSpeed * (base_coordinates - self.global_position).normalized() * delta
			updateOrientacion()
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
				updateOrientacion()
				move_and_slide()
		if (counter >= tiempoLapsoInfluencia):
			counter = 0
			corrupcion += (sensorMinerales.colisiones.size() + sensorNave.colisiones.size()) * ritmoCorrupcion
			if(sensorMinerales.colisiones.size() == 0 and sensorNave.colisiones.size() == 0):
				corrupcion -= ritmoCorrupcion
			#print(corrupcion)
			if (corrupcion >= maxCorrupcion):
				if (carry):
					carry.carried = false
					carry = null
				animation.play("Die")
			elif (not moving):
				animation.play("Standing")
	
	if position.x < min_H:
		position.x = min_H
	elif position.x > max_H:
		position.x = max_H
	if position.z < min_V:
		position.z = min_V
	elif position.z > max_V:
		position.z = max_V
func eliminarme():
	#print("I'm Dying")
	self.queue_free()

func updateOrientacion():
	if self.velocity != Vector3.ZERO:
		sprite.flip_h = self.velocity.x > 0
		if carry:
			if sprite.flip_h:
				carry.global_position = Vector3(global_position.x+0.1, global_position.y-0.1, global_position.z+0.07)
			else:
				carry.global_position = Vector3(global_position.x-0.1, global_position.y-0.1, global_position.z+0.07)
				

func picar():
	#print("Picando...")
	if (sensorMinerales.target and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
		if sensorMinerales.target.picar():
			sensorMinerales.target.carried = true;
			carry = sensorMinerales.target
			if sprite.flip_h:
				carry.global_position = Vector3(global_position.x+0.1, global_position.y-0.1, global_position.z+0.07)
			else:
				carry.global_position = Vector3(global_position.x-0.1, global_position.y-0.1, global_position.z+0.07)
			#sensorMinerales.remove_body(sensorMinerales.target)
			#sensorMinerales.target.eliminarme()
			#sensorMinerales.target = null
	else:
		animation.play("Standing")

