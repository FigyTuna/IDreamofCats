extends Node

var endings = [
	false,
	false,
	false,
	false,
	false
]

var cats = {
	"cat1": preload("res://images/Cats/CatSit.png"),
	"cat2": preload("res://images/Cats/CatFuzzy.png"),
	"cat3": preload("res://images/Cats/CatSleep.png"),
	"cat4": preload("res://images/Cats/CatSpooky.png"),
	"cat5": preload("res://images/Cats/CatCrouch.png"),
	"bat": preload("res://images/objects/Bat.png"),
	"bone": preload("res://images/objects/Bone.png"),
	"boot": preload("res://images/objects/Boot.png"),
	"collar": preload("res://images/objects/Collar.png"),
	"door": preload("res://images/objects/Door.png"),
	"food": preload("res://images/objects/Food.png"),
	"flower": preload("res://images/objects/Flower.png"),
	"ham": preload("res://images/objects/Ham.png"),
	"furball": preload("res://images/objects/FurBall.png"),
	"hydrant": preload("res://images/objects/Hydrant.png"),
	"moon": preload("res://images/objects/Moon.png"),
	"paw": preload("res://images/objects/Paw.png"),
	"pawgrey": preload("res://images/objects/PawGrey.png"),
	"paworange": preload("res://images/objects/PawOrange.png"),
	"pawspots": preload("res://images/objects/PawSpots.png"),
	"rope": preload("res://images/objects/Rope.png"),
	"sock": preload("res://images/objects/Sock.png"),
	"steak": preload("res://images/objects/Steak.png"),
	"syringe": preload("res://images/objects/Syringe.png"),
	"tennis": preload("res://images/objects/Tennis.png"),
	"water": preload("res://images/objects/Water.png"),
	"zzz": preload("res://images/objects/Zzz.png"),
}

var dog = null

var presets = {}
var tracks = {}
var nodes = {}

var points = 0

const CENTER = Vector2(800, 450)

func save():
	var save = File.new()
	save.open("user://save.json", File.WRITE)
	var data = {
		"endings": Global.endings
	}
	save.store_line(to_json(data))
	save.close()
