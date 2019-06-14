extends KinematicBody2D

var Solution : String = ""

const SPEED = 60

var velocity = Vector2()
var acceleration = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		acceleration.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		acceleration.x -= SPEED
		
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= SPEED
	elif Input.is_action_pressed("ui_down"):
		acceleration.y += SPEED
		
	velocity += acceleration
	velocity = move_and_slide(velocity)
	velocity *= 0.8
	
	acceleration = Vector2()