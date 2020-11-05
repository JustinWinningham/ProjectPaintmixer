extends Control

export(int) var playerNumber = 1
var joined = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# TODO: Make this less ugly (store as array maybe?)
func _on_JoinButton_pressed():
	if joined:
		$DEBUGSTATUS.text = "Press button to join!"
		joined = false
		match playerNumber:
			1:
				DATABANK.isP1Active = false
			2:
				DATABANK.isP2Active = false
			3:
				DATABANK.isP3Active = false
			4:
				DATABANK.isP4Active = false
	else:
		$DEBUGSTATUS.text = "Ready!"
		joined = true
		match playerNumber:
			1:
				DATABANK.isP1Active = true
			2:
				DATABANK.isP2Active = true
			3:
				DATABANK.isP3Active = true
			4:
				DATABANK.isP4Active = true

