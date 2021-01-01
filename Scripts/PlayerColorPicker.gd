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
	a.position.x = $MainBodyClicker.get_global_position().x
	a.position.y = $MainBodyClicker.get_global_position().y
	b.position.x = $SideBodyClicker.get_global_position().x
	b.position.y = $SideBodyClicker.get_global_position().y
	# NOTE: We we have to press AND release each button in sequence, otherwise the colorpicker will
	# not consider the first click to have ended, and drag the clicked mouse to the second location
	a.set_pressed(true)
	Input.parse_input_event(a)
	a.set_pressed(false)
	Input.parse_input_event(a)
	
	b.set_pressed(true)
	Input.parse_input_event(b)
	b.set_pressed(false)
	Input.parse_input_event(b)


func _process(delta):
	var didMove = false
	var colors = get_Picked_Colors()
	$RL.text = str(colors[0])
	$GL.text = str(colors[1])
	$BL.text = str(colors[2])

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

	colors = get_Picked_Colors()
	$PickedColorSquare.color.r8 = colors[0]
	$PickedColorSquare.color.g8 = colors[1]
	$PickedColorSquare.color.b8 = colors[2]
