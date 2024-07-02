class_name Camara2D
extends Camera2D

@export var base_zoom: float = 1.0
@export var zoom_speed: float = 0.1
@export var zoom_max: float = 2.0
@export var zoom_min: float = 0.25

@export var base_movement_speed = 20
#@export var horizontal_speed: float = 20
#@export var vertical_speed: float = 20

#var tween

var _zoom_actual: float = 1.0 : 
	get: return _zoom_actual
	set(newZoom):
		if (newZoom > zoom_max):
			_zoom_actual = zoom_max
		elif (newZoom < zoom_min):
			_zoom_actual = zoom_min
		else:	
			_zoom_actual = newZoom

var _offsetH_actual: float = 0 :
	get: return _offsetH_actual
	set(newOffset):
		_offsetH_actual = newOffset
		
var _offsetV_actual: float = 0 :
	get: return _offsetV_actual
	set(newOffset):
		_offsetV_actual = newOffset
		
func _unhandled_input(event):
	if event.is_action_pressed("ZoomIn"):
		_zoom_actual = _zoom_actual + zoom_speed
		
	elif event.is_action_pressed("ZoomOut"):
		_zoom_actual = _zoom_actual - zoom_speed
	zoom = Vector2(_zoom_actual, _zoom_actual)
	
	if Input.is_action_pressed("Arriba"):
		print("up")
		_offsetV_actual = _offsetV_actual - base_movement_speed * (_zoom_actual/base_zoom)
	elif Input.is_action_pressed("Abajo"):
		print("down")
		_offsetV_actual = _offsetV_actual + base_movement_speed * (_zoom_actual/base_zoom)
	
	if Input.is_action_pressed("Izquierda"):
		print("left")
		_offsetH_actual = _offsetH_actual - base_movement_speed * (_zoom_actual/base_zoom)
	elif Input.is_action_pressed("Derecha"):
		print("right")
		_offsetH_actual = _offsetH_actual + base_movement_speed * (_zoom_actual/base_zoom)
	position = Vector2(_offsetH_actual, _offsetV_actual)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	#tween = get_tree().create_tween()
	position_smoothing_enabled = true#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
