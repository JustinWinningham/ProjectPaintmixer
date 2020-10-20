extends Control

export(int) var timer = 4
export(String) var nextScene = "res://Scenes/Menus/MainMenu.tscn"
var fired = false

func _ready():
	pass


func _process(delta):
	timer -= delta
	if Input.is_action_just_pressed("PAUSE") or timer <= 0:
		get_tree().change_scene(nextScene)


func _on_Tween_ready():
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	if not fired:
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		fired = true
	pass
