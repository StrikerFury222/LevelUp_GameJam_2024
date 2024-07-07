extends Node3D
class_name AdministradorJuego

var trabajador: Node = null
var camara: Camara3D = null
var RAYCAST_LENGTH: float = 100

var dragging: bool = false
var clicked = false
var holded = false
var unclicked = false
var body = null
var body2 = null
var place = Vector3.ZERO

@export var spawnContratar: PackedScene = null 
@onready var costeContratar = 5
@onready var baseCristales = $Base

@export var spawnCristal: PackedScene = null 
@onready var segundosSpawn: float = 1.0
@onready var tiempoSpawn: float = 0
@onready var rng = RandomNumberGenerator.new()

@export var spawnIluminado: PackedScene = null 
@onready var chanceIluminado: float = 20 
@export var spawnOscuro: PackedScene = null 
@onready var chanceOscuro: float = 20

const max_H = 240
const min_H = 230
const max_V = 250
const min_V = 240

var vendingMachine = false

#Senales
signal signal_oscuro
signal signal_iluminado
signal signal_trabajador
signal signal_muerte_oscuro
signal signal_muerte_iluminado

@onready var numOscuros = 1
@onready var numIluminados = 0
@onready var numTrabajadores = 2


func _input(event):
	if Input.is_action_just_pressed("Click_press"):
		#print("PRESSED")
		clicked = true
		holded = true
	elif Input.is_action_just_released("Click_press"):
		#print("RELSEASED")
		unclicked = true
		holded = false

func _physics_process(delta):
	tiempoSpawn += delta
	if tiempoSpawn >= segundosSpawn:
		tiempoSpawn = 0
		segundosSpawn = rng.randf_range(30,60)
		print("Next in: ", segundosSpawn)
		var numToSpawn = rng.randi_range(5,10)
		print("¡",numToSpawn," METEORITOS!")
		for i in numToSpawn:
			var nodo = spawnCristal.instantiate()
			nodo.position = Vector3(rng.randf_range(min_H+3,max_H-3),5,rng.randf_range(min_V+2,max_V-5))
			#print(nodo.position)
			add_child(nodo)
			nodo.setFall(rng)
		if rng.randf_range(0,100) < chanceOscuro:
			var nodo = spawnOscuro.instantiate()
			nodo.position = Vector3(rng.randf_range(min_H+2,max_H-2),0,rng.randf_range(min_V+2,max_V-5))
			if nodo.position.x < 235 and nodo.position.x > 231:
				nodo.position.x = 231
			elif nodo.position.x < 238 and nodo.position.x >= 235:
				nodo.position.x = 238
			add_child(nodo)
			nodo.setSpawn()
			nodo.administrador = self
	
	if clicked:
		clicked = false
		#print("SHOOT")
		var spaceState = get_world_3d().direct_space_state
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var origin: Vector3 = camara.project_ray_origin(mouse_pos)
		var end: Vector3 = origin + camara.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin,end)
		#query.collide_with_bodies = true
		query.collision_mask = 0x0009
		var rayResult:Dictionary = spaceState.intersect_ray(query)
		if rayResult.size() > 0:
			var hit = rayResult.get("collider")
			print(hit.get_groups()[0])
			if hit.get_groups().size() > 0:
				if hit.get_groups()[0] == "Trabajador" and not hit.dying:
					if hit.carry == null:
						body = hit
						body.holded = true
						body.sensorMinerales.empty()
						place = body.global_position
				elif hit.get_groups()[0] == "Contratar":
					vendingMachine = false
					body2 = hit
					body2.spriteContratar.frame=1
				elif hit.get_groups()[0] == "Vending":
					vendingMachine = true
					body2 = hit
					body2.animationVending.play("Off")
				
			#print(rayResult.get("Shape"))
			#place.global_position = rayResult.get("position")
	elif holded and body != null:
			var spaceState = get_world_3d().direct_space_state
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			var origin: Vector3 = camara.project_ray_origin(mouse_pos)
			var end: Vector3 = origin + camara.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
			var query = PhysicsRayQueryParameters3D.create(origin,end)
			#query.collide_with_bodies = true
			var rayResult:Dictionary = spaceState.intersect_ray(query)
			if rayResult.size() > 0:
				var hit = rayResult.get("collider")
				if hit.get_groups().size() > 0 and hit.get_groups()[0] == "Suelo":
					place = rayResult.get("position")
					body.global_position = Vector3(place.x,body.global_position.y,place.z)

	elif unclicked:
		unclicked = false
		if body != null:
			body.holded = false
			body = null
		elif body2 != null:
			if baseCristales.numCristales >= costeContratar:
				body2.animationVending.play("Spawn")
				numTrabajadores += 1
				#var spawnedNode = spawnContratar.instantiate()
				#baseCristales.numCristales = baseCristales.numCristales - costeContratar
				#add_child(spawnedNode)
				#spawnedNode.global_position = Vector3(baseCristales.global_position.x+0.05,baseCristales.global_position.y,baseCristales.global_position.z+0.05)
			else:
				body2.animationVending.play("On")
			body2 = null



@onready var m_construccion_earlygame = $m_construccion_earlygame
@onready var m_luminosos = $m_luminosos
@onready var m_oscuros = $m_oscuros
@onready var m_construccion_midgame = $m_construccion_midgame
@onready var m_construccion_lategame = $m_construccion_lategame
# Called when the node enters the scene tree for the first time.
func _ready():
	camara = $Camera3D
	#m_construccion_midgame.stream_paused = true
	#m_construccion_lategame.stream_paused = true
	AudioServer.set_bus_volume_db(3,-80)
	AudioServer.set_bus_volume_db(4,-80)
	AudioServer.set_bus_volume_db(5,-80)
	AudioServer.set_bus_volume_db(6,-80)
	#place = debugVar.instantiate()
	#add_child(place)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camara = $Camera3D
	var poblacionTotal: float = numIluminados + numTrabajadores + numOscuros
	var porcentajeIluminados = numIluminados / poblacionTotal
	AudioServer.set_bus_volume_db(4,-60 + int(porcentajeIluminados * 50))
	var porcentajeOscuros = numOscuros / poblacionTotal
	AudioServer.set_bus_volume_db(3,-60 + int(porcentajeOscuros * 50))
	print(porcentajeOscuros * 80)
	
	if baseCristales.numCristales <= 30:
		AudioServer.set_bus_volume_db(1,-10)
		AudioServer.set_bus_volume_db(5,-80)
		AudioServer.set_bus_volume_db(6,-80)
	elif baseCristales.numCristales <= 60:
		AudioServer.set_bus_volume_db(1,-80)
		AudioServer.set_bus_volume_db(5,-10)
		AudioServer.set_bus_volume_db(6,-80)
	else:
		AudioServer.set_bus_volume_db(1,-80)
		AudioServer.set_bus_volume_db(5,-80)
		AudioServer.set_bus_volume_db(6,-10)
		



func _on_signal_iluminado():
	numIluminados += 1
	numTrabajadores -=1

func _on_signal_oscuro():
	numOscuros += 1
	numTrabajadores -=1

func _on_signal_trabajador():
	numTrabajadores +=1

func _on_signal_muerte_iluminado():
	numIluminados -= 1

func _on_signal_muerte_oscuro():
	numOscuros -= 1
