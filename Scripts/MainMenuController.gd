extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu ready!")
	var p1Body = PROFILEHANDLER.p1Profile.getCustomizations()
	$DBL1.text = PROFILEHANDLER.p1Profile.getName()
	$DBL2.text = str("Hat: ", p1Body[0])
	$DBL3.text = str("Eyes: ", p1Body[1]) 
	$DBL4.text = str("Nose: ", p1Body[2])
	$DBL5.text = str("Body: ", p1Body[3])
	$DBL6.text = str("Hat Unlocks: ", str(PROFILEHANDLER.p1Profile.hatUnlocks))
	$DBL7.text = str("Rounds Played: ", str(PROFILEHANDLER.p1Profile.getStat_RoundsPlayed()))
	$DBL8.text = str("Average Round Score: ", str(PROFILEHANDLER.p1Profile.getStat_AverageScore()))
