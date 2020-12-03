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
var addedWhite = 0
var addedBlack = 0

var pit = 0
var rRed = 0
var rBlue = 0
var rGreen = 0

var p1
var p2
var p3
var p4

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
	if DATABANK.isP4Active:
		$CP4.visible = true
		p4 = PROFILEHANDLER.p4Profile
	if DATABANK.isP3Active:
		$CP3.visible = true
		p3 = PROFILEHANDLER.p3Profile
	if DATABANK.isP2Active:
		$CP2.visible = true
		p2 = PROFILEHANDLER.p2Profile
	if DATABANK.isP1Active:
		$CP1.visible = true
		p1 = PROFILEHANDLER.p1Profile


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
		# Add random paint here
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
		_pickAddedValues()
		$PaintBucket.color.r8 = rRed
		$PaintBucket.color.g8 = rGreen
		$PaintBucket.color.b8 = rBlue
		$StateTimer.start(DATABANK.revealTime)
		return
	if currentState == GAMESTATE.REVEALING:
		roundNumber += 1
		var p1Score = _calculateScore($CP1.get_Picked_Colors())
		var p2Score = _calculateScore($CP2.get_Picked_Colors())
		var p3Score = _calculateScore($CP3.get_Picked_Colors())
		var p4Score = _calculateScore($CP4.get_Picked_Colors())
		var winningPlayer = 1
		# TODO: Calculate winning player
#		if p1Score > p2Score || !DATABANK.isP2Active): # if player 1 > player 2, or if player 2 isnt playing...
#			if p1Score > p3Score || !DATABANK.isP3Active):
#				if p1Score > p4Score || !DATABANK.isP4Active):
#					winningPlayer = 1
		
		var updateWins = false
		if (DATABANK.activePlayers > 1): # update stats if more than one player
			updateWins = true
			
		# TODO: UnFugly and make calls to profiles to update stats
		if $CP1.visible:
			print("P1 Visible")
			$CP1.show_Round_Score(5, p1Score) # 5 = seconds to display round score "+513"
			if updateWins:
				print("Updating P1 Wins")
				print ("1 == " + str(winningPlayer) + ", " + str(p1Score))
				p1.updateStats_RoundOver(1 == winningPlayer, p1Score)
		if $CP2.visible:
			$CP2.show_Round_Score(5, p2Score)
			if updateWins:
				print("Updating P2 Wins")
				print ("1 == " + str(winningPlayer) + ", " + str(p2Score))
				p2.updateStats_RoundOver(2 == winningPlayer, p1Score)
		if $CP3.visible:
			$CP3.show_Round_Score(5, p3Score)
			if updateWins:
				print("Updating P3 Wins")
				print ("1 == " + str(winningPlayer) + ", " + str(p3Score))
				p3.updateStats_RoundOver(3 == winningPlayer, p1Score)
		if $CP4.visible:
			$CP4.show_Round_Score(5, p4Score)
			if updateWins:
				print("Updating P4 Wins")
				print ("1 == " + str(winningPlayer) + ", " + str(p4Score))
				p4.updateStats_RoundOver(4 == winningPlayer, p1Score)
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
	var scoreRed = abs(colorValArr[0] - rRed)
	var scoreBlue = abs(colorValArr[1] - rBlue)
	var scoreGreen = abs(colorValArr[2] - rGreen)
	
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
	$PaintBucket.color.r8 = randRed
	$PaintBucket.color.b8 = randBlue
	$PaintBucket.color.g8 = randGreen
	pit += randRed + randBlue + randGreen


func _pickAddedValues():
	rng.randomize()
	# Note, these number represent volumes of a pure color
	addedRed = rng.randf_range(0, GLOBAL.max_add_volume)
	addedBlue = rng.randf_range(0, GLOBAL.max_add_volume)
	addedGreen = rng.randf_range(0, GLOBAL.max_add_volume)
	addedBlack = rng.randf_range(0, GLOBAL.max_add_volume)
	addedWhite = rng.randf_range(0, GLOBAL.max_add_volume)
	
	pit = randRed + randBlue + randGreen + addedRed + addedBlue + addedGreen + addedWhite + addedBlack
	
	var ratioRed = (randRed + addedRed + addedWhite) / pit
	var ratioBlue = (randBlue + addedBlue + addedWhite) / pit
	var ratioGreen = (randGreen + addedGreen + addedWhite) / pit
	
	rRed = int(round(ratioRed * 255))
	rBlue = int(round(ratioBlue * 255))
	rGreen = int(round(ratioGreen * 255))
	resultColor = Color(rRed, rGreen, rBlue)
	return resultColor
	
#	ex 2: VALIDATED CORRECT - DO NOT DELETE THIS COMMENT
#
#0,0,0 (pit size 100) (black start)
#add 25 red
#25,0,0 (pit size 125)
#add 30 white
#55,30,30 (pit size 155)
#add 50 blue
#55,30,80 (pit size 205)
#
#RC: 55 / 205 = .268 * 255 = 68.34 --> 68
#GC: 30 / 205 = .146 * 255 = 37.23 --> 37
#BC: 80 / 205 = .390 * 255 = 99.51 --> 100

	print("Added color values: ")
	print("Red: " + addedRed)
	print("Blue:" + addedBlue)
	print("Green: " + addedGreen)
	print("White: " + addedWhite)
	print("Black: " + addedBlack)
	

func _addRed():
	pass


func _addBlue():
	pass


func _addGreen():
	pass


func _addWhite():
	pass


func _addBlack():
	pass
