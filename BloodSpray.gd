extends Particles2D

func init(pos, dir):
	position = pos
	rotation = dir
	emitting = true

func _on_Lifetime_timeout():
	queue_free()
