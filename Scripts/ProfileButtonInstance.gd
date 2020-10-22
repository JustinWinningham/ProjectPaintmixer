extends Button



func _ready():
	pass # Replace with function body.

func on_button_pressed():
	get_parent().handle_listButton_press(text)
