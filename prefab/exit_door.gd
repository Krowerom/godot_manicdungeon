extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var random = randi_range(0,100)
		print("Random number: ", random)
		var curSpeed = body.MOVE_DURATION #get speed
		await get_tree().create_timer(0.3).timeout
		body.MOVE_DURATION = 10000 #make it slow
		await get_tree().create_timer(1.5).timeout
		body.MOVE_DURATION = curSpeed #restore speed
		if random < 25:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/game.tscn")
