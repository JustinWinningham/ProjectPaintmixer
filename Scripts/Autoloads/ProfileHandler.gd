extends Node

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
