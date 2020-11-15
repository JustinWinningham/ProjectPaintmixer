extends Node

enum GAMESTATE {IDLE, ENTERSCENE, LEAVESCENE, POURING, MIXING, WIN, LOSE}
var STATE
var did_find_settings = false
var max_add_volume = 100
var generic_setting_2  = "gs2"


func _ready():
	STATE = GAMESTATE.IDLE
	print("GLOBAL Loaded, attempting to load settings...")
	if load_settings():
		did_find_settings = true
		print("Settings loaded successfully!")
	pass


func _process(delta):
	randomize()
	pass


func form_save():
	var save_dict = {
		"max_add_volume" : max_add_volume,
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
		print("Unable to find existing settings file, creating now.")
		save_settings()
	save_file.open(str("user://settings.txt"), File.READ)
	var settings_data = {}
	settings_data = save_file.get_var()
	save_file.close()
	# This loop explained: For each line in the save file (remember that one line is one variable)
	# set a matching variable (by name) to the value of that dic pair in this script.
	# This is why our save_dict in the form_save() function requires the name to match
	# the name to the variable EXACTLY, despite being a string
	for i in settings_data:
		set(i, settings_data[i])
	return true
