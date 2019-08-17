extends Node2D

func _ready():
	$OverlayColor.color = Color('d7a97d')
	$BGMusic.play()
	
	set_process_input(false)
	
func end_game():
	$OverlayColor.color = Color('3a3836')
	$CanvasLayer/GameoverLabel.visible = true
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed('restart'):
		get_tree().reload_current_scene()