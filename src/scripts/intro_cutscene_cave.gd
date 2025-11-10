class_name CaveBase
extends Node2D

const MINIGAME_2 = preload("uid://chndrcxl56m26")

@export var first_cutscene_dialogue: JSON
@export var second_cutscene_dialogue: JSON
@export var start_delay: int = 1

var _play_first := true

@onready var player: Player = $Player
@onready var dialogue: Dialogue = %Dialogue
@onready var data_manager: DataManager = %DataManager

@onready var transformation: CanvasLayer = $Transformation
@onready var transformation_scene: VideoStreamPlayer = $Transformation/TransformationScene
@onready var animation_player: AnimationPlayer = $Transformation/AnimationPlayer

@onready var transition_screen: TransitionScreen = $TransitionScreen


# Play the introduction dialogue
func _ready() -> void:
	# Check the data to see what cutscene to play
	var data := data_manager.load_data(DataKeys.TEMPLATE_DATA)
	var cutscene_dialogue = first_cutscene_dialogue
	
	transformation.visible = false
	
	if DataKeys.MAP_POSITION_KEY in data and data[DataKeys.MAP_POSITION_KEY] == DataKeys.CAVE_VALUE:
		if DataKeys.PROGRESS_KEY in data and data[DataKeys.PROGRESS_KEY] == DataKeys.MINIGAME_ONE_VALUE:
			cutscene_dialogue = second_cutscene_dialogue
			_play_first = false
			
			# Play transformation sequence
			transformation.visible = true
			transformation_scene.play()
			
			return
	
	if not cutscene_dialogue:
		return
	
	player.disable_movement()
	
	play_dialogue(cutscene_dialogue)


func _on_transition_screen_transition_ended(animation_name: StringName) -> void:
	if not _play_first and animation_name == TransitionScreen.FADE_IN_NAME:
		print("A")
		get_tree().change_scene_to_packed(MINIGAME_2)
	
	if animation_name != TransitionScreen.FADE_OUT_NAME:
		return
	
	await get_tree().create_timer(start_delay).timeout
	
	dialogue.show_dialogue()
	
	await dialogue.dialogue_done
	dialogue.hide_dialogue()
	
	player.enable_movement()
	
	var data := data_manager.load_data(DataKeys.TEMPLATE_DATA)
	data[DataKeys.MAP_POSITION_KEY] = DataKeys.CAVE_VALUE
	data_manager.save_data(data)


func _on_transformation_scene_finished() -> void:
	print("A")
	
	player.set_transformed(true)
	
	# Pause
	await get_tree().create_timer(1.0).timeout
	
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	play_dialogue(second_cutscene_dialogue)
	
	dialogue.show_dialogue()
	
	await dialogue.dialogue_done
	dialogue.hide_dialogue()
	
	transition_screen.fade_in()


func play_dialogue(json_file: JSON):
	var dialogue_dictionary: Array[Dictionary] = []
	
	# Same code from interactable_object.gd
	# Read the contents of the dialogue file
	var file := FileAccess.open(json_file.resource_path, FileAccess.READ)
	var string_content := file.get_as_text()
	file.close()
	
	var json_content = JSON.parse_string(string_content)
	if json_content == null:
		return
	
	for info in json_content["contents"]:
		var converted: Dictionary = {}
		
		if Dialogue.texture_key in info:
			converted[Dialogue.texture_key] = info[Dialogue.texture_key]
		
		if Dialogue.name_key in info:
			converted[Dialogue.name_key] = info[Dialogue.name_key]
			
		if Dialogue.dialogue_key in info:
			converted[Dialogue.dialogue_key] = info[Dialogue.dialogue_key]
		
		dialogue_dictionary.append(converted)
	
	# Queue the dialogue and then wait until the fade out finishes
	dialogue.add_next_dialogue(dialogue_dictionary)


func get_first_status() -> bool:
	return _play_first
