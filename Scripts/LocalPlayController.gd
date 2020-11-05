extends Node2D

enum GAMESTATE {ENTERSCENE, COUNTDOWN, SHOWBASE, POURING, CAPPING, MIXING, REVEALING, RESETTING, GAMEWIN, GAMELOSS}
var currentState = GAMESTATE.ENTERSCENE
var roundNumber = 1

var rng = RandomNumberGenerator.new()

var baseColor = Color(0,0,0)
var randRed = 0
var randBlue = 0
var randGreen = 0

var addedRed = 0
var addedBlue = 0
var addedGreen = 0

var resultColor

func _ready():
	currentState = GAMESTATE.ENTERSCENE
	_assignPlayers()
	$DEBUG_LABEL.text = "Entering Scene"
	$StateTimer.start()


# Updates that need to be calculated every frame should go here
func _process(delta):
	$TIMER_LABEL.text = str("Time remaining in current state: ", stepify($StateTimer.get_time_left(), 0.1))
	$ROUND_LABEL.text = str("Round number: ", roundNumber)
	pass


# Assign player profiles from the lobby screen to their respective CPs in game screen
# While I work on the basic functionality, I will keep at just one player, so don't have to deal with this... yet
func _assignPlayers():
	# Would be cleaner to store as a small array insted of like this
	if !DATABANK.isP4Active:
		$CP4.visible = false
	if !DATABANK.isP3Active:
		$CP3.visible = false
	if !DATABANK.isP2Active:
		$CP2.visible = false
	if !DATABANK.isP1Active:
		$CP1.visible = false


# Updates that only need to be calculated during a change in game state should go here
# This entire structure is going to change  in the future to use
# animation signals instead of hard timers
func _on_StateTimer_timeout():
	if currentState == GAMESTATE.ENTERSCENE:
		currentState = GAMESTATE.COUNTDOWN
		$DEBUG_LABEL.text = "Counting down!"
		# Call method to play countdown animation here, might be better to use an animation player here instead
		$StateTimer.start(DATABANK.countdownTime) # Set our state timer to 6 seconds, 5 for the timer, 1 second buffer
		return
	if currentState == GAMESTATE.COUNTDOWN:
		currentState = GAMESTATE.SHOWBASE
		_pickBaseColor()
		# Again, might be better to use an animation handler to trigger the end of each phase
		$DEBUG_LABEL.text = "Showing Base Color!"
		$StateTimer.start(DATABANK.showBaseTime)
		return
	if currentState == GAMESTATE.SHOWBASE:
		currentState = GAMESTATE.POURING
		$DEBUG_LABEL.text = "Pouring"
		$StateTimer.start(DATABANK.pourTime)
		return
	if currentState == GAMESTATE.POURING:
		currentState = GAMESTATE.CAPPING
		$DEBUG_LABEL.text = "Capping"
		$StateTimer.start(DATABANK.capTime)
		return
	if currentState == GAMESTATE.CAPPING:
		currentState = GAMESTATE.MIXING
		$DEBUG_LABEL.text = "Mixing"
		$StateTimer.start(DATABANK.mixTime)
		return
	if currentState == GAMESTATE.MIXING:
		currentState = GAMESTATE.REVEALING
		$DEBUG_LABEL.text = "Revealing"
		$StateTimer.start(DATABANK.revealTime)
		return
	if currentState == GAMESTATE.REVEALING:
		roundNumber += 1
		# TODO: UnFugly
		if $CP1.visible:
			$CP1.show_Round_Score(5, _calculateScore($CP1.get_Picked_Colors()))
		if $CP2.visible:
			$CP2.show_Round_Score(5, _calculateScore($CP2.get_Picked_Colors()))
		if $CP3.visible:
			$CP3.show_Round_Score(5, _calculateScore($CP3.get_Picked_Colors()))
		if $CP4.visible:
			$CP4.show_Round_Score(5, _calculateScore($CP4.get_Picked_Colors()))
		if roundNumber > DATABANK.numRounds:
			currentState = GAMESTATE.GAMEWIN
			$DEBUG_LABEL.text = "Game Over!"
			$StateTimer.start(DATABANK.endGameTime)
			# Need to calculate the winner and show as much here
			return
		else:
			currentState = GAMESTATE.RESETTING
			$DEBUG_LABEL.text = "Resetting for next round"
			$PaintBucket.color = Color(255,255,255)
			$StateTimer.start(DATABANK.resetTime)
			return
	if currentState == GAMESTATE.RESETTING:
		# Looping back up to the top for showbase to start next round
		currentState = GAMESTATE.SHOWBASE
		_pickBaseColor()
		$DEBUG_LABEL.text = "Showing base color"
		$StateTimer.start(DATABANK.showBaseTime)
		return
	if currentState == GAMESTATE.GAMEWIN:
		# At this point, we would save all player statistic before leaving the scene
		
		# Reset all players to inactive base state to prevent errors
		DATABANK.isP1Active = false
		DATABANK.isP2Active = false
		DATABANK.isP3Active = false
		DATABANK.isP4Active = false
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")


func _calculateScore(colorValArr):
	var pickedRed = colorValArr[0]
	var pickedBlue = colorValArr[1]
	var pickedGreen = colorValArr[2]
	
	var scoreRed = abs(colorValArr[0] - randRed)
	var scoreBlue = abs(colorValArr[1] - randBlue)
	var scoreGreen = abs(colorValArr[2] - randGreen)
	
	var roundScore = 765 - stepify(scoreRed + scoreBlue + scoreGreen, 1.0)
	
	return roundScore

func _pickBaseColor():
	rng.randomize()
	randRed = rng.randf_range(150,255)
	randBlue = rng.randf_range(150,255)
	randGreen = rng.randf_range(150,255)
	print("Base color values: ")
	print(randRed)
	print(randBlue)
	print(randGreen)
	baseColor = Color(randRed, randBlue, randGreen)
#		$PaintBucket.color = baseColor
	$PaintBucket.color.r8 = randRed
	$PaintBucket.color.b8 = randBlue
	$PaintBucket.color.g8 = randGreen
