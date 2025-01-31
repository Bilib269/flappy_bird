extends CharacterBody2D
const JUMP_VELOCITY = -400.0
const START_POS = Vector2(-300, -150)

var is_alive = true
var is_jumping = false
var is_falling = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	reset()
	
func reset():
	is_alive = true
	is_jumping = false
	is_falling = false
	position = START_POS
	set_rotation(0)

func flap():
	velocity.y = JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	if is_jumping or is_falling:
		var collision = move_and_collide(velocity * delta)
		if collision:
			print("KOLLISION")
			is_alive = false
			SignalBus.player_died.emit()
			get_node("Sprite2D").stop()
			get_node("Sprite2D").hide()
			
		velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_falling:
			#velocity.y = JUMP_VELOCITY
			flap()
			is_jumping = true
			is_falling = false
			set_rotation(deg_to_rad(velocity.y * 0.07))
			$Sprite2D.play()
			
		if velocity.y > 0 and not is_falling:
			is_jumping = false
			is_falling = true
			set_rotation(.9)
			$Sprite2D.stop()
			
