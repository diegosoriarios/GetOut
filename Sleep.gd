extends Control

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	global.day += 1
	global.food -= 50
	global.water -= 50
	global.temp -= 5
	get_tree().change_scene("res://MainScene.tscn")
