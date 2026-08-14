extends Control

# Hubungkan Node UI ke dalam kode
@onready var menu_panel = $MenuPanel
@onready var multiplayer_panel = $MultiplayerPanel
@onready var room_input = $MultiplayerPanel/RoomInput

# Port jaringan bebas (bisa diganti sesukamu antara 1024 - 49151)
const PORT = 7070 
const DEFAULT_IP = "127.0.0.1" 

func _ready():
	# Contoh hasil drag-and-drop otomatis yang sudah disambung kodenya:
	$MenuPanel/SinglePlayerButton.pressed.connect(_on_single_player_pressed)
	$MenuPanel/MultiplayerButton.pressed.connect(_on_multiplayer_pressed)
	$MultiplayerPanel/CreateRoomButton.pressed.connect(_on_create_room_pressed)
	$MultiplayerPanel/JoinRoomButton.pressed.connect(_on_join_room_pressed)
	$MultiplayerPanel/BackButton.pressed.connect(_on_back_pressed)

	
	# Daftarkan event jaringan bawaan Godot
	multiplayer.peer_connected.connect(_on_player_connected)

# --- NAVIGASI UI ---
func _on_multiplayer_pressed():
	menu_panel.visible = false
	multiplayer_panel.visible = true

func _on_back_pressed():
	menu_panel.visible = true
	multiplayer_panel.visible = false

# --- LOGIKA GAMEPLAY & JARINGAN ---
func _on_single_player_pressed():
	print("Memulai Single Player...")
	# 💡 FIX UTAMA: Simpan status single player langsung ke memori global Godot
	Engine.set_meta("is_single_player", true)
	_start_game()

func _on_create_room_pressed():
	print("Membuat Room (Server)...")
	# 💡 FIX UTAMA: Set ke false karena kita main multiplayer
	Engine.set_meta("is_single_player", false)
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT, 4)
	if error != OK:
		print("Gagal membuat server/room: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	_start_game()

func _on_join_room_pressed():
	# 💡 FIX UTAMA: Set ke false karena kita main multiplayer
	Engine.set_meta("is_single_player", false)
	var ip_address = room_input.text
	if ip_address.is_empty():
		ip_address = DEFAULT_IP 
		
	print("Bergabung ke Room dengan IP: ", ip_address)
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_client(ip_address, PORT)
	if error != OK:
		print("Gagal menyambung ke server/room: ", error)
		return
		
	multiplayer.multiplayer_peer = peer

func _on_player_connected(id):
	print("Pemain baru terhubung! ID: ", id)
	if multiplayer.is_server():
		_start_game()

func _start_game():
	# ⚠️ Pastikan path ini sesuai dengan letak dan nama asli scene Dunia/Map kamu!
	var target_scene = "res://Dunia.tscn"
	
	if ResourceLoader.exists(target_scene):
		get_tree().change_scene_to_file(target_scene)
	else:
		print("Peringatan: File res://Dunia.tscn tidak ditemukan!")
