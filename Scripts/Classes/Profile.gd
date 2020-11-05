extends Node

class_name Profile

var saveVersion
var profileName
var profileSettings
var hatUnlocks
var characterOutfit

func _init():
	self.saveVersion = 0.1
	self.profileName = "default"
	self.profileSettings = []
	self.hatUnlocks = [1,0,0,0,0,0,0,0,0,0,0]
	self.characterOutfit = [1,1,1,1]


func unlock_hat(index):
	if index == 1:
		if profileName != "Daxx":
			return
	hatUnlocks[index] = 1

func setName(name):
	self.profileName = name

func getName():
	return self.profileName

func setCustomization(hat,eyes,nose,body):
	self.characterOutfit[0] = hat
	self.characterOutfit[1] = eyes
	self.characterOutfit[2] = nose
	self.characterOutfit[3] = body


func getCustomizations():
	return self.characterOutfit


func save():
	var save_file = File.new()
	save_file.open(str("user://", profileName, ".profile"), File.WRITE)
	save_file.store_var(_form_save())
	save_file.close()
	return true


func load_from_file(location):
	print("Attempting to load from: " + location)
	var save_file = File.new()
	if not save_file.file_exists(str("user://", location)):
		print("Unable to find desired profile, aborting")
		print(str("user://", location, ".profile"))
		return false

	save_file.open(str("user://", location), File.READ)
	var profile_data = {}
	profile_data = save_file.get_var()
	save_file.close()
	# Add version checker here
	for i in profile_data:
		set(i, profile_data[i])
	return true


func clean():
	setCustomization(1,1,1,1)
	setName("default")
	for i in hatUnlocks:
		hatUnlocks[i] = 0
	hatUnlocks[0] = 1
	profileSettings = []


func delete():
	var dir = Directory.new()
	print(str("Deleting profile: ","user://", profileName, ".profile"))
	dir.remove(str("user://", profileName, ".profile"))


func _form_save():
	var save_dict = {
		"saveVersion" : saveVersion,
		"profileName" : profileName,
		"profileSettings" : profileSettings,
		"hatUnlocks" : hatUnlocks,
		"characterOutfit" : characterOutfit
	}
	return save_dict


func _convert_save(oldData, desiredVersion):
	pass
