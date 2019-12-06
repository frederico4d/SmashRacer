extends Spatial
# Declare member variables here. Examples:
#const = level = preload("res://Scripts/level1.gd")
var char01 = preload("res://sncs/CHAR_01.tscn")
var levelspeed = 10
var level_distance = 0
var Col_z = []
var ColFree =[] ## Tells what cols are free from characters
var Char_Demo = char01.instance()
var Char_Jump = char01.instance()
var width = 4
var EndGame = false
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	## ROW 1
	for x in width:
		ColFree.append(false)
		
	Char_Demo.rotation_degrees.y += 90
	Char_Demo.Player = 1
	Char_Demo.ColPos = width-2
	Char_Demo.translation.z = Col_z[Char_Demo.ColPos]
	Char_Demo.Type = "Demo"
	Char_Demo.width = width  
	
	Char_Jump.rotation_degrees.y += 90
	Char_Jump.scale = Vector3(0.8,0.8,0.8)
	Char_Jump.Player = 2
	Char_Jump.ColPos = 1
	Char_Jump.translation.z = Col_z[Char_Jump.ColPos]
	Char_Jump.Type = "Jump"
	Char_Jump.width = width
	
	add_child(Char_Demo)
	add_child(Char_Jump)

func _input(event):
	if event.is_action_pressed("+"):
		levelspeed+= 0.1
	if event.is_action_pressed("-"):
		levelspeed-= 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$"UI/fps_label".text = str(Performance.get_monitor(0))
	
	
	if Char_Demo.alive == false or Char_Jump.alive == false:
		EndGame = true
		
	for x in width:
		if Char_Demo.ColPos == x or Char_Jump.ColPos == x:
			ColFree[x] = false
		else:
			ColFree[x] = true
		
	score = round((level_distance/3)*10) /10
	$"UI/Score".text = str(score) 
	$"UI/t1".text = "j: "+str(Char_Jump.Jumping)+ str(Char_Jump.VerticalSpeed) + " " + str(Char_Jump.AirSlided)
	var ttt
	ttt = str(Char_Jump.ColPos)+" "+str(Char_Jump.ColPos_prev)+" "+str(ColFree) + " " + Char_Jump.State
	$"UI/t2".text = ttt

func _on_LeftBT_moveLeft_button_down():
	Char_Jump.move_side("left")
	
func _on_LeftBT_action_button_down():
	Char_Jump.action()
	
func _on_LeftBT_moveRight_button_down():
	Char_Jump.move_side("right")

func _on_RightBT_moveLeft_button_down():
	Char_Demo.move_side("left")

func _on_RightBT_action_button_down():
	Char_Demo.action()

func _on_RightBT_moveRight_button_down():
	Char_Demo.move_side("right")
