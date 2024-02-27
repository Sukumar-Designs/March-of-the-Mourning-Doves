extends TabContainer

func _ready():
	var resources_texture: Texture = preload("res://Assets/squirrel soldier highlight small.png")
	var buildings_texture: Texture = preload("res://Assets/squirrel soldier highlight small.png")
	var soldiers_texture: Texture = preload("res://Assets/squirrel soldier highlight small.png")
	set_tab_button_icon(0, resources_texture)
	set_tab_title(0, "")
	set_tab_button_icon(1, buildings_texture)
	set_tab_title(1, "")
	set_tab_button_icon(2, soldiers_texture)
	set_tab_title(2, "")
