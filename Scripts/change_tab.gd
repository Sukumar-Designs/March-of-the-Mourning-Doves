extends TextureButton

var tab_container : TabContainer
@export var tab_number = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	tab_container = $"../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	tab_container.set_current_tab(tab_number)
