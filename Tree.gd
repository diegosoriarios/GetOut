extends Spatial

export var index = 0
var hp = 5

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_index(value):
	index = value

func cut_tree():
	hp -= 1
	print(hp)
	if hp == 0:
		global.logs += 5
		global.trees[index - 1] = false
		queue_free()
