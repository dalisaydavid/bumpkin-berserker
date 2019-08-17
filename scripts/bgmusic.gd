extends Node2D

var achievement_title_text = 'Achievement: '
var kill_achievements
var plant_achievements
var game_ended = false

func _ready():
	$OverlayColor.color = Color('d7a97d')
	$BGMusic.play()
#
	kill_achievements = [
		[5,  'Mediocre Marksman'],
		[15, 'Fair Fighter'],
		[25, 'Rowdy Rifleman'],
		[35, 'Wild Warmonger'],
		[50, 'Bumpkin Berserker']
	]
	
	plant_achievements = [
	]
	
	set_process_input(false)
	
	$Character.connect('plant_collected', self, 'change_difficulty')

func get_kill_achievement(kill_count):
	var last_achievement
	for achievement in kill_achievements:
		if kill_count <= achievement[0]:
			last_achievement = achievement
			return [kill_count, achievement[1]]
	
	return [kill_count, last_achievement[1]]
	
func end_game():
	if game_ended:
		return
		
	$OverlayColor.color = Color('3a3836')
	$CanvasLayer/GameoverLabel.visible = true
	
	var achievement = get_kill_achievement($Character.kill_count)
	$CanvasLayer/AchievementLabel.visible = true
	$CanvasLayer/AchievementLabel.text = (str(achievement[0]) + ' kills: ' + achievement[1])
	 
	set_process_input(true)
	game_ended = true
	
func _input(event):
	if event.is_action_pressed('restart'):
		get_tree().reload_current_scene()
		
func change_difficulty():
	for i in range(4):
		var spawn_timer = get_node('EnemySpawn'+str(i)).get_node('Timer')
		if spawn_timer.wait_time <= 5:
			continue
		spawn_timer.wait_time = spawn_timer.wait_time - .1