extends Control

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	global.day += 1
	get_tree().change_scene("res://MainScene.tscn")
