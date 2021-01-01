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


func show_Round_Score(time, score):
	$RoundScoreTimer.start(time)
	$PickedColorSquare/PlayerRoundScore.text = str("+", score)
	playerScore += score
	$PickedColorSquare/PlayerTotalScore.text = str("Score: ", playerScore)
	$PickedColorSquare/PlayerRoundScore.visible = true
	# TODO: Put more flare here for amazing guesses / huge whiffs / point thresholds


func _on_RoundScoreVisibilityTimer_timeout():
	$PickedColorSquare/PlayerRoundScore.text = ""
	$PickedColorSquare/PlayerRoundScore.visible = false


func get_Picked_Colors():
	var colors = [1,1,1]
	# TODO: GET THE COLOR CUROR COLOR
#	get_viewport().queue_screen_capture()
#	var image = get_viewport().get_screen_capture()
	var cursorX = $ColorPicker/ColorCursor.global_position.x
	var cursorY = $ColorPicker/ColorCursor.global_position.y
#	print(image.get_pixel(cursorX, cursorY))
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(VisualServer, "frame_post_draw")
	var img = get_viewport().get_texture().get_data()
	img.lock()
	print(img.get_pixel(cursorX, cursorY))
	img.unlock()
	return colors


func _process(delta):
	var didMove = false
	var colors = get_Picked_Colors()
#	$RL.text = str(colors[0])
#	$GL.text = str(colors[1])
#	$BL.text = str(colors[2])
	$PickedColorSquare.color.r8 = colors[0]
	$PickedColorSquare.color.g8 = colors[1]
	$PickedColorSquare.color.b8 = colors[2]
	
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
