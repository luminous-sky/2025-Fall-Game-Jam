extends Control

const FOREST_SCENE = preload("uid://doayh528xhbvm")

@onready var data_manager: DataManager = $DataManager


func _ready() -> void:
	var data := data_manager.load_data(DataKeys.TEMPLATE_DATA)
	data[DataKeys.PROGRESS_KEY] = DataKeys.MINIGAME_TWO_VALUE
	data_manager.save_data(data, true)
	
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_packed(FOREST_SCENE)
