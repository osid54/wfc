extends Sprite2D

var pos := Vector2(-1,-1)
var options := []
var tileType := ""

var rules := {
	"boulder": ["pebbles"],
	"pebbles": ["boulder","pebbles","grassS","plain"],
	"grassT": ["grassT","grassS"],
	"grassS": ["pebbles","grassT","grassS","flowers","plain"],
	"flowers": ["grassS","flowers","flower","plain"],
	"flower": ["flowers"],
	"plain": ["pebbles","grassS","flowers","plain","plainToBarren"],
	"barren": ["barren","plainToBarren"],
	"plainToBarren": ["plain","barren","plainToBarren"]
}

func _ready():
	visible = false
	for key in rules:
		options.append(key)

func narrow(t:String):
	var valid := []
	for o in options:
		if rules[o].has(t):
			valid.append(o)
	options = valid

func randomType():
	if options.size() >= 1:
		visible = true
		tileType = options.pick_random()
		options = []
		texture = load(str("res://sprites/tiles/",tileType,".png"))
