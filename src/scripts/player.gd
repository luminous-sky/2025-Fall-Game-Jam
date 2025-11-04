extends CharacterBody2D

@export var SPEED: float = 80.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	# Get the horizontal direction
	var horizontal := Input.get_axis("move_left", "move_right")
	
	# Get the vertical direction
	var vertical := Input.get_axis("move_up", "move_down")
	
	# Set the vertical velocity
	if vertical:
		velocity.y = vertical * SPEED
		
		if vertical < 0:
			animated_sprite_2d.play("up")
		else:
			animated_sprite_2d.play("down")
	else:
		velocity.y = 0
	
	# Set the horizontal velocity
	if horizontal:
		velocity.x = horizontal * SPEED
		
		if horizontal < 0:
			animated_sprite_2d.play("left")
		else:
			animated_sprite_2d.play("right")
	else:
		velocity.x = 0
	
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity.normalized() * SPEED
	
	move_and_slide()
