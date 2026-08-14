extends CharacterBody2D

# Menentukan kecepatan berjalan karakter Tux
const SPEED = 100.0

# Memanggil node AnimatedSprite2D saat game dimulai
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	# 1. Cek input tombol keyboard W, A, S, D
	var pencet_w = Input.is_key_pressed(KEY_W)
	var pencet_s = Input.is_key_pressed(KEY_S)
	var pencet_a = Input.is_key_pressed(KEY_A)
	var pencet_d = Input.is_key_pressed(KEY_D)
	
	# Menentukan apakah ada salah satu tombol arah yang sedang ditekan
	var ada_input = pencet_w or pencet_s or pencet_a or pencet_d
	
	# 2. Logika Pergerakan (Mengubah Nilai Velocity)
	var direction = Vector2.ZERO
	
	if pencet_d:
		direction.x += 1
	if pencet_a:
		direction.x -= 1
	if pencet_s:
		direction.y += 1
	if pencet_w:
		direction.y -= 1
		
	# Normalized agar pergerakan diagonal tidak lebih cepat dari pergerakan lurus
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
	velocity = direction * SPEED
	
	# Fungsi bawaan Godot untuk menjalankan pergerakan fisik karakter
	move_and_slide()
	
	# 3. Logika Animasi berdasarkan input
	if not ada_input:
		# Jika dilepas saat berjalan ke atas/bawah, mainkan animasi diam bawaan
		if _animated_sprite.animation == "berjalan_atas":
			_animated_sprite.play("diam_bawah")
		elif _animated_sprite.animation == "berjalan_bawah":
			_animated_sprite.play("diam_bawah")
		else:
			# Jika terakhir jalan kanan/kiri, stop animasinya di frame awal agar terlihat diam
			_animated_sprite.stop()
	else:
		# Prioritas 1: Kanan / Kiri (Wajib putar animasi samping saat bergerak horizontal)
		if pencet_d:
			_animated_sprite.flip_h = false
			_animated_sprite.play("berjalan_kanan")
		elif pencet_a:
			_animated_sprite.flip_h = true
			_animated_sprite.play("berjalan_kanan")
		# Prioritas 2: Atas / Bawah (Hanya diputar jika tidak sedang menekan Kanan/Kiri)
		elif pencet_w:
			_animated_sprite.play("berjalan_atas")
		elif pencet_s:
			_animated_sprite.play("berjalan_bawah")
