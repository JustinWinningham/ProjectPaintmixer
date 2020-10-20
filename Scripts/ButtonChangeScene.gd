extends Button

# allows this variable to be set in editor - the path of the scene we want to transition to when pressed
export(String) var scenePath


func _ready():
	pass

func _pressed():
	get_tree().change_scene(scenePath)
	if get_tree().paused:
		get_tree().paused = false
