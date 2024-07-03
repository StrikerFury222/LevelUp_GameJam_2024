extends Area3D
class_name Sensor

var target : CollisionObject3D

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
	colisiones.append(body)
func remove_body(body):
	colisiones.erase(body)
	
func _physics_process(delta):
	scan()

func scan() -> void:
	if colisiones.size() == 0:
		#print("Nothing at all")
		return
	target = null # Esto puede ser que cause bugs... O no, quien sabe
	var minDistance = -1
	for body in colisiones:
		if (body != null):
			var distance = body.global_position.distance_to(global_position)
			if ((target == null or distance < minDistance) and not body.carried):
				target = body
				minDistance = distance
		else:
			colisiones.remove(body)
