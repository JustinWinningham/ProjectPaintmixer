extends Button

# allows this variable to be set in editor - the path of the scene we want to transition to when pressed
export(String) var scenePath
export(bool) var keepActivePlayers = false


func _ready():
	pass

func _pressed():
	get_tree().change_scene(scenePath)
	DATABANK.isP1Active = keepActivePlayers
	DATABANK.isP2Active = keepActivePlayers
	DATABANK.isP3Active = keepActivePlayers
	DATABANK.isP4Active = keepActivePlayers
	if get_tree().paused:
		get_tree().paused = false
