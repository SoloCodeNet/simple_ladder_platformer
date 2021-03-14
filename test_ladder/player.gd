extends KinematicBody2D

var gravity   := 30.0
var speed     := 200.0
var direction := 0.0
var up_down   := 0.0
var velocity  := Vector2.ZERO
var impulse   := -450.0
var is_ladder := false setget set_is_ladder
var jump      := false
var is_jump   := false
var locked_ladder   := false
var snap      := Vector2.ZERO

func set_is_ladder(value:bool)-> void:
	is_ladder = value

func _ready() -> void:
	add_to_group("player")

func _process(_delta: float) -> void:
	snap = Vector2.DOWN * 10.0
	input_loop()
	ladder_loop()
	anim_loop()
	
	if jump and is_on_floor():
		velocity.y = impulse
		snap = Vector2.ZERO

	if locked_ladder :
		velocity.x = lerp(velocity.x, direction * (speed /2) , 0.3)
	else:
		velocity.x = lerp(velocity.x, direction * speed  , 0.2)
	velocity = move_and_slide_with_snap(velocity,snap, Vector2.UP)
	
	
func ladder_loop()-> void:
	if is_ladder:
		if is_zero_approx(up_down) and not locked_ladder:
			velocity.y += gravity
		else:
			snap = Vector2.ZERO
			velocity.y = (speed * up_down)/2
			locked_ladder = true
	else:
		locked_ladder = false
		velocity.y += gravity
	
func input_loop()-> void:
	jump = Input.is_action_just_pressed("ui_accept")
	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	up_down   = Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	
func anim_loop():
	if direction < 0: $Sprite.flip_h = true
	if direction > 0: $Sprite.flip_h = false
	
	if is_on_floor():
		if is_zero_approx(direction):
			$Sprite.play("idle")
			$Sprite.speed_scale = 1
		else:
			$Sprite.play("walk")
			$Sprite.speed_scale = abs(direction) * 1.3
	else:
		if  locked_ladder:
			$Sprite.play("climb")
			$Sprite.speed_scale = abs(up_down) 
		else:
			$Sprite.play("jump")
			$Sprite.speed_scale = 1
	
