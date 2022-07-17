extends Control

onready var exit_btn := $CenterContainer/VBoxContainer/VBoxContainer/ExitBtn

func _ready():
	if OS.get_name() == "HTML5":
		exit_btn.hide()


func _on_ExitBtn_pressed():
	get_tree().quit()


func _on_StartBtn_pressed():
	SceneManager.change_scene("res://scenes/Game.tscn")
