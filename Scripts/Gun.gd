extends KinematicBody2D

signal camera_shake_requested

onready var bullet : = load("res://Scenes/Bullet.tscn")
onready var cooldown_timer : Timer = $Timer
onready var bullet_spawn : Position2D = $BulletSpawn
onready var fire_noise : AudioStreamPlayer2D = $FireNoise

export (float) var muzzle_velocity : = 1500.0
export (float) var bullet_range : = 500.0
export (float) var fire_rate : = 3.0
export (float) var damage : = 12.0

var mouse_pos : Vector2
var can_shoot : bool = true

func _ready() -> void:
	cooldown_timer.wait_time = 1.0 / fire_rate
	cooldown_timer.connect("timeout", self, "_on_cooldown")
	add_to_group("camera_shaker")

func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot"):
		shoot(global_position)

func _on_Enemy_hit() -> void:
	emit_signal("camera_shake_requested")
	
func _on_cooldown() -> void:
	can_shoot = true

func shoot(mouse_pos) -> void:
	if can_shoot:
		can_shoot = !can_shoot
		cooldown_timer.start()
		
		var bullet_instance = bullet.instance()
		bullet_instance.position = bullet_spawn.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.bullet_direction = (bullet_instance.position - mouse_pos).normalized()
		bullet_instance.bullet_speed = muzzle_velocity
		bullet_instance.bullet_range = bullet_range
		bullet_instance.bullet_damage = damage
		bullet_instance.connect("enemy_hit", self, "_on_Enemy_hit")
		get_tree().get_root().add_child(bullet_instance)
		fire_noise.play()
