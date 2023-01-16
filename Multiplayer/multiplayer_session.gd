extends Node
class_name Multiplayer_Session
@onready var player_data:Player_Data =get_node("/root/GAME/Player_Data") as Player_Data
var players:Array[Player]
var players_info:Array[String]
var player_info:String = "Acidzz"
var multiplayer_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var new_player_name:String="Acidzz Host"
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	pass # Replace with function body.


func host_game():
	multiplayer_peer.create_server(5555,4,0,0,0)
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	
	var player_network_data:Player_Network_Data = Player_Network_Data.new()
	player_network_data.player_name=player_data.player_name
	player_network_data.name = str(multiplayer_peer.get_unique_id())
	player_network_data.multiplayer_id=multiplayer_peer.get_unique_id()
	add_child(player_network_data)
	
func set_multiplayer_node(node:Node):
	node.multiplayer=multiplayer
func join_game():
	
	multiplayer_peer.create_client("localhost",5555)
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	multiplayer.connected_to_server.connect(self._on_peer_connected_to_server)
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@rpc(any_peer) func  add_player_data_to_session(p):
	print("player added")
	rpc_id(0,"add_peer_info_to_server",p)
	#players.append(player)
	
	
	
@rpc (any_peer) func add_player_data_to_session_server(id:int,player_name:String):
	print("Added player to server")
	var player_network_data:Player_Network_Data = Player_Network_Data.new()
	player_network_data.player_name=player_name
	player_network_data.name =player_name
	player_network_data.multiplayer_id=id
	add_child(player_network_data)
		#rpc ("update_player_data_to_peers",players)
	
#@rpc (any_peer,call_local) func update_player_data_to_peers(players_server):
#	players=players_server
	
func disconnect_peer():
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer.set_multiplayer_peer(null)
	players.clear()
	
func _on_peer_connected(id):	
	rpc("add_player_data_to_session_server",multiplayer.get_unique_id(),player_data.player_name)
	print(str("Connected to server ",multiplayer.get_unique_id()))
	pass	
		
func _on_peer_connected_to_server(id):
	rpc("add_player_data_to_session_server",multiplayer.get_remote_sender_id(),player_data.player_name)
	print("Connected to server")

@rpc (any_peer,call_local) func sync_new_player_name(player_name):
	new_player_name=player_name
func add_player_to_network_to_server():
	rpc_id(1,"add_player_data_to_session_server",multiplayer.get_unique_id(),player_data.player_name)
@rpc (any_peer) func  add_player_network_data_to_session(id):
	var player_network_data:Player_Network_Data = Player_Network_Data.new()
	player_network_data.name = new_player_name
	player_network_data.multiplayer_id=id
	add_child(player_network_data)
	
@rpc (any_peer,call_local)func sync_player_network_data_to_session(pnd:Player_Network_Data):
	add_child(pnd)
	
func _on_peer_disconnected(id):
#	print("peer_disconnected")
#	if multiplayer.is_server():
#		remove_player_by_id(id)
	pass
func get_multiplayer_name_by_id(id:int)->String:
	for player in players:
		if (player.id==id):
			return player.name
	return "No player with that ID found"
func remove_player_by_id(id:int):
	for player in get_children():
		if (player.multiplayer_id==id):
			player.queue_free()

func _process(delta):
	pass
	
