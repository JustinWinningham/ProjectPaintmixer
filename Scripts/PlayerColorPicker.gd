extends Control

export(Color) var pickedColor
export(int) var playerNumber = 1

onready var PlayerName = $PickedColorSquare/PlayerName

var playerScore = 0

func _ready():
	$PickedColorSquare/PlayerRoundScore.visible = false
	match playerNumber:
			1:
				PlayerName.text = PROFILEHANDLER.p1Profile.getName()
			2:
				PlayerName.text = PROFILEHANDLER.p2Profile.getName()
			3:
				PlayerName.text = PROFILEHANDLER.p3Profile.getName()
			4:
				PlayerName.text = PROFILEHANDLER.p4Profile.getName()

func _on_ColorPicker_color_changed(color):
	pass
	$PickedColorSquare.color = color

func show_Round_Score(time, score):
	$RoundScoreTimer.start(time)
	$PickedColorSquare/PlayerRoundScore.text = str("+", score)
	playerScore += score
	$PickedColorSquare/PlayerTotalScore.text = str("Score: ", playerScore)
	$PickedColorSquare/PlayerRoundScore.visible = true
	# TODO: Put more flare here for amazing guesses / huge whiffs / point thresholds

func _on_RoundScoreTimer_timeout():
	$PickedColorSquare/PlayerRoundScore.text = ""
	$PickedColorSquare/PlayerRoundScore.visible = false

func get_Picked_Colors():
	var colors = [0.0,0.0,0.0]
	colors[0] = $PickedColorSquare/ColorPicker.color.r8
	colors[1] = $PickedColorSquare/ColorPicker.color.g8
	colors[2] = $PickedColorSquare/ColorPicker.color.b8
	return colors


func _fakeClickCP():
	var a = InputEventMouseButton.new()
	var b = InputEventMouseButton.new()
	a.set_button_index(1)
	b.set_button_index(1)
	a.position.x = $MainBodyClicker.get_position().x
	a.position.y = $MainBodyClicker.get_position().y
	b.position.x = $SideBodyClicker.get_position().x
	b.position.y = $SideBodyClicker.get_position().y
	print(a.position)
	a.set_pressed(true)
	b.set_pressed(true)
	Input.parse_input_event(a)
	Input.parse_input_event(b)
	

func _process(delta):
	var didMove = false
	var colors = get_Picked_Colors()
	$RL.text = str(colors[0])
	$GL.text = str(colors[1])
	$BL.text = str(colors[2])
	# https://godotengine.org/qa/3902/how-to-get-a-pixel-color-monitor
	
	# Step 1: draw a cursor over the main and side boxes for each character
	# Step 2: assign input controls to those cursor, bind them to prevent leaving their boxes
	# Step 3: Simulate a click on the virtual cursor to adjust the color on the picker
	# Step 4: IF we end up needing to use a colorpicker sprite instead of the tool, update all colorpicker references
#	if Input.is_action_just_pressed("cp_confirm_%s" % playerNumber):
#		print("clicking!")
#		call_deferred("_fakeClickCP")
	if Input.is_action_pressed("cp_main_up_%s" % playerNumber) && $MainBodyClicker.position.y > 55:
		didMove = true
		$MainBodyClicker.position.y -= 1
	if Input.is_action_pressed("cp_main_down_%s" % playerNumber) && $MainBodyClicker.position.y < 300:
		didMove = true
		$MainBodyClicker.position.y += 1
	if Input.is_action_pressed("cp_main_left_%s" % playerNumber) && $MainBodyClicker.position.x > 5:
		didMove = true
		$MainBodyClicker.position.x -= 1
	if Input.is_action_pressed("cp_main_right_%s" % playerNumber) && $MainBodyClicker.position.x < 275:
		didMove = true
		$MainBodyClicker.position.x += 1
	if Input.is_action_pressed("cp_side_down_%s" % playerNumber) && $SideBodyClicker.position.y > 55:
		didMove = true
		$SideBodyClicker.position.y -= 1
	if Input.is_action_pressed("cp_side_up_%s" % playerNumber) && $SideBodyClicker.position.y < 300:
		didMove = true
		$SideBodyClicker.position.y += 1
	if didMove:
		print("clicking!")
		call_deferred("_fakeClickCP")
		pass # update the color of the colorbox and the preview
	
	# Move main body crosshair left
	# Move main body crosshair right
	# QW at the same time: Side Up + Main Up
	#if Input.is_action_pressed("cp_main_right_%s" % playerNumber) && colors[0] < 255:
	#	$PickedColorSquare/ColorPicker.color.r8 = colors[0] + 1
		#$PickedColorSquare/ColorPicker.color.b8 = colors[2] - 1
	# Move main body crosshair up
	# Move main body crosshair down
	# Move side slider up
	# Move side slider down
	#if Input.is_action_pressed("cp_main_left_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.r8 = colors[0] - 1
	#if Input.is_action_pressed("cp_main_right_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.r8 = colors[0] + 1
	#if Input.is_action_pressed("cp_main_up_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.g8 = colors[1] - 1
	#if Input.is_action_pressed("cp_main_down_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.g8 = colors[1] + 1
	#if Input.is_action_pressed("cp_side_up_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.b8 = colors[2] - 1
	#if Input.is_action_pressed("cp_side_down_%s" % playerNumber):
	#	$PickedColorSquare/ColorPicker.color.b8 = colors[2] + 1
	colors = get_Picked_Colors()
	$PickedColorSquare.color.r8 = colors[0]
	$PickedColorSquare.color.g8 = colors[1]
	$PickedColorSquare.color.b8 = colors[2]
