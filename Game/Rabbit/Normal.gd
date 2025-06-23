extends Node

var Speed = 150
var Acceleration = Vector2()
var Velocity = Vector2()
var InitialPosition = Vector2()
var JumpCounter = 0.0
var JumpDelay = 1
var attraction_force = Vector2()

func _ready():
	randomize()
	get_parent().get_node("Anim").speed_scale = 2.0
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
		var radian = deg_to_rad(degree)
		var direction = Vector2(cos(radian), sin(radian))
		Acceleration += direction.normalized()

	# Apply attraction force from mines
	Acceleration += attraction_force
	attraction_force = Vector2()  # Reset after applying

	Velocity += (Acceleration * Speed)
	Acceleration = Vector2()
	Velocity = Velocity.limit_length(Speed)
	
	if Velocity == Vector2():
		get_parent().get_node("Anim").play("IDLE_NORMAL")
	else:
		get_parent().position += Velocity * delta
		get_parent().get_node("Anim").play("JUMP_NORMAL")
	
	Velocity *= 0.8
	if Velocity.x < 1.0 and Velocity.y < 1.0:
		Velocity = Vector2()

func apply_attraction(force: Vector2) -> void:
	attraction_force += force
