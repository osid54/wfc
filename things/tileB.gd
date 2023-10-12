extends Sprite2D

var pos := Vector2(-1,-1)
var options := []
var tileType := -1

var rules := [
	[1], #boulder
	[0,1,3,6], #pebbles
	[2,3], #tall grass
	[1,2,3,4,6], #short grass
	[3,4,5,6], #flowers
	[4], #flower
	[1,3,4,6,7], #plain
	[6,7] #barren
]

func _ready():
	#frame = 6
	visible = false
	for i in range(vframes):
		for j in range(hframes):
			options.append(i*hframes+j)

#func _process(_delta):
#	$Label.text = ""
#	for o in options:
#		$Label.text += str(o)
#	$Label.text += str(" ", tileType)

func narrow(t:int):
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
		frame = tileType
	#if tileType == -1:
	#	visible = false
