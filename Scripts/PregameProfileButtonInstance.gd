extends Button

func _ready():
	pass


func _pressed():
	get_parent().get_parent().get_parent().handle_listButton_press(text)
	
	#get_tree().get_local_root().handle_listButton_press(text)
