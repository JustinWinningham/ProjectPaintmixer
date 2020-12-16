extends Node

class_name Profile

var saveVersion
var profileName
var profileSettings
var hatUnlocks
var characterOutfit

# Stats
var stat_GamesPlayed = 0
var stat_RoundsPlayed = 0
var stat_GameWins = 0
var stat_RoundWins = 0
var stat_AverageAccuracy = 0 # aka round score
var stat_PerfectGuesses = 0

func _init():
	self.saveVersion = 0.2
	self.profileName = "default"
	self.profileSettings = []
	self.hatUnlocks = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
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


func getUnlockedHats():
	var unKlocks = "["
	for i in hatUnlocks:
		unKlocks += str(hatUnlocks[i]) + ", "
	unKlocks.erase(unKlocks.length() - 1, 1)
	unKlocks += "]"
	return unKlocks


func getStat_RoundsPlayed():
	return stat_RoundsPlayed

func getStat_RoundWins():
	return stat_RoundWins

func getStat_AverageScore():
	return stat_AverageAccuracy

func getStat_PerfectGuesses():
	return stat_PerfectGuesses


func save():
	var save_file = File.new()
	save_file.open(str("user://", profileName, ".profile"), File.WRITE)
	var saveData = _form_save()
	save_file.store_var(saveData)
	save_file.close()
	return true


func mock_update():
	pass
	

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
	unlock_hat(1)
	for i in characterOutfit:
		characterOutfit[i] = 0
	profileSettings = []
	stat_GamesPlayed = 0
	stat_RoundsPlayed = 0
	stat_GameWins = 0
	stat_RoundWins = 0
	stat_AverageAccuracy = 0 # aka round score
	stat_PerfectGuesses = 0
	return true


func delete():
	var dir = Directory.new()
	print(str("Deleting profile: ","user://", profileName, ".profile"))
	dir.remove(str("user://", profileName, ".profile"))


func _form_save():
	var save_dict = {
		"saveVersion" : saveVersion, #
		"profileName" : profileName, #
		"profileSettings" : profileSettings, #
		"hatUnlocks" : hatUnlocks, #
		"characterOutfit" : characterOutfit, #
		"stat_GamesPlayed" : stat_GamesPlayed, #
		"stat_RoundsPlayed" : stat_RoundsPlayed, #
		"stat_GameWins" : stat_GameWins, #
		"stat_RoundWins" : stat_RoundWins, #
		"stat_AverageAccuracy" : stat_AverageAccuracy, #
		"stat_PerfectGuesses" : stat_PerfectGuesses #
	}
	return save_dict


# Converts an old save version to a new save version
func _convert_save(oldData, desiredVersion):
	pass


# Called at the end of each game
# didwin - bool : true if player won the game, false if they tied or lost
func updateStats_GameOver(didWin: bool):
	stat_GamesPlayed += 1
	if didWin:
		stat_GameWins += 1
	save()


func updateStats_RoundOver(didWin: bool, roundScore: int):
	if didWin:
		stat_RoundWins += 1
		if stat_RoundWins > 10:
			unlock_hat(2)
		if stat_RoundWins > 50:
			unlock_hat(3) # unlock 50 round wins hat
		if stat_RoundWins > 100:
			unlock_hat(4) # unlock 100 round wins hat
		if stat_RoundWins > 500:
			unlock_hat(5) # unlock 500 round wins hat
		if stat_RoundWins > 1000:
			unlock_hat(6) # unlock 1000 round wins hat
	if roundScore == 765:
		stat_PerfectGuesses += 1
		unlock_hat(1) # unlock perfect guess hat
	stat_AverageAccuracy = (stat_RoundsPlayed * stat_AverageAccuracy + roundScore) / (stat_RoundsPlayed + 1)
	stat_RoundsPlayed += 1
	print("Updating rounds played to: " + str(stat_RoundsPlayed))
	if stat_RoundsPlayed > 10:
		unlock_hat(7)
	if stat_RoundsPlayed > 100:
		unlock_hat(8)
	if stat_RoundsPlayed > 500:
		unlock_hat(9)
	if stat_RoundsPlayed > 1000:
		unlock_hat(10)
	if stat_RoundsPlayed > 5000:
		unlock_hat(11)
	if stat_RoundsPlayed > 10000:
		unlock_hat(12)
	# Check for average score hat unlock
	if stat_AverageAccuracy > 730 && stat_RoundsPlayed > 50:
		unlock_hat(13)
	save()
