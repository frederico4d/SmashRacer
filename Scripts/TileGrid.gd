extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flat_tile = preload("res://sncs/Tile_flat.tscn")
var obstacle_tile = preload("res://sncs/Tile_obstacle.tscn" )
var hole_tile = preload("res://sncs/Tile_hole.tscn" )
var Gem = preload("res://sncs/Gems.tscn")
var array = []
var Gems_array = []
var width
var rowNr = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	width = get_parent().width
	translation.z -= width-1.5
	generate_row(true)
	
	
func addGem ():
	var newGem = Gems_array[Gems_array.size()-1]
	add_child(newGem)
	newGem.translation.z = array[array.size()-1].translation.z
	newGem.translation.x = array[array.size()-1].translation.x
	
	
func makeRow_random(ObstablesPC, HolesPC):
	var newX # new x position for the tile
	var addGem = false
	if array.size() > 0:
		newX = array[array.size()-1].translation.x + 4
	else:
		newX = 0
	
	for x in width:
		randomize()
		var random = randi()%100+1
		
		if random > 90 and random < 95:
			array.append(obstacle_tile.instance())
			array[array.size()-1].Type = "obstacle"
		elif random >= 95 :
			array.append(hole_tile.instance())
			array[array.size()-1].Type = "hole"
		else:
			array.append(flat_tile.instance())
			array[array.size()-1].Type = "flat"
			if randi()%10+1 == 10:
				addGem = true
				Gems_array.append(Gem.instance())
			
		add_child(array[array.size()-1])
		array[array.size()-1].translation.z += x*2 
		array[array.size()-1].translation.x = newX
		
		if addGem: addGem ()
			
		
func makeRow_flat():
	var newX # new x position for the tile
	if array.size() > 0:
		newX = array[array.size()-1].translation.x + 4
	else:
		newX = 0
		
	for x in width:
		array.append(flat_tile.instance())
		add_child(array[array.size()-1])
		array[array.size()-1].translation.z += x*2 
		array[array.size()-1].translation.x = newX
	

		var newZ = translation.z + (array[array.size()-1].translation.z)
		get_parent().Col_z.append(newZ) 
	
		
func generate_row (First):
	if rowNr <= 100:
		makeRow_flat()
	else:
		makeRow_random(10,10)
	
func remove_back_row():
	for x in 4:
		array[0].visible = false
		array.pop_front()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#translate(Vector3(-get_parent().levelspeed,0,0))
	get_parent().level_distance += get_parent().levelspeed
	var FarTile = array[array.size()-1].translation.x + translation.x
	var BackTile = array.front().translation.x + translation.x

	
	if FarTile < $"../Camera".translation.x +60:
		rowNr+=1
		generate_row(false)
		
	if BackTile < $"../Camera".translation.x +5:
		remove_back_row()