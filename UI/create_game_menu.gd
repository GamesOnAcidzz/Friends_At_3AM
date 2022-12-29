extends Control
class_name Create_Game_Menu

const u_sure_menu_resource = preload("res://UI/u_sure_menu.tscn")
@onready var main_menu_resource = load("res://UI/main_menu.tscn")
var u_sure_menu:U_Sure_Menu
var main_menu:Main_Menu
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_pressed():
	u_sure_menu = u_sure_menu_resource.instantiate()
	add_child(u_sure_menu) 
	u_sure_menu as U_Sure_Menu
	#u_sure_menu.on_result_pressed.connect(_on_u_sure_result)
	await u_sure_menu.on_result_pressed
	if u_sure_menu.result:
		main_menu=main_menu_resource.instantiate()
		u_sure_menu.queue_free()
		get_parent().add_child(main_menu)
		self.queue_free()
	else: 
		u_sure_menu.queue_free()

func _on_u_sure_result(result:bool):
	if result:
		u_sure_menu.queue_free()
		get_parent().add_child(main_menu_resource.instantiate())
		#self.queue_free()
		
		
		
	pass
