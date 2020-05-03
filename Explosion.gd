extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance.mesh.radius = 0.001
	$MeshInstance.mesh.height = 0.001

func _process(delta):
	$MeshInstance.mesh.radius += .1
	$MeshInstance.mesh.height += .2
	$CollisionShape.shape.radius += .1
	
	if $MeshInstance.mesh.radius >= 4:
		queue_free()


func _on_Explosion_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
