extends Node2D # (Sesuaikan dengan jenis node utama map kamu, misal Node2D atau TileMap)

# Panggil file scene karaktermu (Ingat trik drag-and-drop jika path foldermu berbeda!)
const PLAYER_SCENE = preload("res://Player.tscn")

func _ready():
	# 💡 AMBIL DATA METADATA: Mengecek apakah pemain memilih Single Player dari menu utama
	var is_single = Engine.get_meta("is_single_player", false)
	
	if is_single:
		print("Mode Single Player Berhasil Aktif!")
		_spawn_player(1) # Spawn 1 karakter saja untuk diri sendiri
		return # ⚠️ BERHENTI DI SINI! Jangan nyalakan sistem jaringan multiplayer
		
	# 🌐 JIKA PEMAIN MEMILIH MULTIPLAYER (Create/Join Room):
	if multiplayer.is_server():
		# Spawn untuk diri sendiri (Si Pembuat Room)
		_spawn_player(1)
		
		# Hubungkan sinyal jika ada client lain yang masuk atau keluar
		multiplayer.peer_connected.connect(_spawn_player)
		multiplayer.peer_disconnected.connect(_remove_player)

func _spawn_player(peer_id: int):
	var player = PLAYER_SCENE.instantiate()
	player.name = str(peer_id) 
	
	# Memberikan hak kontrol keyboard/input ke ID player masing-masing
	player.set_multiplayer_authority(peer_id)
	
	# 🛠️ AMBIL DATA METADATA UNTUK PENENTUAN POSISI SPAWN
	var is_single = Engine.get_meta("is_single_player", false)
	
	if is_single:
		player.global_position = Vector2(200, 200) # Posisi pas di jalan tanah untuk single player
	else:
		player.global_position = Vector2(200 + (peer_id * 40), 200) # Berbaris rapi jika multiplayer
	
	add_child(player)

func _remove_player(peer_id: int):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
