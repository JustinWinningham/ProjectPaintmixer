extends Control

export(Color) var pickedColor
export(int) var playerNumber = 1

var playerScore = 0

func _ready():
	$PickedColorSquare/PlayerRoundScore.visible = false

func _on_ColorPicker_color_changed(color):
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
	colors[1] = $PickedColorSquare/ColorPicker.color.b8
	colors[2] = $PickedColorSquare/ColorPicker.color.g8
	return colors
