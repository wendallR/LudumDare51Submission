extends Node2D


onready var _main_menu = load("res://MainMenu/MainMenu.tscn")
onready var _player := find_node("Player")
onready var _bullet_spawner := find_node("BulletSpawner")
onready var _enemy_spawner := find_node("EnemySpawner")
onready var _hud := find_node("HUD")


func _ready() -> void:
	_hud.bullet_spawner = _bullet_spawner
	_bullet_spawner.player = _player
	# warning-ignore:return_value_discarded
	_player.connect("fired", self, "_on_fired")
	# warning-ignore:return_value_discarded
	_enemy_spawner.connect("spawned", self, "_on_spawned")
	# warning-ignore:return_value_discarded
	_hud.connect("restart", self, "_on_restart")


func _on_fired(id: int, fired_from: KinematicBody2D) -> void:
	var spawn_location := fired_from.position
	_bullet_spawner.spawn_bullet(Vector3(spawn_location.x, spawn_location.y, id))


func _on_spawned(enemy):
	# warning-ignore:return_value_discarded
	_bullet_spawner.connect("enemy_killed", enemy, "_on_killed")
	enemy.connect("fired", self, "_on_fired")


func _on_restart():
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(_main_menu)
