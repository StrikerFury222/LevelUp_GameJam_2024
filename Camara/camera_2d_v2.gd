extends Camera2D

@export var input = Vector2.ZERO
var velocity = Vector2.ZERO

const max_speed = 10
const accel = 15 
const friction = 9

@export var base_zoom: float = 1.0
@export var zoom_speed: float = 0.1
@export var zoom_max: float = 2.0
@export var zoom_min: float = 0.25

var checked = 0


var _zoom_actual: float = 1.0 : 
	get: return _zoom_actual
	set(newZoom):
		if (newZoom > zoom_max):
			_zoom_actual = zoom_max
		elif (newZoom < zoom_min):
			_zoom_actual = zoom_min
		else:	
			_zoom_actual = newZoom

func _unhandled_input(event):
	if event.is_action_pressed("ZoomIn"):
		_zoom_actual = _zoom_actual + zoom_speed
	elif event.is_action_pressed("ZoomOut"):
		_zoom_actual = _zoom_actual - zoom_speed
	#zoom = Vector2(_zoom_actual, _zoom_actual)

func _physics_process(delta):
	camera_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("Derecha")) - int(Input.is_action_pressed("Izquierda"))
	input.y = int(Input.is_action_pressed("Abajo")) - int(Input.is_action_pressed("Arriba"))
	return input.normalized()
	
func camera_movement(delta):
	zoom = Vector2(_zoom_actual, _zoom_actual)
	
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (2 * friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	position += velocity
	
