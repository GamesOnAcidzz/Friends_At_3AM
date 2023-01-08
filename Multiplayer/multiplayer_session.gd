extends Node
class_name Multiplayer_Session
@onready var iplayer:Player = Player.new()
@onready var player_data =get_node("/root/PlayerData") as Node
var players:Array[Player]
var multiplayer_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	iplayer.name=player_data.player.name
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	pass # Replace with function body.

func host_game():
	multiplayer_peer.create_server(5555,4,0,0,0)
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	print(multiplayer.is_server())
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
func set_multiplayer_node(node:Node):
	node.multiplayer=multiplayer
func join_game():
	multiplayer_peer.peer_connected.connect(self._on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(self._on_peer_disconnected)
	multiplayer_peer.create_client("localhost",5555)
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	iplayer.multiplayer_id=multiplayer.get_unique_id()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@rpc func add_player_data_to_session(player:Player):
	if (multiplayer.is_server()):
		players.append(player)
		
func disconnect_peer():
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer.set_multiplayer_peer(null)
	players.clear()
	
func _on_peer_connected(id):
	print("peer connected")
	iplayer.multiplayer_id=multiplayer.get_unique_id()
	rpc("add_player_data_to_session",iplayer)
	
func _on_peer_disconnected(id):
	print("peer connected")
	pass
func get_multiplayer_name_by_id(id:int)->String:
	for player in players:
		if (player.id==id):
			return player.name
	return "No player with that ID found"
func remove_player_by_id(id:int):
	for player in players:
		if (player.id==id):
			players.erase(player)
func _process(delta):
	pass
	
