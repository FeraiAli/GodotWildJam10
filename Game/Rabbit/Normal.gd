extends Node

var Speed = 150
var Acceleration = Vector2()
var Velocity = Vector2()
var InitialPosition = Vector2()
var JumpCounter = 0.0
var JumpDelay = 1

func _ready():
	randomize()
	get_parent().get_node("Anim").playback_speed = 2
	JumpDelay = randf() * 3 + 1
	InitialPosition = get_parent().position
	
func _process(delta):
	JumpCounter += delta
	
	if get_parent().position.distance_to(GameManager.GetPlayer().position) < 150:
		Acceleration += (get_parent().position - GameManager.GetPlayer().position).normalized()
	elif get_parent().position.distance_to(InitialPosition) > 250:
		Acceleration += (InitialPosition - get_parent().position).normalized()
	elif JumpCounter > JumpDelay:
		JumpCounter = 0.0
		var degree = randi() % 360
		var radian = deg2rad(degree)
		var direction = Vector2(cos(radian), sin(radian))
		Acceleration += direction.normalized()

	Velocity += (Acceleration * Speed)
	Acceleration = Vector2()
	Velocity = Velocity.clamped(Speed)
	
	if Velocity == Vector2():
		get_parent().get_node("Anim").play("IDLE_NORMAL")
	else:
		get_parent().position += Velocity * delta
		get_parent().get_node("Anim").play("JUMP_NORMAL")
	
	Velocity *= 0.8
	if Velocity.x < 1.0 and Velocity.y < 1.0:
		Velocity = Vector2()
