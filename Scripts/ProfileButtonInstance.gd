extends Button



func _ready():
	pass # Replace with function body.

func _pressed():
	get_parent().handle_listButton_press(text)
