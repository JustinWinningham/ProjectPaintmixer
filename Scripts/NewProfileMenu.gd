extends Node

export(String) var scenePath

var canCreate = true
var playerName = "default"
var op1 = 1
var op2 = 1
var op3 = 1
var op4 = 1

var unlocks1 = [] # populate with unlock states for op1
var unlocks2 = [] # populate with unlock states for op2
var unlocks3 = [] # populate with unlock states for op3
var unlocks4 = [] # populate with unlock states for op4


func _ready():
	# Populate unlock states from GLOBAL settings. Maybe just move those variables there?
	pass


func _on_Create_Profile_Button_pressed():
	if(canCreate):
		get_tree().change_scene(scenePath)
		if get_tree().paused:
			get_tree().paused = false
	pass


func _on_Name_Input_text_changed():
	playerName = $Name_Input.text
