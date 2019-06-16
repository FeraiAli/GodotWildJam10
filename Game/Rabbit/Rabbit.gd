extends KinematicBody2D

const NORMAL_BEHAVIOR = preload("res://Game/Rabbit/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Rabbit/Anomaly.tscn")

var Normal = NORMAL_BEHAVIOR.instance()
var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	add_child(Normal)

func _process(delta):
	#CHANGE tHIS PART SO IDLE_NORMAL IS STANDING STILL, JUMP_NORMAL IS MOVING AROUND AND JUMP_GLITCH IS CHASING THE PLAYER
	$Anim.play("JUMP_NORMAL")
	#print(position)
	
func ToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	
func ToAnomaly():
	remove_child(Normal)
	add_child(Anomaly)