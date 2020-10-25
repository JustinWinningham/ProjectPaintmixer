extends Control

var version = 0.1
var profileName = null
var gs1 = null
var gs2 = null
var hatUnlocks = [1,0,0,0,0,0,0,0,0,0,0]
var hat = 1
var eyes = 1
var nose = 1
var body = 1

func _ready():
	pass
	
func form_save():
	var save_dict = {
		"version" : version,
		"profileName" : profileName,
		"gs1" : gs1,
		"gs2" : gs2,
		"hatUnlocks" : hatUnlocks,
		"hat" : hat,
		"eyes" : eyes,
		"nose" : nose,
		"body" : body
	}
	return save_dict
	
func save_profile(profile):
	var save_file = File.new()
	save_file.open(str("user://", profile, ".profile"), File.WRITE)
	save_file.store_var(form_save())
	save_file.close()
	return true

func load_profile(profile):
	var save_file = File.new()
	if not save_file.file_exists(str("user://", profile, ".profile")):
		return false
	
	save_file.open(str("user://", profile, ".profile"), File.READ)
	var profile_data = {}
	profile_data = save_file.get_var()
	save_file.close()
	for i in profile_data:
		set(i, profile_data[i])
	return true

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
