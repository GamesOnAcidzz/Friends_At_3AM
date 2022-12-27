extends Control
class_name Main_Menu
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_create_game_pressed():
	pass # Replace with function body.


func _on_join_game_pressed():
	var join_game_menu = Join_Game_Menu.new()
	get_parent().add_child(join_game_menu)
	self.queue_free()
	pass # Replace with function body.


func _on_quit_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.
