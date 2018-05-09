extends KinematicBody2D

signal game_over
signal explode
signal shoot

export (int) var walk_speed = 300
export (int) var run_speed = 500
export (int) var rounds = 8

var velocity  = Vector2()
var speed     = walk_speed
var shooting  = false
var reloading = false
var bullets   = rounds

func _ready():
	$AnimatedSprite.animation = 'walk'

func _physics_process(delta):
	var force = Vector2()
	
	if Input.is_action_pressed('ui_left'):
		force.x -= 1
	if Input.is_action_pressed('ui_right'):
		force.x += 1
	if Input.is_action_pressed('ui_up'):
		force.y -= 1
	if Input.is_action_pressed('ui_down'):
		force.y += 1
		
	if force.length() > 0:
		velocity = force.normalized() * speed
		
		if not Input.is_action_pressed('strafe'):
			rotation = force.angle()
	else:
		velocity *= 0
		
	if not Input.is_action_pressed('lock'):
		move_and_slide(velocity)

func _input(event):
	if event.is_action_pressed('run'):
		speed = run_speed
	else:
		speed = walk_speed

	if event.is_action_pressed('reload'):
		reload()
		
	if event.is_action_pressed('shoot'):
		shoot()
		
func reload():
	if not reloading and not shooting:
		reloading = true
		$AnimatedSprite.animation = 'reload'
		$ReloadTimer.start()
	
func shoot():
	if not reloading and not shooting:
		shooting = true
		bullets -= 1
		$AnimatedSprite.animation = 'shoot'
		$ShootingTimer.start()
		
		emit_signal('shoot', $Aim.global_position, rotation)
		
func struck(pos, dir):
#	emit_signal('explode', pos, dir)
#	emit_signal('game_over')
#	queue_free()
	pass

func _on_ReloadTimer_timeout():
	reloading = false
	bullets   = rounds
	$AnimatedSprite.animation = 'walk'

func _on_ShootingTimer_timeout():
	shooting = false
	$AnimatedSprite.animation = 'walk'
