extends Node2D

func _ready():
	$OverlayColor.color = Color('d7a97d')
	$BGMusic.play()
	
	set_process_input(false)
	
	$Character.connect('plant_collected', self, 'change_difficulty')
	
func end_game():
	$OverlayColor.color = Color('3a3836')
	$CanvasLayer/GameoverLabel.visible = true
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed('restart'):
		get_tree().reload_current_scene()
		
func change_difficulty():
	for i in range(4):
		var spawn_timer = get_node('EnemySpawn'+str(i)).get_node('Timer')
		if spawn_timer.wait_time <= 5:
			continue
		spawn_timer.wait_time = spawn_timer.wait_time - .1