class_name Camara3D
extends Camera3D

# No hay zoom
@export var input = Vector3.ZERO
var velocity = Vector3.ZERO

const max_H = 240
const min_H = 230
const max_V = 250
const min_V = 240


const max_speed = 0.1
const accel = 1.5 
const friction = 0.9

func _physics_process(delta):
	camera_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("Derecha")) - int(Input.is_action_pressed("Izquierda"))
	input.y = 0
	input.z = int(Input.is_action_pressed("Abajo")) - int(Input.is_action_pressed("Arriba"))
	return input.normalized()
	
func camera_movement(delta):
	input = get_input()
	
	if input == Vector3.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (2 * friction * delta)
		else:
			velocity = Vector3.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	position += velocity
	if position.x < min_H:
		position.x = min_H
	elif position.x > max_H:
		position.x = max_H
	
	if position.z < min_V:
		position.z = min_V
	elif position.z > max_V:
		position.z = max_V
