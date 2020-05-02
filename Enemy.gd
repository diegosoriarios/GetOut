extends KinematicBody

var health: int = 5
var moveSpeed: float = 1.0

var damage: int = 1
var attackRate: float = 1.0
var attackDist: float = 2.0

var scoreToGive: int = 10

onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = get_node("Timer")
onready var Bullets = preload("res://PickupBullets.tscn")
onready var Health = preload("res://PickupHealth.tscn")

func _ready():
	randomize()
	timer.set_wait_time(attackRate)
	timer.start()

func _physics_process(delta):
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	
	move_and_slide(dir * moveSpeed, Vector3.UP)

func take_damage(damage):
	health -= damage
	print("Health" + str(health))
	
	if health <= 0:
		die()

func die():
	player.add_score(scoreToGive)
	var random = rand_range(0, 2)
	if int(random) == 0:
		var bullets = Bullets.instance()
		bullets.translation = translation
		get_parent().add_child(bullets)
	else:
		var health = Health.instance()
		health.translation = translation
		get_parent().add_child(health)
	queue_free()

func attack():
	player.take_damage(damage)

func _on_Timer_timeout():
	if translation.distance_to(player.translation) <= attackDist:
		attack()
