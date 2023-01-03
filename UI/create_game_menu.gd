extends Control
class_name Create_Game_Menu

const u_sure_menu_resource = preload("res://UI/u_sure_menu.tscn")
@onready var main_menu_resource = load("res://UI/main_menu.tscn")
var u_sure_menu:U_Sure_Menu
var game_chat = get_node("Control/Panel/Game Chat")
var main_menu:Main_Menu
var number_players_in_lobby = 1
var multiplayer_peer = ENetMultiplayerPeer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	game_chat as RichTextLabel
	
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
		multiplayer.set_multiplayer_peer(null)
		u_sure_menu.queue_free()
		get_parent().add_child(main_menu)
		self.queue_free()
	else: 
		u_sure_menu.queue_free()

func _on_u_sure_result(result:bool):
	if result:
		multiplayer_peer.close
		u_sure_menu.queue_free()
		get_parent().add_child(main_menu_resource.instantiate())
		#self.queue_free()
		
		
		
	pass


func _on_host_game_pressed():
	
	var result = multiplayer_peer.create_server(5555,4,0,0,0)
	
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	
	$"VSplitContainer/Host Game".visibility_layer=0
	$"Game Chat/Panel/Game Chat RichLabelText".add_text("Server Created\n")
	pass # Replace with function body.

func _on_peer_connected(id:int):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(str("Player ",id," just joined\n"))
	number_players_in_lobby=number_players_in_lobby+1
	if (multiplayer.is_server()):
		update_players_list()
		
	else:
		load_lobby()
	
	pass
	
func _on_peer_disconnected(id:int):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(str("Player ",id," just left\n"))
	number_players_in_lobby=number_players_in_lobby-1
	if (multiplayer.is_server()):
		update_players_list()
		
	else:
		load_lobby()
	
	pass

func load_lobby():
	if (!multiplayer.is_server()):
		$"VSplitContainer/Host Game".visibility_layer=0
		
	pass

func update_players_list():
	var player_panels = [$"Players Panel/Panel/VBoxContainer/Player 1 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 2 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel"] as Array[Control]
	for panel in player_panels:
		panel.visibility_layer=0
		
	for i in range(number_players_in_lobby):
		player_panels[i].visibility_layer=1
	
	
func _on_send_chat_button_pressed():
	var message = str("Player ",multiplayer.get_unique_id(),": ",$"Game Chat/Panel2/Send Chat TextEdit".text,"\n") 
	#addText_to_game_chat_server_request(message)
	rpc("addText_to_game_chat_server_to_all_peers",message)
	$"Game Chat/Panel2/Send Chat TextEdit".text=""
	$"Game Chat/Panel2/Send Chat TextEdit".placeholder_text="Type message"
	pass # Replace with function body.

@rpc (any_peer,call_local) func addText_to_game_chat_server_to_all_peers(message:String):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(message)
