extends Control

const u_sure_menu_resource = preload("res://UI/u_sure_menu.tscn")
@onready var main_menu_resource = load("res://UI/main_menu.tscn")
var multiplayer_session:Multiplayer_Session = Multiplayer_Session.new()
const connection_lost_menu_resource = preload ("res://UI/connection_lost_menu.tscn")
var connection_lost_menu:Connection_lost_menu
var u_sure_menu:U_Sure_Menu
var game_chat = get_node("Control/Panel/Game Chat")
var main_menu:Main_Menu
var timer_player_left:Timer =Timer.new()
var multiplayer_peer = ENetMultiplayerPeer.new()
var player_left=false
@onready var player_panels = [$"Players Panel/Panel/VBoxContainer/Player 1 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 2 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel"] 
@onready var player_panels_label = [$"Players Panel/Panel/VBoxContainer/Player 1 Panel/Player 1 Label",
	$"Players Panel/Panel/VBoxContainer/Player 2 Panel/Player 2 Label",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel/Player 3 Label",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel/Player 4 Label"]
@onready var player_panels_button =[$"Players Panel/Panel/VBoxContainer/Player 2 Panel/Player 2 Kick Button",
	$"Players Panel/Panel/VBoxContainer/Player 3 Panel/Player 3 Kick Button",
	$"Players Panel/Panel/VBoxContainer/Player 4 Panel/Player 4 Kick Button"]
signal all_peers_disconnected
signal player_removed
# Called when the node enters the scene tree for the first time.
func _ready():
	game_chat as RichTextLabel
	multiplayer_session = get_node("/root/GAME/Multiplayer_Session")
	timer_player_left=$Timer_player_left
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
	timer_player_left.start()
	$"VSplitContainer/Host Game".visibility_layer=0
	$"Game Chat/Panel/Game Chat RichLabelText".add_text("Server Created\n")
	request_server_to_update_player_list()
	pass # Replace with function body.

func _on_peer_connected(id:int):
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(str(multiplayer_session.player_data.player_name," ",id," just joined\n"))
	print("Player connected")
	if (!multiplayer.is_server()):
		load_lobby()
	rpc("update_players_list")	
	
	pass
func _on_peer_disconnected(id:int):
	print("Player disconnected: ",id)
	$"Game Chat/Panel/Game Chat RichLabelText".add_text(str("Player ",id," just left\n"))
	if (multiplayer.is_server()):
		multiplayer_session.remove_player_by_id(id)
		player_left=true
	else:
		load_lobby()

func load_lobby():
	if (!multiplayer.is_server()):
		$"VSplitContainer/Host Game".visibility_layer=0
		$"Players Panel/Start Game".visibility_layer=0
		$Time_connection_timeout.start()
		for kick_button in player_panels_button:
			kick_button.visible=false
		multiplayer_session.add_player_to_network_to_server()
		rpc_id(1,"request_server_to_update_player_list")

@rpc (any_peer) func request_server_to_update_player_list():
	var player_names:Array[String]
	for c in multiplayer_session.get_children():
		player_names.append(str(c.player_name," ",c.multiplayer_id))
	rpc("update_players_list",player_names)
	
@rpc (call_local)func update_players_list(player_names):
	
	for panel in player_panels:
		panel.visibility_layer=0
	
	for i in range(player_names.size()):
		player_panels_label[i].text=""
		player_panels[i].visibility_layer=1
		player_panels_label[i].text=player_names[i]
	
func _on_send_chat_button_pressed():
	var message = str("Player"," ",multiplayer.get_unique_id(),": ",$"Game Chat/Panel2/Send Chat TextEdit".text,"\n") 
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

@rpc func show_connection_lost_menu():
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

func back_to_main_menu():
	main_menu=main_menu_resource.instantiate()
	self.queue_free()
	get_parent().add_child(main_menu)
func _on_timer_player_left_timeout():
	if player_left && multiplayer.is_server():
		request_server_to_update_player_list()
		player_left=false
	pass # Replace with function body.

func kick_player(index:int):
	if multiplayer.is_server():
		multiplayer_session.get_child(index).queue_free()
		rpc_id (multiplayer_session.get_child(index).multiplayer_id,"show_connection_lost_menu")
		multiplayer_peer.disconnect_peer(multiplayer_session.get_child(index).multiplayer_id)
		
func _on_player_2_kick_button_pressed():
	kick_player(1)
	pass # Replace with function body.


func _on_player_3_kick_button_pressed():
	kick_player(2)
	pass # Replace with function body.


func _on_player_4_kick_button_pressed():
	kick_player(3)
	pass # Replace with function body.
