extends Spatial

onready var material = preload("res://Wood.tres")
onready var Enemy = preload("res://enemy.tscn")
onready var Balloon = preload("res://Balloon.tscn")
var total_enemies = 1
var enemies = 1

func _ready():
	randomize()
	for i in $Node/House.get_surface_material_count():
		$Node/House.set_surface_material(i, material)
	
	for i in $Node/outhouse.get_surface_material_count() - 1:
		$Node/House.set_surface_material(i, material)
	
	if enemies >= total_enemies:
		$Timer.stop()
		var balloon = Balloon.instance()
		#var pos = rand_range(0, 3)
		var pos = 0
		if int(pos) == 0:
			balloon.translation = $Seller1.translation
		elif int(pos) == 1:
			balloon.translation = $Seller2.translation
		else:
			balloon.translation = $Seller3.translation
		add_child(balloon)


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
	enemies += 1
