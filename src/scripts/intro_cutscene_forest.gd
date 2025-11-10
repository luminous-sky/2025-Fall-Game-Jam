extends Node2D

const CREDITS = preload("uid://bfu8dn6gbu2u1")

@export var cutscene_dialogue: JSON
@export var start_delay: int = 1

@onready var player: Player = $Player
@onready var dialogue: Dialogue = %Dialogue
@onready var data_manager: DataManager = %DataManager

@onready var transition_screen: TransitionScreen = $TransitionScreen


# Play the introduction dialogue
func _ready() -> void:
	if not cutscene_dialogue:
		return
	
	player.disable_movement()
	
	var dialogue_dictionary: Array[Dictionary] = []
	
	# Same code from interactable_object.gd
	# Read the contents of the dialogue file
	var file := FileAccess.open(cutscene_dialogue.resource_path, FileAccess.READ)
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


func _on_transition_screen_transition_ended(animation_name: StringName) -> void:
	if animation_name == TransitionScreen.FADE_IN_NAME:
		get_tree().change_scene_to_packed(CREDITS)
	
	if animation_name != TransitionScreen.FADE_OUT_NAME:
		return
	
	await get_tree().create_timer(start_delay).timeout
	
	dialogue.show_dialogue()
	
	await dialogue.dialogue_done
	dialogue.hide_dialogue()
	
	# Update data
	var data := data_manager.load_data(DataKeys.TEMPLATE_DATA)
	data[DataKeys.MAP_POSITION_KEY] = DataKeys.FOREST_VALUE
	
	data_manager.save_data(data)
	
	transition_screen.fade_in()
