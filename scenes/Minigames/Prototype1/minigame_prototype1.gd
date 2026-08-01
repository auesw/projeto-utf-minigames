extends Minigame

func _process(_delta: float) -> void:
	if Input.is_action_just_released("action1"): minigame_success.emit()
	elif Input.is_action_just_released("action2"): minigame_fail.emit()	
