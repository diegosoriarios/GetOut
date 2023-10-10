extends Area

var speed: float = 30.0
var damage: int = 1
onready var Blood = preload("res://Blood.tscn")

func _process (delta):
	translation += global_transform.basis.z * speed * delta


func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		var blood = Blood.instance()
		blood.translation = translation
		blood.emitting = true
		get_parent().add_child(blood)
		body.take_damage(damage)
		destroy()

func destroy():
	queue_free()

func headshot():
	var blood = Blood.instance()
	blood.translation = translation
	blood.emitting = true
	get_parent().add_child(blood)
	print("headshot")
	destroy()
