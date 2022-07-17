extends Node

export var player_path: NodePath
onready var player: KinematicBody2D = get_node(player_path)

onready var timer := $Timer
onready var show_game_over_timer := $Timer2
onready var game_over := $"../CanvasLayer/GameOver"
onready var death_sound := $DeathSound

var playing = false
var velocity = Vector2.ZERO

func play():
	get_tree().paused = true
	timer.start()
	show_game_over_timer.start()
	
	player.call_deferred("disable_collision")
	velocity = Vector2.UP * 800

func _process(delta):
	if not playing: return
	
	player.rotation_degrees += 800 * delta
	
	velocity += Vector2.DOWN * 50
	velocity = player.move_and_slide(velocity)


func _on_Timer_timeout():
	playing = true
	death_sound.play()


func _on_Timer2_timeout():
	game_over.show()


func _on_Button_pressed():
	SceneManager.change_scene("res://scenes/menu/StartMenu.tscn")
