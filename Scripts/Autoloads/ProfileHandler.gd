extends Node

#onready var Profiles = preload("res://Scripts/Classes/Profile.gd")

#var saveVersion = 0.1
#var profileName = null
#var gs1 = null
#var gs2 = null
#var hatUnlocks = [1,0,0,0,0,0,0,0,0,0,0]
#var hat = 1
#var eyes = 1
#var nose = 1
#var body = 1

var p1Profile
var p2Profile
var p3Profile
var p4Profile

const maxHats = 11
const maxEyes = 8
const maxNose = 4
const maxBody = 4

var profile_currently_handling = 1


func _ready():
	p1Profile = Profile.new()
	p2Profile = Profile.new()
	p3Profile = Profile.new()
	p4Profile = Profile.new()
	
#	if(GLOBAL.default_profile != ""):
#		print("Profile Handler loading default profile specified by GLOBAL")
#		# Load the data from the settings file into the p1profile handler slot
#		p1Profile.load_from_file(GLOBAL.default_profile)
#	else:
#		print("Profile Handler didnt find a default profile to load from GLOBAL, assuming default values")
#	pass


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
