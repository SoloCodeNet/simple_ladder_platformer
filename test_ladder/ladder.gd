extends Area2D

func _input(event: InputEvent) -> void:
	$ground.set_collision_mask_bit(0, !event.is_action_pressed("ui_down") )
	# desactivate the collision 0 only if DOWN is pressed

func _on_ladder_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.is_ladder = true
		

func _on_ladder_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.is_ladder = false
