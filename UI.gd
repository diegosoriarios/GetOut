extends Control

func update_health_bar(curHp, maxHp):
	$HealthBar.max_value = maxHp
	$HealthBar.value = curHp

func update_ammo_text(ammo):
	$AmmoText.text = "Ammo: " + str(ammo)

func update_score_text(score):
	$ScoreText.text = "Score: " + str(score)

func update_description_text(text):
	$Description.text = text

func update_food(value):
	$HBoxContainer/Potato/Panel/Label.text = str(value)

func update_food_bar(curFood):
	$HBoxContainer/Potato/Total.max_value = 100
	$HBoxContainer/Potato/Total.value = curFood

func update_water(value):
	$HBoxContainer/Water/Panel/Label.text = str(value)

func update_water_bar(curWater):
	$HBoxContainer/Water/Total.max_value = 100
	$HBoxContainer/Water/Total.value = curWater

func update_item(value):
	var img = Image.new()
	var texture = ImageTexture.new()
	if str(value) == "log":
		$HBoxContainer/Item/Panel/Label.text = "1"
		img.load("res://Models/Items/Log.png")
		texture.create_from_image(img)
		$HBoxContainer/Item/Sprite.texture = texture
	elif str(value) == "":
		$HBoxContainer/Item/Panel/Label.text = "0"
		img.load("res://Models/Items/Hand.png")
		texture.create_from_image(img)
		$HBoxContainer/Item/Sprite.texture = texture

func update_temperature(value):
	$HBoxContainer/Temperature/Panel/Label.text = str(int(value))
