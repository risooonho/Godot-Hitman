extends Node2D

var BloodSpray = preload('res://BloodSpray.tscn')

func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed('quit'):
		get_tree().quit()

func struck(pos, dir):
	var blood = BloodSpray.instance()
	blood.position = pos
	blood.rotation = dir
	$BloodParticles.add_child(blood)