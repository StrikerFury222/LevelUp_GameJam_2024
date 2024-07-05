extends Area3D
class_name Sensor

var target : CollisionObject3D
@onready var mineralMode: bool = true
@onready var esVisible: bool = true
@onready var sprite = $Sprite3D
@onready var area = $CollisionShape3D

var colisiones = [] :
	get :
		return colisiones
var target_distance:
	get:
		return target.global_position.distance_to(global_position)
var target_direction:
	get:
		return target.global_position - global_position

func _ready():
	body_entered.connect(store_body)
	body_exited.connect(remove_body)

func store_body(body):
	#print("in")
	colisiones.append(body)
func remove_body(body):
	#print("out")
	colisiones.erase(body)

func empty():
	colisiones = []
	target = null
	
func _physics_process(delta):
	if not esVisible:
		sprite.visible = false
	scan()

func scan() -> void:
	target = null # Esto puede ser que cause bugs... O no, quien sabe
	if colisiones.size() == 0:
		#print("Nothing at all")
		return
	var minDistance = -1
	for body in colisiones:
		if (body != null):
			var distance = body.global_position.distance_to(global_position)
			if (distance > area.scale.x):
				print("I did it")
				remove_body(body)
			elif ((target == null or distance < minDistance) and (not mineralMode or not body.carried)):
				target = body
				minDistance = distance
			
		else:
			colisiones.remove(body)
