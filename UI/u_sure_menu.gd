extends Control
class_name U_Sure_Menu
var result:bool = false
signal on_result_pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_yes_pressed():
	result=true
	emit_signal("on_result_pressed")
	pass # Replace with function body.


func _on_no_pressed():
	result=false
	emit_signal("on_result_pressed")
	
	pass # Replace with function body.
