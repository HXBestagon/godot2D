extends Area2D
signal hit

const DASH_SPEED = 2.0
const WALK_SPEED = 1.0
const SPEED_TEST = (DASH_SPEED+WALK_SPEED)/2

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = Vector2((screen_size.x/2),((screen_size.y/2)))
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	var velocity_mod = WALK_SPEED
	
	if Input.is_action_pressed("dash"):
		velocity_mod = DASH_SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x += velocity_mod
	if Input.is_action_pressed("move_left"):
		velocity.x -= velocity_mod
	if Input.is_action_pressed("move_down"):
		velocity.y += velocity_mod
	if Input.is_action_pressed("move_up"):
		velocity.y -= velocity_mod

	if velocity.length() > 0.0:
		if velocity_mod < SPEED_TEST:
			velocity = velocity.normalized() * speed
		else:
			velocity = velocity * speed
			$AnimatedSprite2D.animation	= "dash"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

		


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	hide()
	hit.emit()
	$CollisionPolygon2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
	print("gamestart")
