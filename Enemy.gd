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
onready var Explosion = preload("res://Explosion.tscn")
onready var Attack = $Zombie/AnimationPlayer
onready var Walk = $ZombieWalking/AnimationPlayer

export var type = 0

func _ready():
	randomize()
	timer.set_wait_time(attackRate)
	timer.start()
	
	$ZombieWalking/AnimationPlayer.playback_speed = 1.5
	$Zombie/AnimationPlayer.playback_speed = 1.5

	$ZombieWalking/AnimationPlayer.play("ArmaturemixamocomLayer0")
	$ZombieWalking/AnimationPlayer.get_animation("ArmaturemixamocomLayer0").set_loop(true)

func _physics_process(delta):
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	
	$ZombieWalking.look_at(player.translation, Vector3.UP)
	$Zombie.look_at(player.translation, Vector3.UP)
	
	move_and_slide(dir * moveSpeed, Vector3.UP)

func take_damage(damage):
	health -= damage
	print("Health" + str(health))
	
	if health <= 0:
		die()

func die():
	if type == 1:
		var explosion = Explosion.instance()
		explosion.global_transform = global_transform
		get_parent().add_child(explosion)
	player.add_score(scoreToGive)
	var random = rand_range(0, 2)
	if int(random) == 0 or player.ammo < 5:
		var bullets = Bullets.instance()
		bullets.translation = translation
		get_parent().add_child(bullets)
	else:
		var health = Health.instance()
		health.translation = translation
		get_parent().add_child(health)
	queue_free()

func attack():
	$Zombie.visible = true
	$ZombieWalking.visible = false
	$Zombie/AnimationPlayer.play("ArmaturemixamocomLayer0")
	yield($Zombie/AnimationPlayer, "animation_finished")
	$Zombie.visible = false
	$ZombieWalking.visible = true
	$ZombieWalking/AnimationPlayer.play("ArmaturemixamocomLayer0")
	
	damage = int(rand_range(0, 15))
	player.take_damage(damage)

func _on_Timer_timeout():
	if translation.distance_to(player.translation) <= attackDist:
		attack()


func _on_Area_area_entered(area):
	if (area.is_in_group("bullet")):
		take_damage(int(rand_range(2,4)))
		area.headshot()
