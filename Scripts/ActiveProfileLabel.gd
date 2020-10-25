extends Label

func _ready():
	pass # Replace with function body.

func _process(delta):
	if GLOBAL.profile_loaded == false:
		text = "CURRENT PROFILE: NONE"
	else:
		text = str("CURRENT PROFILE: ", GLOBAL.playerName)
	pass
