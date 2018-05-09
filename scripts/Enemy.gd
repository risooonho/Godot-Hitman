extends KinematicBody2D

signal explode
signal shoot

export (int) var rounds = 8
export (float) var shot_error = PI/32

var velocity  = Vector2()
var speed     = 300
var shooting  = false
var reloading = false
var bullets   = rounds
var target_via_sound
var target_via_sight
var hit_pos

func init(pos):
	position = pos
	add_to_group('enemies')

func _physics_process(delta):
	if bullets <= 0:
		reload()
		
	if target_via_sight:
		aim_and_shoot()
	elif target_via_sound:
		turn_and_aim()

func turn_and_aim():
	var angle_to = get_angle_to(target_via_sound.position)
		
	if angle_to > PI/16:
		rotate(PI/32)
	elif angle_to < -PI/16:
		rotate(-PI/32)

func aim_and_shoot():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target_via_sight.position, [self], collision_mask)
	
	if result and result.collider.name == 'Player':
		look_at(target_via_sight.position)
		shoot()
	
func struck(pos, dir):
	emit_signal('explode', pos, dir)
	queue_free()

func shoot():
	if not reloading and not shooting:
		shooting = true
		bullets -= 1
		$ShootingTimer.start()
		
		emit_signal('shoot', $Aim.global_position, rotation + rand_range(-shot_error, shot_error))

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
		target_via_sound = body

func _on_NoiseArea2D_body_exited(body):
	if body == target_via_sound:
		target_via_sound = null

func _on_VisionArea2D_body_entered(body):
	if body.name == 'Player':
		target_via_sight = body

func _on_VisionArea2D_body_exited(body):
	if body == target_via_sight:
		target_via_sight = null
