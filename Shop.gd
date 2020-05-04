extends Spatial

const FOOD_PATH = "res://Models/Items/Food/"
const FOOD_NAME = ["potato", "pizza", "hamburger", "maca", "salada"]
const FOODS = {
	"potato": {
		"icon": FOOD_PATH + "Potato.png",
		"text": "Potato",
		"price": "$100"
	},
	"pizza": {
		"icon": FOOD_PATH + "Pizza.png",
		"text": "Pizza",
		"price": "$500"
	},
	"hamburger": {
		"icon": FOOD_PATH + "Hamburguer.png",
		"text": "Hamburger",
		"price": "$250"
	},
	"maca": {
		"icon": FOOD_PATH + "Maca.png",
		"text": "Maça",
		"price": "$100"
	},
	"salada": {
		"icon": FOOD_PATH + "Salada.png",
		"text": "Salada",
		"price": "$150"
	}
}

const WEAPON_NAME = ["Pistol", "Shotgun", "Machine Gun"]

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("Balloon")
	
	generate_food_button()
	generate_log_button()
	generate_weapon_button()

func generate_food_button():
	var index = FOOD_NAME[int(rand_range(0, FOOD_NAME.size()))]
	print(index)
	var food = FOODS[index]
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load(food.icon)
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton/Label.text = food.text + "-" + food.price
	$UI/Grid/TextureButton.texture_normal = texture

func generate_log_button():
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load('res://Models/Items/LogItem.png')
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton2/Label.text = "Logs"
	$UI/Grid/TextureButton2.texture_normal = texture

func generate_weapon_button():
	var index = int(rand_range(0, WEAPON_NAME.size()))
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load('res://Models/Items/Guns/' + str(index + 1) + '.png')
	texture.create_from_image(img)
	
	$UI/Grid/TextureButton3/Label.text = WEAPON_NAME[index]
	$UI/Grid/TextureButton3.texture_normal = texture
	
func _on_TextureButton_pressed():
	pass # Replace with function body.


func _on_TextureButton2_pressed():
	pass # Replace with function body.


func _on_TextureButton3_pressed():
	pass # Replace with function body.
