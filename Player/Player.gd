extends KinematicBody2D

var Solution : String = ""
export(int) var Speed = 60
export(int) var MaxHealth = 100
export(int) var MaxStamina = 100

var Health = MaxHealth
var Stamina = MaxStamina

var velocity = Vector2()
var acceleration = Vector2()

func AddBonus(bonus):
	if bonus == "Health":
		print("HEALING")
	elif bonus == "Stamina":
		MaxStamina += 10

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		acceleration.x += Speed
	elif Input.is_action_pressed("ui_left"):
		acceleration.x -= Speed
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= Speed
	elif Input.is_action_pressed("ui_down"):
		acceleration.y += Speed
	
	if Input.is_action_pressed("ui_bonus_speed"):
		if acceleration != Vector2() and Stamina > 0:
			Stamina = max(0, Stamina - 1)
			acceleration *= 2
	else:
		Stamina = min(MaxStamina, Stamina + 0.1)
		
	velocity += acceleration
	velocity = move_and_slide(velocity)
	velocity *= 0.8
	
	acceleration = Vector2()
	$Anim.play("RUN")