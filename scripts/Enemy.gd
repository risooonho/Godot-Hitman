extends KinematicBody2D

export (int) var rounds = 8
export (float) var shot_error = PI/32
export (PackedScene) var Bullet

var velocity  = Vector2()
var speed     = 300
var shooting  = false
var reloading = false
var bullets   = rounds
var target

func _ready():
	get_groups().append('enemies')
	pass

func _process(delta):
	if bullets <= 0:
		reload()
	if target:
		var angle_to = get_angle_to(target.position)
		
		if angle_to > PI/16:
			rotate(PI/32)
		elif angle_to < -PI/16:
			rotate(-PI/32)
		else:
			look_at(target.position)
			shoot()
	
func _draw():
	draw_circle(Vector2(), $NoiseArea2D/CollisionShape2D.shape.radius, Color(1.0, 0.9, 0, 0.25))

func struck():
	queue_free()

func shoot():
	if not reloading and not shooting:
		shooting = true
		bullets -= 1
		$ShootingTimer.start()
		
		var bullet = Bullet.instance()
		$BulletContainer.add_child(bullet)
		bullet.start_at($Aim.global_position, rotation + rand_range(-shot_error, shot_error))

func reload():
	if not reloading and not shooting:
		reloading = true
		$AnimatedSprite.animation = 'reload'
		$ReloadTimer.start()

func _on_ShootingTimer_timeout():
	shooting = false

func _on_ReloadTimer_timeout():
	reloading = false
	bullets   = rounds
	$AnimatedSprite.animation = 'patrol'

func _on_NoiseArea2D_body_entered(body):
	if body.name == 'Player':
		target = body

func _on_NoiseArea2D_body_exited(body):
	if body == target:
		target = null