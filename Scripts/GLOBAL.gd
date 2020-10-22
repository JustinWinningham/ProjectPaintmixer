extends Node

# game state machine
enum GAMESTATE {IDLE, ENTERSCENE, LEAVESCENE, POURING, MIXING, WIN, LOSE}
var STATE

var did_find_settings = false
var profile_loaded = false
# Holds all our profile names
#var profile_strings = []
# Default player name
# These stats and related save functions will be moved to the profile section - we will save generic settings here instead
var default_profile = ""
var generic_setting_1 = "gs1"
var generic_setting_2  = "gs2"

var playerName = "Painter"

func _ready():
	STATE = GAMESTATE.IDLE
	print("GLOBAL Loaded")
	if load_settings():
		did_find_settings = true
	else:
		print("Unable to load settings!")
	pass

func _process(delta):
	randomize()
	pass

func form_save():
	var save_dict = {
		"default_profile" : default_profile,
		"generic_setting_1" : generic_setting_1,
		"generic_setting_2" :generic_setting_2
	}
	return save_dict
	
func save_settings():
	var save_file = File.new()
	save_file.open(str("user://settings.txt"), File.WRITE)
	save_file.store_var(form_save())
	save_file.close()
	return true

func load_settings():
	var save_file = File.new()
	if not save_file.file_exists(str("user://settings.txt")):
		return false
	
	save_file.open(str("user://settings.txt"), File.READ)
	var profile_data = {}
	profile_data = save_file.get_var()
	save_file.close()
	# This loop explained: For each line in the save file (remember that one line is one variable)
	# set a matching variable (by name) to the value of that dic pair in this script.
	# This is why our save_dict in the form_save() function requires the name to match
	# the name to the variable EXACTLY, despite being a string
	for i in profile_data:
		set(i, profile_data[i])
	return true
