extends KinematicBody

var curHp: int = 10
var maxHp: int = 10
var ammo: int = 15
var score: int = 0

var moveSpeed: float = 5.0
var jumpForce: float = 5.0
var gravity: float = 12.0

var minLookAngle: float = -90.0
var maxLookAngle: float = 90.0
var lookSensitivity: float = .5

var attackRate : float = 0.3
var lastAttackTime : int = 0
var damage : int = 1
var interact: bool = false

onready var muzzle = get_node("Camera/shotgun/Muzzle")
onready var bulletScene = preload("res://Bullet.tscn")
onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

var vel: Vector3 = Vector3()
var mouseDelta: Vector2 = Vector2()

onready var camera = get_node("Camera")
var weapon: int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(score)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	
	mouseDelta = Vector2()
	
	if weapon == 0:
		$Camera/shotgun.visible = true
		$Camera/Spatial.visible = false
		if Input.is_action_just_pressed("shoot") and ammo > 0 and !interact:
			shoot()
	elif weapon == 1:
		$Camera/shotgun.visible = false
		$Camera/Spatial.visible = true
		if Input.is_action_just_pressed("shoot") and ammo > 0 and !interact:
			try_attack()
	
	if Input.is_action_just_pressed("shoot") and interact:
		pass

func _physics_process(delta):
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	#if Input.is_action_just_pressed("move_forward"):
	#	$Camera/AnimationPlayer.play("Run")
	#if Input.is_action_just_released("move_forward"):
	#	$Camera/shotgun.rotation.y = 180
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backwards"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_just_pressed("axe"):
		weapon = 1
	if Input.is_action_just_pressed("gun"):
		weapon = 0
	
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	vel.z = (forward * input.y + right * input.x).z * moveSpeed
	vel.x = (forward * input.y + right * input.x).x * moveSpeed
	
	vel.y -= gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
	
	if $Camera/Interact.is_colliding():
		var collider = $Camera/Interact.get_collider()
		if collider.is_in_group("interactive"):
			interact = true
			ui.update_description_text(collider.name)
		else:
			interact = false
			ui.update_description_text("")

func shoot():
	var bullet = bulletScene.instance()
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	bullet.scale = Vector3.ONE
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)

func take_damage(damage):
	print(damage)
	curHp -= damage
	
	if curHp <= 0:
		die()
	
	ui.update_health_bar(curHp, maxHp)

func die():
	pass

func add_score(amount):
	score += amount
	ui.update_score_text(score)

func add_health(amount):
	curHp = clamp(curHp + amount, 0, maxHp)

func add_ammo(amount):
	ammo += amount


func _on_AnimationPlayer_animation_finished(anim_name):
	$Camera/AnimationPlayer.stop()

func try_attack():
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
	lastAttackTime = OS.get_ticks_msec()
	
	# play the animation
	$Camera/Spatial/axeAnim.stop()
	$Camera/Spatial/axeAnim.play("Attack")
	
	if $Camera/AttackRaycast.is_colliding():
		if $Camera/AttackRaycast.get_collider().has_method("take_damage"):
			$Camera/AttackRaycast.get_collider().take_damage(damage)
