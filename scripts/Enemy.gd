extends Node2D

export var move_speed = 100
export (NodePath) var move_path

var move_path_points
var move_path_index = 0
var velocity
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	$AnimationPlayer.play('Idle')
	
	if move_path:
		move_path_points = get_node(move_path).curve.get_baked_points()

func change_direction():
	var animation = 'Idle'
	
	if velocity.x < 0: # walking left.
		$KinematicBody2D/Sprite.flip_h = true
	else: #walking right
		$KinematicBody2D/Sprite.flip_h = false
	
	if velocity.y > 0: # walking down
		animation = 'walking_down_diagonal'
	elif velocity.y < 0:
		animation = 'walking_up_diagonal'
	else:
		animation = 'walking_side'
	$AnimationPlayer.play(animation)

func damage():
	is_dead = true
	move_path = null
	$AnimationPlayer.play('Dead')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not move_path:
		return
		
	var target = move_path_points[move_path_index]
	if $KinematicBody2D.global_position.distance_to(target) < 1:
		move_path_index = wrapi(move_path_index + 1, 0, move_path_points.size())
		target = move_path_points[move_path_index]
		
	velocity = (target - $KinematicBody2D.global_position).normalized() * move_speed
	$KinematicBody2D.move_and_slide(velocity)
	
	if not is_dead:
		change_direction()


func _on_AnimationPlayer_animation_finished(anim_name):
	pass
