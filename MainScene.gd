extends Spatial

onready var material = preload("res://Wood.tres")
onready var Enemy = preload("res://Enemy.tscn")
onready var Boomer = preload("res://Boomer.tscn")
onready var Monster = preload("res://Monster.tscn")
onready var Balloon = preload("res://Balloon.tscn")
onready var Tree1 = preload("res://Tree1.tscn")
onready var Tree2 = preload("res://Tree2.tscn")
var total_enemies = 5  + (global.day * 5)
var enemies = 0
var balloon = false

func _ready():
	randomize()
	
	for i in $Node/House.get_surface_material_count():
		$Node/House.set_surface_material(i, material)
	
	print($Node/outhouse.get_surface_material_count())
	for i in $Node/outhouse.get_surface_material_count() - 1:
		$Node/House.set_surface_material(i, material)
	
	var index = 1
	for tree in global.trees:
		if tree:
			if index % 2 == 0:
				var new_tree = Tree1.instance()
				var pos = find_node("Tree" + str(index))
				new_tree.transform = pos.transform
				new_tree.set_index(index)
				add_child(new_tree)
			else:
				var new_tree = Tree2.instance()
				var pos = find_node("Tree" + str(index))
				new_tree.transform = pos.transform
				new_tree.set_index(index)
				add_child(new_tree)
		index += 1
	
	$CanvasLayer/UI/AnimationPlayer.play("FadeOut")

func _process(delta):
	if enemies >= total_enemies and !balloon and global.seller:
		balloon = true
		$Timer.stop()
		var balloon = Balloon.instance()
		print(balloon)
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
	if enemies <= total_enemies:
		var enemy
		if global.day > 6:
			var random = rand_range(0, 3)
			print(random)
			if random > 2:
				enemy = Boomer.instance()
			elif random > 1:
				enemy = Enemy.instance()
			else:
				enemy = Monster.instance()
		elif global.day > 3:
			var random = rand_range(0, 2)
			if random > 1:
				enemy = Enemy.instance()
			else:
				enemy = Monster.instance()
		else:
			enemy = Enemy.instance()
		var pos = rand_range(0, 3)
		if int(pos) == 0:
			enemy.translation = $Position3D.translation
		elif int(pos) == 1:
			enemy.translation = $Position3D2.translation
		else:
			enemy.translation = $Position3D3.translation
		add_child(enemy)
		enemies += 1
