extends KinematicBody2D

export (int) var walk_speed = 300
export (int) var run_speed  = 500
export (int) var clips  = 5
export (int) var rounds = 8
export (PackedScene) var Bullet

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
		velocity = force.normalized() * speed * delta
		
		if not Input.is_action_pressed('strafe'):
			rotation = force.angle()
	else:
		velocity *= 0
		
	if not Input.is_action_pressed('lock'):
		move_and_collide(velocity)

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
		rounds    -= 1
		$AnimatedSprite.animation = 'reload'
		$ReloadTimer.start()
	
func shoot():
	if not reloading and not shooting:
		shooting = true
		bullets -= 1
		$AnimatedSprite.animation = 'shoot'
		$ShootingTimer.start()
		
		var bullet = Bullet.instance()
		$BulletContainer.add_child(bullet)
		bullet.start_at($Aim.global_position, rotation)

func _on_ReloadTimer_timeout():
	reloading = false
	bullets   = rounds
	$AnimatedSprite.animation = 'walk'

func _on_ShootingTimer_timeout():
	shooting = false
	$AnimatedSprite.animation = 'walk'
