extends Control
class_name Main_Menu
const create_game_menu =preload("res://UI/create_game_menu.tscn")
const join_game_menu =preload("res://UI/join_game_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_create_game_pressed():
	
	get_parent().add_child(create_game_menu.instantiate())
	self.queue_free()


func _on_join_game_pressed():
	get_parent().add_child(join_game_menu.instantiate())
	self.queue_free()


func _on_quit_pressed():
	var u_sure_menu =load ("res://UI/u_sure_menu.tscn").instantiate() as U_Sure_Menu
	add_child(u_sure_menu)
	await u_sure_menu.on_result_pressed
	if u_sure_menu.result:
		get_tree().quit()
	else:
		u_sure_menu.queue_free()
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.
