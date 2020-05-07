extends KinematicBody

var curHp: int = 100
var maxHp: int = 100
var ammo: int = 15
#var score: int = 0

var moveSpeed: float = 5.0
var jumpForce: float = 5.0
var gravity: float = 12.0

var minLookAngle: float = -90.0
var maxLookAngle: float = 90.0
var lookSensitivity: float = .5

var attackRate : float = 0.3
var lastAttackTime : int = 0
var damage : int = 1
var interact: String = ""

onready var muzzle = get_node("Camera/shotgun/Muzzle")
onready var bulletScene = preload("res://Bullet.tscn")
onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")
onready var Blood = preload("res://Blood.tscn")

var vel: Vector3 = Vector3()
var mouseDelta: Vector2 = Vector2()

onready var camera = get_node("Camera")
var weapon: int = 0
var item = ""

var frame = 0
var pause = false

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(global.score)
	ui.update_water(global.water)
	ui.update_item(item)
	ui.update_temperature(global.temp)
	
	ui.update_water_bar(global.water)
	ui.update_food_bar(global.food)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	if !global.pause:
	
		camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta
		
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
		
		rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
		
		mouseDelta = Vector2()
		
		if weapon == 0:
			$Camera/shotgun.visible = true
			$Camera/Spatial.visible = false
			if Input.is_action_just_pressed("shoot") and ammo > 0 and interact == "":
				#shoot()
				$Camera/AnimationPlayer.play("Shot")
		elif weapon == 1:
			$Camera/shotgun.visible = false
			$Camera/Spatial.visible = true
			if Input.is_action_just_pressed("shoot")  and interact == "":
				#try_attack()
				# play the animation
				$Camera/Spatial/axeAnim.stop()
				$Camera/Spatial/axeAnim.play("Attack")
		
		if Input.is_action_just_pressed("shoot") and interact != "":
			interact_with_object()
		
		if weapon == 1 and interact == "Cortar" and Input.is_action_just_pressed("shoot"):
			#$Camera/Spatial/axeAnim.stop()
			$Camera/Spatial/axeAnim.play("Attack")
			interact_with_object()
		
		global.water -= .005
		ui.update_water_bar(global.water)
		
		global.food -= .01
		ui.update_food_bar(global.food)
		
		global.temp -= .001
		ui.update_temperature(global.temp)
		
		if global.water <= 30 or global.food <= 30 or global.temp <= 15 or global.temp >= 35:
			frame += delta * 10
			
			if frame > 5:
				curHp -= 1
				frame = 0
				ui.update_health_bar(curHp, maxHp)

func _physics_process(delta):
	if !global.pause:
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
				if collider.name == "Fogao":
					interact = collider.name
					ui.update_description_text("Colocar mais lenha")
				else:	
					interact = collider.name
					ui.update_description_text(collider.name)
			else:
				interact = ""
				ui.update_description_text("")

func shoot():
	var bullet = bulletScene.instance()
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	bullet.scale = Vector3.ONE
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)
	

func take_damage(damage):
	curHp -= damage
	
	if curHp <= 0:
		die()
	
	ui.update_health_bar(curHp, maxHp)

func die():
	pass

func add_score(amount):
	global.score += amount
	ui.update_score_text(global.score)

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
	
	if $Camera/AttackRaycast.is_colliding():
		if $Camera/AttackRaycast.get_collider().has_method("take_damage"):
			$Camera/AttackRaycast.get_collider().take_damage(damage)
			var blood = Blood.instance()
			blood.translation = $Camera/Blood.translation
			blood.emitting = true
			add_child(blood)
		if $Camera/AttackRaycast.get_collider().get_parent().get_parent().has_method("cut_tree") :
			$Camera/AttackRaycast.get_collider().get_parent().get_parent().cut_tree()

func interact_with_object():
	print(interact)
	if interact == "Comprar":
		global.pause = true
		#get_tree().change_scene("res://Shop.tscn")
		var Shop = load("res://Shop.tscn")
		var shop = Shop.instance()
		get_parent().add_child(shop)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		shop.translation.y = 100
		shop.find_node("Camera").current = true
		get_parent().find_node("CanvasLayer").find_node("UI").visible = false
	elif interact == "Dormir":
		get_parent().find_node("CanvasLayer").find_node("UI").sleep()
	elif interact == "Beber":
		global.water += 5
		if global.water > 100:
			global.water = 100
	elif interact == "Pegar":
		if item == "":
			if global.logs > 0:
				item = "log"
				ui.update_item(item)
			else:
				ui.update_description_text("Não tem lenha suficiente")
	elif interact == "Fogao":
		if item == "log":
			item = ""
			global.temp += int(rand_range(3, 6))
			global.logs -= 1
			ui.update_item(item)
			ui.update_temperature(global.temp)
		else:
			ui.update_description_text("Pegar uma lenha antes")
	elif interact == "Cortar":
		pass

func return_shop():
	$Camera.current = true
	for children in get_parent().get_children():
		print(children.name)
		if children.name == "Shop":
			children.queue_free()
			get_parent().remove_child(children)
		if children.name == "Comprar":
			children.go_away()
	interact = ""
	ui.update_description_text("")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().find_node("CanvasLayer").find_node("UI").visible = true
	global.pause = false

func add_food(value):
	global.food += value
	ui.update_food_bar(global.food)

func add_log(value):
	global.logs += value

func add_bullets(value):
	ammo += value
	ui.update_ammo_text(ammo)
