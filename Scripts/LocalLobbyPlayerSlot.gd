extends Control

export(int) var playerNumber = 1
var loadable_profiles = null
var joined = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# TODO: Make this less ugly (store as array maybe?)
func _on_JoinButton_pressed():
	if joined:
		$DEBUGSTATUS.text = "Press button to join!"
		$ScrollContainer.visible = false
		delete_children($ScrollContainer/VBoxContainer)
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
		_showProfiles()
		$ScrollContainer.visible = true


func handle_listButton_press(Tuxt):
	print("Pressed a button on player: " + Tuxt + " in slot: " + str(playerNumber))
	var targetProfile = Profile.new()
	targetProfile.load_from_file(Tuxt)
	joined = true
	match playerNumber:
			1:
				PROFILEHANDLER.p1Profile = targetProfile
				DATABANK.isP1Active = true
			2:
				PROFILEHANDLER.p2Profile = targetProfile
				DATABANK.isP2Active = true
			3:
				PROFILEHANDLER.p3Profile = targetProfile
				DATABANK.isP3Active = true
			4:
				PROFILEHANDLER.p4Profile = targetProfile
				DATABANK.isP4Active = true
	$ScrollContainer.visible = false
	pass


func _showProfiles():
	print("Searching for existing profiles")
	loadable_profiles = PROFILEHANDLER.find_prof_files()
	var num_profiles = loadable_profiles.size()
	if num_profiles > 0:
		print("Profiles found!")
		print("Populating profile list")
		for i in num_profiles:
			var button = Button.new()
			button.set_size(Vector2(200,40))
			button.text = loadable_profiles[i]
			button.set_script(preload("res://Scripts/PregameProfileButtonInstance.gd"))
			$ScrollContainer/VBoxContainer.add_child(button)
	pass


static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
