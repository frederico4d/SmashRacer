extends Spatial
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gameScene = preload("res://Game.tscn")
var newGame
var playing = false
var Highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing:
		if newGame.EndGame:
			if newGame.score > Highscore:
				Highscore = newGame.score
			$"Intro_UI/Score_Label".text = "Your score: " + str(newGame.score)
			$"Intro_UI/Highscore_Label".text = "Highscore: " + str(Highscore)
			
			newGame.free()
			#remove_child(newGame)
			playing = false
			$"Intro_UI".visible = true
	else:
		pass

func _on_Button_pressed():
	$"Intro_UI".visible = false
	newGame = gameScene.instance()
	add_child(newGame)
	playing = true
	
