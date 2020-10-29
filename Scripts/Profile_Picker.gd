extends Control

var loadable_profiles = null
#var currentMainProfile = null
var profile_list = ButtonGroup.new()

func _ready():
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
			button.set_script(preload("res://Scripts/ProfileButtonInstance.gd"))
			add_child(button)
	pass

func handle_listButton_press(Tuxt):
	# If Mouse or controller 0: default to profile 1
	# Right now, only one player, so we can just assume its for P1
	PROFILEHANDLER.p1Profile.load_from_file(Tuxt)
	# If controller 1, use profile 2
	# If controller 2, profile 3
	# If controller 3, profile 4
