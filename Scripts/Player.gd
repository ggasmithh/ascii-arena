extends KinematicBody2D
var velocity: Vector2
var BASE_SPEED = 300

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_target", self)

func _physics_process(delta):
	handle_input()
	move_and_collide(velocity * BASE_SPEED * delta)
	
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()

func handle_input():
	velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func hit():
	pass
