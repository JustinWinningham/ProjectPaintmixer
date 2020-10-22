extends Control

var loadable_profiles = null
var currentProfile = null
var profile_list = ButtonGroup.new()

func _ready():
	loadable_profiles = find_prof_files()
	var num_profiles = loadable_profiles.size()
	if num_profiles > 0:
		if GLOBAL.profile_loaded:
			currentProfile = GLOBAL.default_profile
		for i in num_profiles:
			var button = Button.new()
			button.set_size(Vector2(200,40))
			button.text = loadable_profiles[i]
			button.set_script(preload("res://Scripts/ProfileButtonInstance.gd"))
			add_child(button)
	pass

func handle_listButton_press(Tuxt):
	currentProfile = Tuxt
	GLOBAL.default_profile = Tuxt
	GLOBAL.profile_loaded = true
	pass

func find_prof_files():
	var prof_files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".profile"):
			prof_files.append(file)
	return prof_files
