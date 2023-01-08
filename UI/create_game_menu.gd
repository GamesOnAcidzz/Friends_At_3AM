extends Control

const u_sure_menu_resource = preload("res://UI/u_sure_menu.tscn")
@onready var main_menu_resource = load("res://UI/main_menu.tscn")
var multiplayer_session:Multiplayer_Session = Multiplayer_Session.new()
const connection_lost_menu_resource = preload ("res://UI/connection_lost_menu.tscn")
var connection_lost_menu:Connection_lost_menu
var u_sure_menu:U_Sure_Menu
var game_chat = get_node("Control/Panel/Game Chat")
var main_menu:Main_Menu
var number_players_in_lobby = 1
var players:Array[Player]
var multiplayer_peer = ENetMultiplayerPeer.new()

signal all_peers_disconnected

# Called when the node enters the scene tree for the first time.
func _ready():
	game_chat as RichTextLabel
	multiplayer_session = get_node("/root/GAME/Multiplayer_Session")
	main_menu=main_menu_resource.instantiate()
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
		rpc ("server_disconnect_all_peers")
		if (multiplayer.is_server()):
			rpc ("server_disconnect_all_peers")
			all_peers_disconnected.emit()
			print("Server disconnect all peers")
		main_menu=main_menu_resource.instantiate()
		multiplayer_session.disconnect_peer()
		u_sure_menu.queue_free()
		self.queue_free()
		
		#await all_peers_disconnected
		get_parent().add_child(main_menu)
		
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
	
	multiplayer_session.host_game()
	multiplayer.set_multiplayer_peer(multiplayer_session.multiplayer_peer)
	multiplayer.peer_connected.connect(self._on_peer_connected)
	multiplayer.peer_disconnected.connect(self._on_peer_disconnected)
	$"VSplitContainer/Host Game".visibility_layer=0
	$"Game Chat/Panel/Game Chat RichLabelText".add_text("Server Created\n")
	pass # Replace with function body.

func _on_peer_connected(id:int):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(str(multiplayer_session.iplayer.name," ",id," just joined\n"))
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

func load_lobby():
	if (!multiplayer.is_server()):
		$"VSplitContainer/Host Game".visibility_layer=0
		$Time_connection_timeout.start()
		
	pass

func update_players_list():
	var player_panels = [$"Players Panel/Panel/VBoxContainer/Player 1 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 2 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel"] as Array[Control]
	var player_panels_label = [$"Players Panel/Panel/VBoxContainer/Player 1 Panel/Player 1 Label",
	$"Players Panel/Panel/VBoxContainer/Player 2 Panel/Player 2 Label",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel/Player 3 Label",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel/Player 4 Label"]
	
	for panel in player_panels:
		panel.visibility_layer=0
		
	for i in range(number_players_in_lobby):
		player_panels[i].visibility_layer=1
	
	
func _on_send_chat_button_pressed():
	var message = str(multiplayer_session.iplayer.name," ",multiplayer.get_unique_id(),": ",$"Game Chat/Panel2/Send Chat TextEdit".text,"\n") 
	#addText_to_game_chat_server_request(message)
	rpc("addText_to_game_chat_server_to_all_peers",message)
	$"Game Chat/Panel2/Send Chat TextEdit".text=""
	$"Game Chat/Panel2/Send Chat TextEdit".placeholder_text="Type message"
	pass # Replace with function body.

@rpc (any_peer,call_local) func addText_to_game_chat_server_to_all_peers(message:String):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(message)
@rpc func server_disconnect_all_peers():
	rpc ("disconnect_all_peers")
	
	
@rpc (any_peer,call_local) func disconnect_all_peers():
	#if (!multiplayer.is_server()):
		connection_lost_menu= connection_lost_menu_resource.instantiate()
		#connection_lost_menu.instantiate(connection_lost_menu_resource)
		add_child(connection_lost_menu)
		multiplayer_session.disconnect_peer()
		await connection_lost_menu.go_back
		self.queue_free()
		get_parent().add_child(main_menu)


func _on_time_connection_timeout_timeout():
	if(multiplayer_session.multiplayer_peer.get_connection_status()==0):
		$Time_connection_timeout.stop()
		connection_lost_menu= connection_lost_menu_resource.instantiate()
		#connection_lost_menu.instantiate(connection_lost_menu_resource)
		add_child(connection_lost_menu)
		multiplayer_session.disconnect_peer()
		await connection_lost_menu.go_back
		self.queue_free()
		get_parent().add_child(main_menu)
	pass # Replace with function body.
