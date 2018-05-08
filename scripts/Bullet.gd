extends Area2D

signal struck

export (int) var speed = 500

var velocity = Vector2()
var screen
	
func _ready():
	screen = get_viewport_rect().size
	
func start_at(pos, angle):
	position = pos
	rotation = angle - PI/2
	velocity = Vector2(1, 0).rotated(angle)

func _process(delta):
	position += velocity * speed * delta
	
	if position.x < 0 or position.x > screen.x or position.y < 0 or position.y > screen.y:
		queue_free()

func _on_Bullet_body_entered(body):
	queue_free()
	body.struck()
