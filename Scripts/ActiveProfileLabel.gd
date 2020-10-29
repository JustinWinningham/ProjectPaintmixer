extends Label

func _ready():
	pass # Replace with function body.

func _process(delta):
	if PROFILEHANDLER.p1Profile.getName() == "default":
		text = "CURRENT PROFILE: NONE"
	else:
		text = str("CURRENT PROFILE: ", PROFILEHANDLER.p1Profile.getName())
	pass
