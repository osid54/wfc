extends Node2D

@export var size := 32
@export var tileDim := 100
@export var waittime := 0
@export var tile := preload("res://things/tileD.tscn")
var map := []
var mapData := []
var numCollapsed := 0

func _ready():
	generate()
	
func _process(_delta):
	if Input.is_action_just_released("go"):
		for i in range(size):
			for j in range(size):
				map[i][j].queue_free()
		generate()

func generate():
	$cam.position = Vector2(size/2.0*tileDim,size/2.0*tileDim)
	map = []
	mapData = []
	numCollapsed = 0
	for i in range(size):
		map.append([])
		for j in range(size):
			var t = tile.instantiate()
			t.pos = Vector2(i,j)
			t.position = Vector2(i*tileDim,j*tileDim)
			add_child(t)
			map[i].append(t)
			mapData.append(Vector2(t.options.size(),i*size+j))
	collapse(mapData.pick_random().y)
	while numCollapsed != size*size:
		collapse(mapData[numCollapsed].y)
		await get_tree().create_timer(waittime).timeout
	#print("done "+str(numCollapsed))
	

func select(linearPos):
	return map[linearPos/size][linearPos%size]
	
func sortByOptions():
	mapData.clear()
	for i in range(size):
		for j in range(size):
			mapData.append(Vector2(map[i][j].options.size(),i*size+j))
	mapData.sort_custom(func(a, b): return a.x < b.x)

func neighborPropogate(p:int):
	var currTile = select(p)
	var x = currTile.pos.x
	var y = currTile.pos.y
	var t = map[x][y].tileType
	
	var neighbors = [[-1,0,1],[-1,0,1]]
	if x == 0: neighbors[0] = [0,1]
	elif x == size-1: neighbors[0] = [-1,0]
	if y == 0: neighbors[1] = [0,1]
	elif y == size-1: neighbors[1] = [-1,0]
	
	for i in neighbors[0]:
		for j in neighbors[1]:
			if map[x+i][y+j].tileType==-1:
				map[x+i][y+j].narrow(t)

func collapse(pos:int):
	var currTile = select(pos)
	currTile.randomType()
	#print("pos:"+str(mapData[pos].y)+" x:"+str(select(pos).pos.x)+" y:"+str(select(pos).pos.y)+" type:"+str(currTile.tileType))
	mapData[numCollapsed].x = 0
	neighborPropogate(pos)
	numCollapsed+=1
	sortByOptions()

