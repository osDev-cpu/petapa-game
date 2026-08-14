extends CharacterBody2D

# Menentukan kecepatan berjalan karakter Tux
const SPEED = 100.0

# Memanggil node AnimatedSprite2D saat game dimulai
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	# 🔒 MULTIPLAYER FIX: Jika ini bukan karakter milik PC kita, abaikan input!
	if not is_multiplayer_authority(): 
		return

	# 1. Cek input tombol keyboard W, A, S, D, Q, E, Z
	var pencet_w = Input.is_key_pressed(KEY_W)
	var pencet_s = Input.is_key_pressed(KEY_S)
	var pencet_a = Input.is_key_pressed(KEY_A)
	var pencet_d = Input.is_key_pressed(KEY_D)
	var pencet_q = Input.is_key_pressed(KEY_Q)
	var pencet_e = Input.is_key_pressed(KEY_E)	
	var pencet_z = Input.is_key_pressed(KEY_Z) 
	
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
		
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
	velocity = direction * SPEED
	move_and_slide()
	
	# 3. Logika Animasi Berdasarkan Daftar Animasi Aslimu
	if not ada_input:
		# Logika Pukul saat Diam
		if pencet_z:
			_animated_sprite.flip_h = false 
			_animated_sprite.play("pukul_kanan") # Pastikan kamu punya animasi bernama "pukul_kanan" di AnimatedSprite2D
		elif pencet_e:
			_animated_sprite.play("pukul_bawah")
		elif pencet_q:
			_animated_sprite.play("pukul_atas")
		else:
			# 🛠️ FIX DIAM: Menggunakan nama animasi diam yang sesuai dengan gambarmu!
			if _animated_sprite.animation == "berjalan_atas" or _animated_sprite.animation == "pukul_atas":
				_animated_sprite.play("diam_atas")
			elif _animated_sprite.animation == "berjalan_bawah" or _animated_sprite.animation == "pukul_bawah":
				_animated_sprite.play("diam_bawah")
			elif _animated_sprite.animation == "berjalan_kanan" or _animated_sprite.animation == "pukul_kanan":
				_animated_sprite.play("diam_kanan")
	else:
		# Logika Animasi saat Bergerak
		if pencet_d:
			_animated_sprite.flip_h = false
			_animated_sprite.play("berjalan_kanan")
		elif pencet_a:
			_animated_sprite.flip_h = true # Balik horizontal untuk jalan kiri
			_animated_sprite.play("berjalan_kanan")
		elif pencet_w:
			_animated_sprite.play("berjalan_atas")
		elif pencet_s:
			_animated_sprite.play("berjalan_bawah")
