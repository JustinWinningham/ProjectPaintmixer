extends Button

export(String) var scenePath

func _ready():
	visible = false

func _process(delta):
	if DATABANK.isP1Active || DATABANK.isP2Active || DATABANK.isP3Active || DATABANK.isP4Active:
		visible = true
	else:
		visible = false

func _pressed():
	get_tree().change_scene(scenePath)
	if get_tree().paused:
		get_tree().paused = false
