extends KinematicBody

var gravity = -1
var vel = Vector3()
var stop = false

func _ready():
	print('aqui')


func _process(delta):
	if global_transform.origin.y <= 0:
		vel.y -= gravity * delta
		vel = move_and_slide(vel, Vector3.UP)
