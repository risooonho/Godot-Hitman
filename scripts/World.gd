extends Node2D

var Blood   = preload('res://BloodSpray.tscn')
var Bullet  = preload('res://Bullet.tscn')
var Enemies = [
	preload('res://units/Blue.tscn')
]

func _ready():
	randomize()
	
	$Player.connect('explode', self, 'spawn_blood')
	$Player.connect('shoot', self, 'spawn_bullet')
	$Player.connect('game_over', self, 'game_over')
	
	for spawn in $EnemySpawns.get_children():
		spawn_enemy(spawn.position)

func _input(event):
	if event.is_action_pressed('quit'):
		get_tree().quit()
		
func spawn_enemy(pos):
	var Enemy = Enemies[randi() % Enemies.size()]
	var enemy
	
	enemy = Enemy.instance()
	enemy.init(pos)
	enemy.connect('explode', self, 'spawn_blood')
	enemy.connect('shoot', self, 'spawn_bullet')
	
	$EnemyContainer.add_child(enemy)
		
func spawn_blood(pos, dir):
	var blood
	
	blood = Blood.instance()
	blood.init(pos, dir)
	
	$BloodContainer.add_child(blood)

func spawn_bullet(pos, dir):
	var bullet
	
	bullet = Bullet.instance()
	bullet.init(pos, dir)
	
	$BulletContainer.add_child(bullet)

func game_over():
	pass