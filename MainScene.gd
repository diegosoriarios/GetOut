extends Spatial

onready var material = preload("res://Wood.tres")

onready var Enemy = preload("res://enemy.tscn")
func _ready():
	randomize()
	for i in $Node/House.get_surface_material_count():
		print($Node/House.set_surface_material(i, material))

func _on_Timer_timeout():
	var enemy = Enemy.instance()
	var pos = rand_range(0, 3)
	if int(pos) == 0:
		enemy.translation = $Position3D.translation
	elif int(pos) == 1:
		enemy.translation = $Position3D2.translation
	else:
		enemy.translation = $Position3D3.translation
	add_child(enemy)
