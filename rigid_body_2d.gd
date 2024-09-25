extends RigidBody2D

var self_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	self_type = mob_types[randi() % mob_types.size()]
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play(self_type)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
