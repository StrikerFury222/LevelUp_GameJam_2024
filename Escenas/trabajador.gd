extends CharacterBody3D
class_name Trabajador

@onready var sensorNave: Sensor = $SensorNave as Sensor
@onready var sensorOscuro: Sensor = $SensorOscuro as Sensor
@onready var sensorMinerales: Sensor = $SensorMinerales as Sensor
@onready var sensorIluminados: Sensor = $SensorIluminado as Sensor
var target = null
var carry = null
@onready var animation: AnimationPlayer = $Animation as AnimationPlayer
@onready var sprite: Sprite3D = $Idle
var base_coordinates: Vector3 = Vector3(235,0,245)

@export var tiempoLapsoInfluencia: float = 1
var counter: float = 0

var corrupcion: float = 0
@export var minCorrupcion = -50#-255
@export var maxCorrupcion = 50#255#8.5
@export var ritmoCorrupcion = 1
@export var ritmoCorrupcionInfluencia = 2

@export var moveSpeed: float = 30
@export var umbralPicar: float = 0.2

@onready var hitBox = $CollisionShape3D
@onready var holded: bool = false

const max_H = 242
const min_H = 228
const max_V = 249.5
const min_V = 238

#Para que tome decisión de moverse
@onready var counterMoveMax: float = 10
var counterMove: float = 0
var moving = false
var direccion = Vector3.ZERO

#RNG
@onready var rng = RandomNumberGenerator.new()

#Para modular el color del alma
@onready var soul: Sprite2D = $SubViewport/Sprite2D
@onready var animSoul = $SubViewport/AnimationSoul
var colorIluminado = [0.5,0]
var colorOscuro = [0.75,0]

var dying = false

func _ready():
	animSoul.play("vibe")
	sensorNave.mineralMode = false
	sensorNave.esVisible = false
	sensorOscuro.mineralMode = false
	sensorOscuro.esVisible = false
	sensorIluminados.mineralMode = false
	sensorIluminados.esVisible = false

func _process(delta):
	if corrupcion < 0:
		#var porcentaje:float = (corrupcion/minCorrupcion)
		#print(porcentaje,"-",corrupcion)
		var color = Color.from_hsv(colorOscuro[0],colorOscuro[1],1,1)
		soul.material.set_shader_parameter("new_colour", color)
		animSoul.play("vibe")
		#print(color)
	else:
		#var porcentaje:float = (corrupcion/maxCorrupcion)
		#print(porcentaje,"-",corrupcion)
		var color = Color.from_hsv(colorIluminado[0],colorIluminado[1],1,1)
		soul.material.set_shader_parameter("new_colour", color)
		animSoul.play("vibe")
	

func _physics_process(delta):
	if (not holded and not dying):
		counter += delta
		counterMove += delta
		#var moving = false
		if (carry != null and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
			animation.play("Drag")
			#moving = true
			self.velocity = moveSpeed * (base_coordinates - self.global_position).normalized() * delta
			updateOrientacion()
			carry.velocity = self.velocity
			move_and_slide()
			carry.move_and_slide()
		elif (sensorMinerales.target != null and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
			if (sensorMinerales.target_distance < umbralPicar):
				animation.play("Picar")
				#moving = true
			else:
				animation.play("Move")
				#moving = true
				self.velocity = moveSpeed * sensorMinerales.target_direction.normalized() * delta
				updateOrientacion()
				move_and_slide()
		else:
			if counterMove > counterMoveMax and not moving:
				animation.play("Move")
				counterMove = 0
				moving = true
				direccion = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
			elif moving:
				counterMove = 0
				self.velocity = moveSpeed/2 * direccion.normalized() * delta
				updateOrientacion()
				move_and_slide()
		if (counter >= tiempoLapsoInfluencia):
			counter = 0
			corrupcion -= (sensorOscuro.colisiones.size() * ritmoCorrupcionInfluencia)
			corrupcion += (sensorMinerales.colisiones.size() + sensorNave.colisiones.size()) * ritmoCorrupcion
			corrupcion += sensorIluminados.colisiones.size() * ritmoCorrupcionInfluencia
			if(sensorMinerales.colisiones.size() == 0 and sensorNave.colisiones.size() == 0 and sensorIluminados.colisiones.size() == 0):
				corrupcion -= ritmoCorrupcion
			print("corrupcion: ",corrupcion)
			#actualizamos el color del shader
			if corrupcion < 0:
				var porcentaje:float = (corrupcion/minCorrupcion)
				colorOscuro[1] = porcentaje
				var color = Color.from_hsv(colorOscuro[0],porcentaje,1,1)
				soul.material.set_shader_parameter("new_colour", color)
				animSoul.play("vibe")
				#print(color)
			else:
				var porcentaje:float = (corrupcion/maxCorrupcion)
				colorIluminado[1] = porcentaje
				var color = Color.from_hsv(colorIluminado[0],porcentaje,1,1)
				soul.material.set_shader_parameter("new_colour", color)
				animSoul.play("vibe")
				#print(color)
			#print(corrupcion)
			if (corrupcion >= maxCorrupcion or corrupcion <= minCorrupcion):
				if (carry):
					carry.carried = false
					carry = null
				animation.play("Die")
				dying = true
			elif (not moving):
				animation.play("Standing")
	else:
		counterMove = 0
		moving = false
	if position.x < min_H:
		position.x = min_H
		direccion.x = -direccion.x
	elif position.x > max_H:
		position.x = max_H
		direccion.x = -direccion.x
	if position.z < min_V:
		position.z = min_V
		direccion.z = -direccion.z
	elif position.z > max_V:
		position.z = max_V
		direccion.z = -direccion.z
	position.y = 0
func eliminarme():
	#print("I'm Dying")
	self.queue_free()

func updateOrientacion():
	if self.velocity != Vector3.ZERO:
		sprite.flip_h = self.velocity.x > 0
		if carry != null:
			if sprite.flip_h:
				carry.global_position = Vector3(global_position.x+0.1, global_position.y-0.1, global_position.z+0.07)
			else:
				carry.global_position = Vector3(global_position.x-0.1, global_position.y-0.1, global_position.z+0.07)
				

func picar():
	#print("Picando...")
	if (sensorMinerales.target != null and corrupcion < maxCorrupcion and corrupcion > minCorrupcion):
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

