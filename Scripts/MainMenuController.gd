extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu ready!")
	var p1Body = PROFILEHANDLER.p1Profile.getCustomizations()
	$DBL1.text = PROFILEHANDLER.p1Profile.getName()
	$DBL2.text = str("Hat: ", p1Body[0])
	$DBL3.text = str("Eyes: ", p1Body[1]) 
	$DBL4.text = str("Nose: ", p1Body[2])
	$DBL5.text = str("Body: ", p1Body[3])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
