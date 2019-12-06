extends Spatial
# Declare member variables here. 
var Player 
var PN
var ColPos : int
var ColPos_prev
var State = "front" # "slide" "obstacleHit" "holeHit" "front" "jump"
var alive = true
var waitInput = true
var Type # "Jump" "Demo"
var JumpForce
var VerticalSpeed = 0
var Jumping = false
var AirSlided = false
var Riding = false
var width = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	JumpForce = .35 #* get_parent().levelspeed
	ColPos_prev = ColPos
	PN = "P" + str(Player)
	
	if Type == "Demo":
		$"Model/Demo".visible = true
		#$"Model/Demo/metarig/basemesh".get_surface_material(0).set_albedo(Color(0.65,0.16,0.16,1))

		$"Model/Jump".visible = false
	#	
		$"Model/Jump".queue_free()
	elif Type == "Jump":
		$"Model/Demo".visible = false
		$"Model/Jump".visible = true


		$"Model/Demo".queue_free()
	###Setup model
	#$"Demo/AnimationPlayer".play("rigAction")

	
"Char_Area"
func slide_char(Char, Side):
	Char.State = "slide"
	Char.ColPos_prev = ColPos
	if Side == "left": Char.ColPos -=1
	elif Side == "right": Char.ColPos +=1
	
	Char.get_node("SlideTimer").start()
	
	
func move_side(side):
	var Char_Jump = get_parent().Char_Jump
	
	if side == "left":
		###Slides normally
		if (ColPos  > 0 
			&& State == "front"):
			## slides if col is free
			if get_parent().ColFree[ColPos-1] == true:
				if Jumping and AirSlided == false:
					AirSlided = true
					slide_char(self, side)
				elif AirSlided == true:
					pass
				else:
					slide_char(self, side)
				
			## slides if coll is not free but char is jumping
				
			elif (Type == "Demo"
				&& get_parent().ColFree[ColPos-1] == false
				&& Char_Jump.Jumping):
				slide_char(self, side)
				
			## Slides and pushes if Demo
			elif (ColPos  > 1 
				&& Type == "Demo"
				&& get_parent().ColFree[ColPos-1] == false
				&& Char_Jump.Jumping == false):
				slide_char(self, side)
				var CharJump = get_parent().Char_Jump
				slide_char(CharJump, side)
		
		
	elif side == "right":
		###Slides normally
		if (ColPos   < width -1 
			&& State == "front"):
			## slides if col is free
			if get_parent().ColFree[ColPos+1] == true:
				slide_char(self, side)
				if Jumping:
					AirSlided = true
			## slides if coll is not free but char is jumping
			elif (Type == "Demo"
				&& get_parent().ColFree[ColPos+1] == false
				&& Char_Jump.Jumping):
				slide_char(self, side)
				
			## Slides and pushes if Demo
			elif (ColPos  < width -2 
				&& Type == "Demo"
				&& get_parent().ColFree[ColPos+1] == false
				&& Char_Jump.Jumping == false):
				slide_char(self, side)
				var CharJump = get_parent().Char_Jump
				slide_char(CharJump, side)

func action():
	if (Type == "Jump" 
	&& State == "front" 
	&& !Jumping
	&& translation.y < 0.2):
		VerticalSpeed = JumpForce
		Jumping = true
		AirSlided = false
		
func _input(event):
	var Char_Jump = get_parent().Char_Jump
	if event.is_action_pressed(PN + "_left") && alive:
		move_side("left")

	if event.is_action_pressed(PN + "_right") && alive:
		move_side("right")

	if event.is_action_pressed(PN + "_action") && alive:
		action()
		
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	translation.x +=get_parent().levelspeed * delta
	
	var Char_Jump = get_parent().Char_Jump
	var Char_Demo = get_parent().Char_Demo
	if alive:
		## move character from current pos to future ColPos
		var Col_z = get_parent().Col_z[ColPos]
		translation.z = lerp(translation.z, Col_z, delta*8) 
		
		
		## Jump move
		#if Jumping:
		translation.y = translation.y + VerticalSpeed
		if translation.y > 0.0:
			VerticalSpeed -= 0.02
		elif State == "front":
			translation.y = 0
			VerticalSpeed = 0
			Jumping = false
			AirSlided = false
			
		
		if Jumping:
			if translation.y <= 2 and VerticalSpeed < 0:
				Jumping = false
				AirSlided = false
				State = "front"
		
		if Riding:
			translation.y = 2 
			VerticalSpeed = 0
			if Char_Demo.ColPos == ColPos:
				pass
			else:
				Riding = false
		
	elif !alive:
		if State == "obstacleHit":
			translation.x -= get_parent().levelspeed * delta
		elif State == "holeHit":
			translation.x -= get_parent().levelspeed * delta
			translation.y -= 12 *delta
			

func _on_Char_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_parent().Type == "obstacle":
		State = "obstacleHit"
		alive = false
	elif area.get_parent().Type == "hole":
		State = "holeHit"
		alive = false
	elif area.get_parent().Type == "Demo":
		Jumping = false
		AirSlided = false
		Riding = true

func _on_SlideTimer_timeout():
	if State == "slide":
		State= "front"