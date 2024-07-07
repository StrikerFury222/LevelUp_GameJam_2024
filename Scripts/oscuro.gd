extends CharacterBody3D
class_name Oscuro

@onready var sensorTrabajadores: Sensor = $SensorTrabajador as Sensor
@onready var sensorMinerales: Sensor = $SensorMineral as Sensor
@onready var sensorNave: Sensor = $SensorNave as Sensor
@onready var sensorIluminados: Sensor = $SensorIluminado as Sensor
@onready var sprite: Sprite3D = $Sprite
@onready var animation = $AnimationPlayer

@export var moveSpeed: float = 30
@export var umbralPicar: float = 0.2
@onready var direction = Vector3.ZERO 
@onready var rng = RandomNumberGenerator.new()

const max_H = 242
const min_H = 228
const max_V = 249.5
const min_V = 238

var target = null

@export var danyo = 1
@export var vidaMax = 100
var vida = vidaMax
@export var tiempoLapsoInfluencia: float = 1
var counter: float = 0
var enabled = true

var spawn = true

#Senales respecto a trabajadores
@export var administrador: Node3D


func setSpawn():
	enabled = false
	if spawn:
		print("Playing spawn")
		animation.play("Spawn")
	else:
		animation.play("Nacer")
		
func enablePlay():
	print("ENABLED")
	enabled = true

func _ready():
	direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
	sensorNave.mineralMode = false
	sensorNave.esVisible = false
	sensorTrabajadores.mineralMode = false
	sensorTrabajadores.esVisible = false
	sensorMinerales.esVisible = false
	sensorIluminados.mineralMode = false
	sensorIluminados.esVisible = false

func _physics_process(delta):
	if vida > 0 and enabled:
		counter += delta
		if (counter >= tiempoLapsoInfluencia):
			#print("Vida Oscuro: ", vida)
			counter = 0
			vida -= (sensorMinerales.colisiones.size() + sensorNave.colisiones.size() + sensorIluminados.colisiones.size()) * danyo
			#print(vida)
		if sensorIluminados.target != null:
			#print("ENEMY")
			target = sensorIluminados.target
			self.velocity = moveSpeed * sensorIluminados.target_direction.normalized() * delta
			updateOrientacion()
			if sensorIluminados.target_distance > umbralPicar:
				animation.play("Move")
				move_and_slide()
			else:
				animation.play("Atacar")
			direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
		elif sensorMinerales.target != null:
			#print("Mineral")
			target = sensorMinerales.target
			self.velocity = moveSpeed * sensorMinerales.target_direction.normalized() * delta
			updateOrientacion()
			if sensorMinerales.target_distance > umbralPicar:
				animation.play("Move")
				move_and_slide()
			else:
				animation.play("Destruir")
			direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
		elif sensorTrabajadores.target != null:
			#print("Worker")
			#print(sensorTrabajadores.colisiones.size())
			target = sensorTrabajadores.target
			animation.play("Move")
			self.velocity = moveSpeed * sensorTrabajadores.target_direction.normalized() * delta
			updateOrientacion()
			if sensorTrabajadores.target_distance > umbralPicar:
				move_and_slide()
			direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
		elif sensorNave.target != null and sensorNave.target.numCristales > 0:
			#print("Nave")
			target = sensorNave.target
			self.velocity = moveSpeed * sensorNave.target_direction.normalized() * delta
			updateOrientacion()
			if sensorNave.target_distance > umbralPicar:
				animation.play("Move")
				move_and_slide()
			else:
				animation.play("Destruir")
			direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
		else:
			#print("Moving")
			target = null
			animation.play("Move")
			self.velocity = moveSpeed/2 * direction.normalized() * delta
			updateOrientacion()
			move_and_slide()
		
		#Limite de desplazamiento
		if position.x < min_H:
			position.x = min_H
			direction.x = -direction.x
		elif position.x > max_H:
			position.x = max_H
			direction.x = -direction.x
		if position.z < min_V:
			position.z = min_V
			direction.z = -direction.z
		elif position.z > max_V:
			position.z = max_V
			direction.z = -direction.z
		position.y = 0
	elif enabled:
		animation.play("Morir")
func eliminarme():
	print("I'm Dying")
	administrador.signal_muerte_oscuro.emit()
	self.queue_free()

func updateOrientacion():
	if self.velocity != Vector3.ZERO:
		sprite.flip_h = self.velocity.x > 0
		

func picar():
	#print("Picando")
	if target != null:
		var result = target.picar()
		if result and target.get_groups().size() > 0 and target.get_groups()[0] == "Mineral"  and not target.carried:
			target.eliminarme() #Elimina el objetivo
			target = null
			direction = Vector3(rng.randfn(-1,1),0,rng.randfn(-1,1))
		elif target.get_groups().size() > 0 and target.get_groups()[0] == "Mineral"  and target.carried:
			target = null
