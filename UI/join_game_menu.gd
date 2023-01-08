extends Control

@onready var create_game_menu_resource =preload("res://UI/create_game_menu.tscn")
@onready var create_game_menu = create_game_menu_resource.instantiate()
@onready var main_menu_resource = load("res://UI/main_menu.tscn")

const u_sure_menu_resource = preload("res://UI/u_sure_menu.tscn")
var u_sure_menu:U_Sure_Menu
var main_menu:Main_Menu
var multiplayer_session:Multiplayer_Session = Multiplayer_Session.new()
#var multiplayer_peer = ENetMultiplayerPeer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer_session = get_node("/root/GAME/Multiplayer_Session")
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
	pass # Replace with function body.


func _on_join_game_pressed():
	
	get_node("/root/").add_child(multiplayer_session,true)
	multiplayer_session.join_game()
	#var result = multiplayer_peer.create_client("localhost",5555)
	#print (multiplayer_peer.get_unique_id())
	multiplayer.set_multiplayer_peer(multiplayer_session.multiplayer_peer)
	multiplayer.peer_connected.connect(self._on_peer_connected)
	
	
	#create_game_menu.multiplayer.set_multiplayer_peer(multiplayer_peer)
	pass # Replace with function body.
	
func _on_peer_connected(id:int):
	self.queue_free()
	get_parent().add_child(create_game_menu)
	create_game_menu.load_lobby()
	
	
