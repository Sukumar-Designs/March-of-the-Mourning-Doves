extends Node

var menu_open = false

@onready var resume_button

func _ready():
	resume_button = $resume_button


func _input(event):
	if Input.is_action_just_pressed("pause"):
		menu_switch()


func menu_switch():
	print_debug(menu_open)
	resume_button.visible = !menu_open
	get_tree().paused = !menu_open
	menu_open = !menu_open


func _on_resume_button_pressed():
	menu_switch()
