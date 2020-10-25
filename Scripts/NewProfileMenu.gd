extends Node

export(String) var scenePath

var canCreate = false
var playerName = "default"
var op1 = 1 # Hat
var op2 = 1 # Eyes
var op3 = 1 # Nose
var op4 = 1 # Body

# Since unlocks are tied to the profile, we can assume default unlock state when creating profile
func _ready():
	pass


func _on_Create_Profile_Button_pressed():
	var save_file = File.new()
	if(save_file.file_exists(str("user://", playerName, ".profile"))):
		# TODO: Create notification label saying the file exists
		return false
	if(canCreate):
		# TODO: Set notification label text to say "Saving..."
		PROFILEHANDLER.profileName = playerName
		PROFILEHANDLER.hat = op1
		PROFILEHANDLER.eyes = op2
		PROFILEHANDLER.nose = op3
		PROFILEHANDLER.body = op4
		PROFILEHANDLER.save_profile(playerName)
		get_tree().change_scene(scenePath)
		if get_tree().paused:
			get_tree().paused = false
		# Set default settings profile to this profile
		GLOBAL.default_profile = playerName

		return true
	return false


func _on_Name_Input_text_changed():
	playerName = $Name_Input.text
	if(!canCreate):
		canCreate = true
