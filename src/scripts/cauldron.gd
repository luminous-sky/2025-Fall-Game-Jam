extends StaticBody2D

const GAME = preload("uid://on71uouydfpp")

var _can_interact := false
var _player_node: Player

@onready var interact_sprite: Sprite2D = $InteractSprite
@onready var transition_screen: TransitionScreen = $"../TransitionScreen"
@onready var base: CaveBase = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_sprite.visible = false


func _input(event: InputEvent) -> void:
	if not _can_interact or not event.is_action_pressed("interact"):
		return
	
	_can_interact = false
	
	_player_node.disable_movement()
	transition_screen.fade_in()
	interact_sprite.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		_can_interact = true
		_player_node = body
		interact_sprite.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		_can_interact = false
		_player_node = null
		interact_sprite.visible = false


func _on_transition_screen_transition_ended(animation_name: StringName) -> void:
	if animation_name != TransitionScreen.FADE_IN_NAME:
		return
	
	if not base.get_first_status():
		return
	
	print("GO!")
	
	# Short pause
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")
