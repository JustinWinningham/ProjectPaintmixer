extends Node

export(String) var scenePath

var canCreate = false
var playerName = "default"
var hat = 1 # Hat
var eyes = 1 # Eyes
var nose = 1 # Nose
var body = 1 # Body


# Since unlocks are tied to the profile, we can assume default unlock state when creating profile
func _ready():
	pass


func _on_Create_Profile_Button_pressed():
	var save_file = File.new()
	var newProfile = Profile.new()
	if(save_file.file_exists(str("user://", playerName, ".profile"))):
		return false
	if(canCreate):
		newProfile.setCustomization(hat,eyes,nose,body)
		newProfile.setName(playerName)
		newProfile.save()
		get_tree().change_scene(scenePath)
		if get_tree().paused:
			get_tree().paused = false
		return true
		# Remember, we are just creating the profile, not setting any defaults
		# So we just want to return to the profile picker screen at this point
	return false


func _on_Name_Input_text_changed():
	playerName = $Name_Input.text
	if(!canCreate):
		canCreate = true


func _on_Hat_Left_Button_pressed():
	if hat == 0:
		return
	hat = hat - 1
	$Hat_Selector/Hat_Label.text = str(hat + 1, "/", PROFILEHANDLER.maxHats + 1)


func _on_Hat_Right_Button_pressed():
	if hat == PROFILEHANDLER.maxHats:
		return
	hat = hat + 1
	$Hat_Selector/Hat_Label.text = str(hat + 1, "/", PROFILEHANDLER.maxHats + 1)


func _on_Eye_Left_Button_pressed():
	if eyes == 0:
		return
	eyes = eyes - 1
	$Eye_Selector/Eye_Label.text = str(eyes + 1, "/", PROFILEHANDLER.maxEyes + 1)


func _on_Eye_Right_Button_pressed():
	if eyes == PROFILEHANDLER.maxEyes:
		return
	eyes = eyes + 1
	$Eye_Selector/Eye_Label.text = str(eyes + 1, "/", PROFILEHANDLER.maxEyes + 1)


func _on_Nose_Left_Button_pressed():
	if nose == 0:
		return
	nose = nose - 1
	$Nose_Selector/Nose_Label.text = str(nose + 1, "/", PROFILEHANDLER.maxNose + 1)


func _on_Nose_Right_Button_pressed():
	if nose == PROFILEHANDLER.maxNose:
		return
	nose = nose + 1
	$Nose_Selector/Nose_Label.text = str(nose + 1, "/", PROFILEHANDLER.maxNose + 1)


func _on_Body_Left_Button_pressed():
	if body == 0:
		return
	body = body + 1
	$Body_Selector/Body_Label.text = str(body + 1, "/", PROFILEHANDLER.maxBody + 1)


func _on_Body_Right_Button_pressed():
	if body == PROFILEHANDLER.maxBody:
		return
	body = body + 1
	$Body_Selector/Body_Label.text = str(body + 1, "/", PROFILEHANDLER.maxBody + 1)
