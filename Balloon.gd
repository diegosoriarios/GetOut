extends KinematicBody

var gravity = -1
var vel = Vector3()
var stop = false
var away = false
var hp = 3

func _ready():
	pass


func _process(delta):
	if !away:
		if global_transform.origin.y <= 0:
			vel.y -= gravity * delta
			vel = move_and_slide(vel, Vector3.UP)
	else:
		vel.y -= -gravity * delta
		vel = move_and_slide(vel, Vector3.UP)
		if global_transform.origin.y <= -20:
			queue_free()

func go_away():
	$CollisionShape.scale = Vector3(0,0,0)
	vel.y = 0
	away = true


func _on_Area_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= 1
		if hp == 0:
			global.seller = false
			go_away()
