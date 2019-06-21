extends Node2D

const NORMAL_BEHAVIOR = preload("res://Game/Bees/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Bees/Anomaly.tscn")

var Normal = NORMAL_BEHAVIOR.instance()
var Anomaly = ANOMALY_BEHAVIOR.instance()

var Acceleration = Vector2()
var Velocity = Vector2()

func _ready():
	add_child(Normal)
	
func ChangeToGlitch():
	remove_child(Normal)
	add_child(Anomaly)
	
func ChangeToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	
func MoveToward(pos, speed):
	Acceleration += (pos - position).normalized()
		
	Velocity += (Acceleration * speed)
	if Velocity.x < 0:
		$Sprite.flip_h = true
	Acceleration = Vector2()
	Velocity = Velocity.clamped(speed)

func _process(delta):
	position += Velocity * delta
	
	Velocity *= 0.8
	if Velocity.x < 1.0 and Velocity.y < 1.0:
		Velocity = Vector2()