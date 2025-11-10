extends Area2D

const CAVE_SCENE = preload("uid://ck12hgxt02mc2")

var _can_interact := false
var _player_node: Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var transition_screen: TransitionScreen = $"../TransitionScreen"


func _ready() -> void:
	sprite_2d.visible = false


func _input(event: InputEvent) -> void:
	if not _can_interact or not event.is_action_pressed("interact"):
		return
	
	_can_interact = false
	
	_player_node.disable_movement()
	transition_screen.fade_in()
	sprite_2d.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_can_interact = true
		_player_node = body
		sprite_2d.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_can_interact = false
		_player_node = null
		sprite_2d.visible = false


func _on_transition_screen_transition_ended(animation_name: StringName) -> void:
	if animation_name != TransitionScreen.FADE_IN_NAME:
		return
	
	print("GO!")
	
	get_tree().change_scene_to_packed(CAVE_SCENE)
