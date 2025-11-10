class_name Player
extends CharacterBody2D

@export var SPEED: float = 80.0
var can_move := true

var use_transformed := false

var previous_animation := "down"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	
	# Get the horizontal direction
	var horizontal := Input.get_axis("move_left", "move_right")
	
	# Get the vertical direction
	var vertical := Input.get_axis("move_up", "move_down")
	
	# Set the vertical velocity
	if vertical:
		velocity.y = vertical * SPEED
		
		if vertical < 0:
			if use_transformed:
				animated_sprite_2d.play("up_t")
				previous_animation = "up_t"
			else:
				animated_sprite_2d.play("up")
				previous_animation = "up"
		else:
			if use_transformed:
				animated_sprite_2d.play("down_t")
				previous_animation = "down_t"
			else:
				animated_sprite_2d.play("down")
				previous_animation = "down"
	else:
		velocity.y = 0
	
	# Set the horizontal velocity
	if horizontal:
		velocity.x = horizontal * SPEED
		
		if horizontal < 0:
			if use_transformed:
				animated_sprite_2d.play("left_t")
				previous_animation = "left_t"
			else:
				animated_sprite_2d.play("left")
				previous_animation = "left"
		else:
			if use_transformed: 
				animated_sprite_2d.play("right_t")
				previous_animation = "right_t"
			else:
				animated_sprite_2d.play("right")
				previous_animation = "right"
	else:
		velocity.x = 0
	
	if velocity.x == 0 and velocity.y == 0:
		animated_sprite_2d.play("idle_" + previous_animation)
	
	# Diagonal movement should be normalized
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity.normalized() * SPEED
	
	# Move the player
	move_and_slide()


func disable_movement() -> void:
	can_move = false


func enable_movement() -> void:
	can_move = true


func set_transformed(status: bool) -> void:
	use_transformed = status
	animated_sprite_2d.play("idle_down_t")
