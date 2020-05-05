extends Spatial

const FOOD_PATH = "res://Models/Items/Food/"
const FOOD_NAME = ["potato", "pizza", "hamburger", "maca", "salada"]
const FOODS = {
	"potato": {
		"icon": FOOD_PATH + "Potato.png",
		"text": "Potato",
		"price": 100,
		"value": 10
	},
	"pizza": {
		"icon": FOOD_PATH + "Pizza.png",
		"text": "Pizza",
		"price": 500,
		"value": 100
	},
	"hamburger": {
		"icon": FOOD_PATH + "Hamburguer.png",
		"text": "Hamburger",
		"price": 250,
		"value": 50
	},
	"maca": {
		"icon": FOOD_PATH + "Maca.png",
		"text": "Maça",
		"price": 100,
		"value": 10
	},
	"salada": {
		"icon": FOOD_PATH + "Salada.png",
		"text": "Salada",
		"price": 150,
		"value": 25
	}
}

const WEAPON_NAME = ["Pistol", "Shotgun", "Machine Gun"]

var food_index
var weapon_index

func _ready():
	randomize()
	$AnimationPlayer.play("Balloon")
	$UI/Score.text = str(global.score)
	
	food_index = FOOD_NAME[int(rand_range(0, FOOD_NAME.size()))]
	generate_food_button(food_index)
	generate_log_button()
	
	weapon_index = int(rand_range(0, WEAPON_NAME.size()))
	generate_weapon_button(weapon_index)

func generate_food_button(index):
	print(index)
	var food = FOODS[index]
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load(food.icon)
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton/Label.text = food.text + "-$" + str(food.price)
	$UI/Grid/TextureButton.texture_normal = texture

func generate_log_button():
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load('res://Models/Items/LogItem.png')
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton2/Label.text = "Logs"
	$UI/Grid/TextureButton2.texture_normal = texture

func generate_weapon_button(index):
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load('res://Models/Items/Guns/' + str(index + 1) + '.png')
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton3/Label.text = WEAPON_NAME[index]
	$UI/Grid/TextureButton3.texture_normal = texture
	
func _on_TextureButton_pressed():
	var food = FOODS[food_index]
	if food.price <= global.score:
		get_parent().find_node("Player").add_food(food.value)
		global.score -= food.price

func _on_TextureButton2_pressed():
	if global.score >= 100:
		get_parent().find_node("Player").add_log(10)
		global.score -= 100


func _on_TextureButton3_pressed():
	if global.score >= 100:
		get_parent().find_node("Player").add_bullets(15)
		global.score -= 100

func _on_Button_pressed():
	#get_tree().change_scene("res://MainScene.tscn")
	get_parent().find_node("Player").return_shop()
	queue_free()
