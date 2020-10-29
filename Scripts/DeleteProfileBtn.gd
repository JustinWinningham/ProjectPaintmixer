extends Button

func _ready():
	pass # Replace with function body.


func _pressed():
	# TODO: This should be on its own confirmation screen, not only for confirming
	# the delete, but also to have the return repopulate the list (and remove the dead profile)
	# If player 1 input pressed
	PROFILEHANDLER.p1Profile.delete()
	PROFILEHANDLER.p1Profile.clean()
	get_tree().reload_current_scene()
